-- Create tables
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  phone text,
  created_on timestamp default now()
);
create table tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  created_by uuid references profiles(id) on delete set null,
  created_on timestamp default now(),
  is_completed boolean default false
);

-- Enable RLS
alter table profiles enable row level security;
alter table tasks enable row level security;

-- Create policies for tasks table
create policy "Allow logged-in users to read any task"
on tasks
as PERMISSIVE
for select
to authenticated
using (true);

create policy "Allow users to insert their own tasks"
on tasks
as PERMISSIVE
for insert
to authenticated
with check (auth.uid() = created_by);

create policy "Allow users to update their own tasks"
on tasks
as PERMISSIVE
for update
to authenticated
using (auth.uid() = created_by)
with check (auth.uid() = created_by);

create policy "Allow users to delete their own tasks"
on tasks
as PERMISSIVE
for delete
to authenticated
using (auth.uid() = created_by);

-- Create policies for profiles table
create policy "Logged-in users can read any profile"
on profiles
as PERMISSIVE
for select
to authenticated
using (true);

create policy "Users can update their own profile"
on profiles
as PERMISSIVE
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "Users can insert their own profile"
on profiles
as PERMISSIVE
for insert
to authenticated
with check (auth.uid() = id);

create policy "No one can delete profiles"
on profiles
as RESTRICTIVE
for delete
to authenticated
using (false);

-- Add PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;
ALTER TABLE tasks ADD COLUMN location geography(Point, 4326);
ALTER TABLE profiles ADD COLUMN location geography(Point, 4326);

-- Create RPC function to get tasks sorted by distance
create or replace function get_sorted_tasks_by_location(
  max_distance_km double precision default null,
  status text default null
)
returns table (
  id uuid,
  title text,
  description text,
  created_by uuid,
  created_on timestamp,
  is_completed boolean,
  location geography,
  distance_km double precision
) as $$
begin
  return query
  select
    t.id,
    t.title,
    t.description,
    t.created_by,
    t.created_on,
    t.is_completed,
    t.location,
    st_distance(t.location, p.location) / 1000 as distance_km
  from
    (select * from profiles where profiles.id = auth.uid()) p,
    lateral (
      select * from tasks
      where
        (
          (status = 'closed' and tasks.is_completed = true) or
          (status = 'all') or
          (status is null and tasks.is_completed = false)
        )
        and (
          max_distance_km is null or
          st_distance(tasks.location, p.location) <= max_distance_km * 1000
        )
    ) t
  order by
    (st_distance(t.location, p.location) is null),
    st_distance(t.location, p.location),
    t.created_on desc;
end;
$$ language plpgsql security definer;
