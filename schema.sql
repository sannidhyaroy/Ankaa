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