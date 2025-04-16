-- Enable RLS
alter table profiles enable row level security;

alter table tasks enable row level security;

alter table volunteers enable row level security;

-- Create policies for tasks table
create policy "Allow logged-in users to read any task" on tasks as PERMISSIVE for
select
  to authenticated using (true);

create policy "Allow users to insert their own tasks" on tasks as PERMISSIVE for insert to authenticated
with
  check (auth.uid () = created_by);

create policy "Allow users to update their own tasks" on tasks as PERMISSIVE
for update
  to authenticated using (auth.uid () = created_by)
with
  check (auth.uid () = created_by);

create policy "Allow users to delete their own tasks" on tasks as PERMISSIVE for delete to authenticated using (auth.uid () = created_by);

-- Create policies for profiles table
create policy "Logged-in users can read any profile" on profiles as PERMISSIVE for
select
  to authenticated using (true);

create policy "Users can update their own profile" on profiles as PERMISSIVE
for update
  to authenticated using (auth.uid () = id)
with
  check (auth.uid () = id);

create policy "Users can insert their own profile" on profiles as PERMISSIVE for insert to authenticated
with
  check (auth.uid () = id);

create policy "No one can delete profiles" on profiles as RESTRICTIVE for delete to authenticated using (false);

-- Create policies for volunteers table
create policy "Allow logged-in users to view volunteers for tasks" on volunteers as PERMISSIVE for
select
  to authenticated using (true);

create policy "Allow users to volunteer for tasks" on volunteers as PERMISSIVE for insert to authenticated
with
  check (auth.uid () = volunteer_id);

create policy "Allow users to remove themselves as volunteers" on volunteers as PERMISSIVE for delete to authenticated using (auth.uid () = volunteer_id);