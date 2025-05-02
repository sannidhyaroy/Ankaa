# Ankaa

[![Netlify Status](https://api.netlify.com/api/v1/badges/1f5898f9-62ea-4651-bd54-ec9d783a6b4a/deploy-status)](https://app.netlify.com/sites/ankaaunite/deploys)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Vue 3](https://img.shields.io/badge/Vue-3-4FC08D?style=flat-square)](https://vuejs.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-4.5-blue?style=flat-square)](https://www.typescriptlang.org)

Bringing neighbours together - one task at a time.

---

## Table of Contents

1. [Overview](#overview)
2. [Tech Stack](#tech-stack)
3. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
4. [License](#license)

---

## Overview

Ankaa is a Vue based web application designed to foster community engagement by letting neighbors discover, connect and enabling them to collaborate on tasks. Users can post tasks they need help with, and can view tasks posted by others (sorted by closest distance). They can reach out to the relevant person, if they want to collaborate on a task.

**Hosted Instance:** Ankaa is deployed to Netlify at [https://ankaa.thenoton.com](https://ankaa.thenoton.com).

---

## Tech Stack

- [Vue 3](https://vuejs.org)
- [Vite](https://vite.dev)
- [TypeScript](https://www.typescriptlang.org)
- [Supabase](https://supabase.com)

**`NOTE`**: This project uses [Supabase](https://supabase.com) for [authentication](https://supabase.com/auth) and [database](https://supabase.com/database)([PostgreSQL](https://www.postgresql.org)) services. If you encounter issues with authentication or database-related functions, please visit [Supabase Status](https://status.supabase.com) to check if Supabase services are fully operational. Also, Supabase by default imposes rate-limits to 2 emails/hour, unless increased manually. Note that we are not affiliated with Supabase, and any outages or disruptions related to Supabase are beyond our control.

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
    - Navigate to the `Data API` page under `Configuration` from the left sidebar.
    - Note the Project URL, it's the RESTful endpoint for querying and managing your database. You'll need this later.
      Under Project API Keys, note your anon key, you'll need this key to connect to your database later.
5.  Setup Environment Variables:
    ```bash
    cp -v .env.example .env
    ```
    - Paste the Project URL from the above step into `VITE_SUPABASE_URL`.
    - Paste your anon key from the above step into `VITE_SUPABASE_ANON_KEY`.
    - It's recommended to lockdown file permissions of your environment file, as it contains confidential information like api keys. On a bash shell, you can use the following command:
      ```bash
      chmod 600 .env
      ```
6.  Setup PostgreSQL:
    - For detailed instructions on setting up the database, refer to the [Database README](./database/README.md).
7.  Test it out:
    - To preview, you can run the application in dev mode:
      ```bash
      npm run dev
      ```

---

### License

Ankaa is licensed under the [GNU General Public License (GPL) v3.0](https://github.com/sannidhyaroy/Ankaa/blob/main/LICENSE).
