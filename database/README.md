# Database Setup

This document provides instructions for setting up the database for the Ankaa project. The database is hosted on Supabase, which provides PostgreSQL as a service with additional features like row-level security.

---

## Prerequisites

Before setting up the database, ensure you have the following:

- A Supabase account. You can sign up at [Supabase](https://supabase.com) or Self-Host [Supabase](https://supabase.com/docs/guides/self-hosting) and [Supabase Studio](https://supabase.com/blog/supabase-studio) on your own infrastructure.

---

## Set Up the Database

### 1. Create a New Supabase Project

1. Log in to the [Supabase Dashboard](https://supabase.com/dashboard/projects).
2. Click on `New Project`.
3. Enter the project details:
   - **Organization**: Select your organization.
   - **Project Name**: Enter a name for your project.
   - **Database Password**: Set a secure password for your database.
   - **Region**: Choose a region close to your location for better performance.
4. Click `Create Project`.

### 2. Enable Required Extensions

1. Open the `SQL Editor` in the Supabase Dashboard.
2. Copy the contents of the `extensions.sql` file from this repository.
3. Paste the SQL commands into the editor and click `Run`.

### 3. Import the Schema

1. Open a new query tab in the `SQL Editor`.
2. Copy the contents of the `schema.sql` file from this repository.
3. Paste the SQL commands into the editor and click `Run`.

### 4. Add Functions

1. Open a new query tab in the `SQL Editor`.
2. Copy the contents of the `functions.sql` file.
3. Paste the SQL commands into the editor and click `Run`.

### 5. Set Up Row-Level Security (RLS) Policies

1. Open a new query tab in the `SQL Editor`.
2. Copy the contents of the `policies.sql` file.
3. Paste the SQL commands into the editor and click `Run`.

### 6. Configure Triggers

1. Open a new query tab in the `SQL Editor`.
2. Copy the contents of the `triggers.sql` file.
3. Paste the SQL commands into the editor and click `Run`.

---

For more details about the Ankaa project, refer to the main [README](../README.md).
