-- Create indexes for location on profiles table
create index if not exists idx_profiles_location on profiles using gist (location);

-- Create indexes for location on tasks table
create index if not exists idx_tasks_location on tasks using gist (location);

-- Create indexes for status on tasks table
create index if not exists idx_tasks_status_todo on tasks (status) where status = 'todo';