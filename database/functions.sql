-- Handle new user signups
create or replace function public.handle_new_user () returns trigger
set
  search_path = '' as $$
begin
  insert into public.profiles (id, full_name, username, email, avatar_url)
  values (
    new.id,
    new.email,
  );
  return new;
end;
$$ language plpgsql security definer;

-- Get tasks sorted by distance
create or replace function get_sorted_tasks_by_location (
  max_distance_km double precision default null,
  status text default null
) returns table (
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