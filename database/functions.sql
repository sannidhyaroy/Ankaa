-- Handle new user signups
create or replace function public.handle_new_user () returns trigger
set
  search_path = '' as $$
begin
  insert into public.profiles (id, username, email)
  values (
    new.id,
    new.id, -- username defaults to the user's id
    new.email
  );
  return new;
end;
$$ language plpgsql security definer;

-- Return Geography point
create or replace function make_geography_point (lat double precision, lng double precision) returns geography as $$
  select ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography;
$$ language sql immutable;

-- Get distance between two points
create or replace function public.accurate_distance_km (point1 geography, point2 geography) returns double precision language sql immutable as $$
  select ST_Distance(
    point1,
    point2
  ) / 1000;
$$;

-- Create a new task
create or replace function create_task (
  title text,
  description text default null,
  status text default 'todo',
  due_date timestamp default null,
  location_lat double precision default null,
  location_lng double precision default null
) returns void language plpgsql security definer
set
  search_path = public as $$
begin
  insert into tasks (
    title,
    description,
    status,
    due_date,
    location,
    created_by
  )
  values (
    title,
    description,
    status,
    due_date,
    case 
      when location_lat is not null and location_lng is not null 
      then make_geography_point(location_lat, location_lng)
      else null 
    end,
    auth.uid()
  );
end;
$$;

-- Get Profile
create or replace function get_profile (profile_id uuid default null) returns table (
  id uuid,
  full_name text,
  username text,
  phone text,
  email text,
  location geography (Point, 4326),
  created_on timestamp,
  distance_km double precision
) language sql security definer
set
  search_path = public as $$
  with caller as (
    select id, location from profiles where id = auth.uid()
  )
  select 
    p.id,
    p.full_name,
    p.username,
    p.phone,
    p.email,
    p.location,
    p.created_on,
    case 
      when p.location is not null and c.location is not null then
        accurate_distance_km(p.location, c.location)
      else null
    end as distance_km
  from profiles p
  left join caller c on true
  where p.id = coalesce(profile_id, auth.uid());
$$;

-- Update profile
create or replace function update_profile (
  full_name text,
  username text,
  phone text,
  location_lat double precision,
  location_lng double precision
) returns void language plpgsql security definer
set
  search_path = public as $$
begin
  update profiles
  set 
    full_name = update_profile.full_name,
    username = update_profile.username,
    phone = update_profile.phone,
    location = case 
      when location_lat is not null and location_lng is not null 
      then make_geography_point(location_lat, location_lng)
      else null 
    end
  where id = auth.uid();
end;
$$;

-- Get tasks sorted by distance
create or replace function get_sorted_tasks_by_location (
  max_distance_km double precision default null,
  status_filter text default null
) returns table (
  id uuid,
  title text,
  description text,
  status text,
  due_date timestamp,
  location geography (Point, 4326),
  assignee uuid,
  created_by uuid,
  created_on timestamp,
  distance_km double precision
) as $$
begin
  return query
  select
    t.id,
    t.title,
    t.description,
    t.status,
    t.due_date,
    t.location,
    t.assignee,
    t.created_by,
    t.created_on,
    accurate_distance_km(t.location, p.location) as distance_km
  from
    (select * from profiles where profiles.id = auth.uid()) p,
    lateral (
      select * from tasks
      where
        (
          status_filter = 'todo' and tasks.status = 'todo'
        ) or (
          status_filter = 'in_progress' and tasks.status = 'in_progress'
        ) or (
          status_filter = 'done' and tasks.status = 'done'
        ) or (
          status_filter = 'all'
        ) or (
          status_filter is null and tasks.status != 'done'
        )
        and (
          max_distance_km is null or
          accurate_distance_km(tasks.location, p.location) <= max_distance_km
        )
    ) t
  order by
    (t.location is null),
    accurate_distance_km(t.location, p.location),
    t.created_on desc;
end;
$$ language plpgsql security definer;