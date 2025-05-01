-- This trigger automatically creates a profile entry when a new user signs up via Supabase Auth.
create trigger on_auth_user_created
after insert on auth.users for each row
execute procedure public.handle_new_user ();

-- This trigger automatically updates the profile entry when a user updates their email in Supabase Auth.
create trigger on_auth_user_updated
after update of email on auth.users for each row
execute procedure public.handle_update_email();