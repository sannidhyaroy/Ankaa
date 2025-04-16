-- This trigger automatically creates a profile entry when a new user signs up via Supabase Auth.
create trigger on_auth_user_created
after insert on auth.users for each row
execute procedure public.handle_new_user ();