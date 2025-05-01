-- Create tables
create table profiles (
  id uuid references auth.users (id) on delete cascade not null primary key,
  full_name text,
  username text unique not null,
  avatar_url text, -- Support is unlikely, just for future-proofing
  phone text unique,
  email text,
  location geography (Point, 4326),
  created_on timestamp default now(),
  constraint username_length check (char_length(username) >= 3)
);

create table tasks (
  id uuid primary key default gen_random_uuid (),
  title text not null,
  description text,
  status text check (status in ('todo', 'in_progress', 'done')),
  due_date timestamp,
  location geography (Point, 4326),
  assignee uuid references profiles (id) on delete set null,
  created_by uuid references profiles (id) on delete set null,
  created_on timestamp default now()
);

create table volunteers (
  id uuid primary key default gen_random_uuid (),
  task_id uuid references tasks (id) on delete cascade,
  volunteer_id uuid references profiles (id) on delete cascade,
  created_on timestamp default now(),
  unique (task_id, volunteer_id) -- unique only if the same user volunteers for the same task
);