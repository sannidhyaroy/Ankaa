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
  status_filter text default null
) returns table (
  id uuid,
  title text,
  description text,
  status text,
  due_date timestamp,
  location geography,
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
    st_distance(t.location, p.location) / 1000 as distance_km
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
          st_distance(tasks.location, p.location) <= max_distance_km * 1000
        )
    ) t
  order by
    (st_distance(t.location, p.location) is null),
    st_distance(t.location, p.location),
    t.created_on desc;
end;
$$ language plpgsql security definer;