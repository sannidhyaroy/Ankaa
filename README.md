# Ankaa

Bringing neighbours together - one task at a time.

---

## Overview

Ankaa is a Vue based web application designed to foster community engagement by letting neighbors discover, connect and enabling them to collaborate on tasks. Users can post tasks they need help with, and can view tasks posted by others (sorted by closest distance). They can reach out to the relevant person, if they want to collaborate on a task.

---

## Getting Started

### Prerequisites

Ensure you have the following installed:

- [Node.js](https://nodejs.org/) (v16 or later)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/sannidhyaroy/Ankaa.git
    cd Ankaa
    ```
2.  Install node modules:
    ```bash
    npm install
    ```
3.  Configure a Supabase Project:
    - From the [Supabase Dashboard](https://supabase.com/dashboard/projects), select `New Project`.
    - Follow the on-screen instructions to choose your Organization, enter a Project name, a database password and your region (preferably closest to you for lower latency).
    - Keep the default Security Options and Advanced Configuration, and click on `Create Project`.
4.  Note your API details:
    - Select your Supabase Project from the [Supabase Dashboard](https://supabase.com/dashboard/projects).
    - Navigate to `Project Settings` from the left toolbar menu.
    - Nagivate to the `Data API` page under `Configuration` from the left sidebar..
    - Note the Project URL, it's the RESTful endpoint for querying and managing your database. You'll need this later.
      Under Project API Keys, note your anon key, you'll need this key to connect to your database later.
5.  Setup Environment Variables:
    ```bash/
    cp -v .env.example .env
    ```
    - Paste the Project URL from the above step into `VITE_SUPABASE_URL`.
    - Paste your anon key from the above step into `VITE_SUPABASE_ANON_KEY`.
    - It's recommended to lockdown file permissions of your environment file, as it contains confidential information like api keys. On a bash shell, you can use the following command:
    ```bash
    chmod 600 .env
    ```
6.  To preview, you can run the application in dev mode:
    ```bash
    npm run dev
    ```

---

### License

Ankaa is licensed under the [GNU General Public License (GPL) v3.0](https://github.com/sannidhyaroy/Ankaa/blob/main/LICENSE).
