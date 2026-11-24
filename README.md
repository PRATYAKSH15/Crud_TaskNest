# TaskNest

> **"Organize your work. Simplify your day."**

TaskNest is a production-quality, responsive task management web application built with **Next.js (App Router)**, **TypeScript**, **Tailwind CSS**, and **Supabase (PostgreSQL, Auth & Row Level Security)**.

This project was built for a technical assessment for the Software Developer Intern position at Architech Labs.

---

## 🚀 Features

- **🔐 Supabase Authentication**: Secure user registration, login, and session persistence using `@supabase/ssr` with cookie-based session handling.
- **🛡️ Row Level Security (RLS)**: Enforced at the PostgreSQL level (`auth.uid() = user_id`) to ensure each user can strictly access, create, modify, and delete only their own tasks.
- **⚡ Complete Task CRUD**:
  - **Create**: Add new tasks with title, description, and status using a clean modal.
  - **Read**: View user's tasks sorted newest first with loading states and empty states.
  - **Update**: Edit title, description, and status via a modal.
  - **Delete**: Remove tasks with an interactive confirmation dialog.
  - **Quick Status Toggle**: Mark tasks as "To Do" or "Done" with a single click directly from the list.
- **📊 Real-time Dashboard Statistics**: Automatically calculates Total Tasks, Pending Tasks (To Do), and Completed Tasks with percentage indicators.
- **🔍 Search & Filter**: Real-time task search by title/description and instant filtering by status (`All`, `To Do`, `Completed`).
- **📱 Responsive Modern SaaS UI**: Minimal, clean design with dark navy text, subtle borders, indigo accents, and full responsiveness across mobile, tablet, and desktop devices.
- **🛡️ Route Protection**: Middleware redirects unauthenticated users to `/login` and authenticated users away from auth pages to `/dashboard`.

---

## 🛠️ Technology Stack

| Layer | Technology |
|---|---|
| **Framework** | [Next.js](https://nextjs.org/) (App Router, Version 14) |
| **Language** | [TypeScript](https://www.typescriptlang.org/) |
| **Styling** | [Tailwind CSS](https://tailwindcss.com/) |
| **Icons** | [Lucide React](https://lucide.dev/) |
| **Database** | [Supabase PostgreSQL](https://supabase.com/) |
| **Auth & Security**| Supabase Auth + PostgreSQL Row Level Security (RLS) |
| **Deployment** | [Vercel](https://vercel.com/) |
| **Version Control**| Git + GitHub |

---

## 📐 Project Structure

```text
tasknest/
├── app/
│   ├── auth/
│   │   └── callback/
│   │       └── route.ts        # Supabase Auth code exchange handler
│   ├── dashboard/
│   │   └── page.tsx            # Protected dashboard with task CRUD & stats
│   ├── login/
│   │   └── page.tsx            # Sign in page
│   ├── signup/
│   │   └── page.tsx            # Registration page with validation
│   ├── globals.css             # Tailwind CSS tokens
│   ├── layout.tsx              # Root layout with font and metadata
│   └── page.tsx                # Marketing landing page with hero & CTAs
├── components/
│   ├── dashboard/
│   │   ├── Header.tsx          # Dashboard greeting, date, and Add Task CTA
│   │   ├── Sidebar.tsx         # Responsive sidebar navigation & profile
│   │   └── StatsCards.tsx      # Total, Pending, and Completed statistics
│   └── tasks/
│       ├── DeleteDialog.tsx    # Confirmation modal for task deletion
│       ├── TaskCard.tsx        # Individual task card with toggle & actions
│       └── TaskModal.tsx       # Modal for creating and editing tasks
├── lib/
│   ├── supabase/
│   │   ├── client.ts           # Browser client (createBrowserClient)
│   │   ├── middleware.ts       # Session refreshing & route protection helper
│   │   └── server.ts           # Server client (createServerClient)
│   └── utils.ts                # Tailwind merge and clsx helper
├── supabase/
│   └── schema.sql              # Database table, triggers, indexes, and RLS policies
├── types/
│   └── database.ts             # TypeScript definitions for Task and stats
├── .env.example                # Example environment variables
├── middleware.ts               # Next.js route guard middleware
├── package.json
├── README.md
└── AI_LOG.md                   # AI-assisted development audit log
```

---

## 🗄️ Database Setup (Supabase PostgreSQL)

1. Create a project at [supabase.com](https://supabase.com/).
2. Navigate to the **SQL Editor** in the Supabase dashboard.
3. Open [`supabase/schema.sql`](supabase/schema.sql) from this repository and run the script:

```sql
-- Create tasks table
CREATE TABLE IF NOT EXISTS public.tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'todo' CHECK (status IN ('todo', 'done')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can select own tasks" ON public.tasks
    FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own tasks" ON public.tasks
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tasks" ON public.tasks
    FOR UPDATE TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own tasks" ON public.tasks
    FOR DELETE TO authenticated USING (auth.uid() = user_id);
```

4. Go to **Project Settings** > **API** to copy your **Project URL** and **anon public key**.

---

## 💻 Local Installation & Setup

### 1. Clone the repository
```bash
git clone https://github.com/<your-username>/tasknest.git
cd tasknest
```

### 2. Install dependencies
```bash
npm install
```

### 3. Configure Environment Variables
Create a `.env.local` file in the root directory:
```bash
cp .env.example .env.local
```
Add your Supabase credentials:
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-public-key
```

### 4. Run the development server
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## 🚢 Deployment (Vercel)

1. Push your repository to GitHub.
2. Log into [vercel.com](https://vercel.com/) and click **Add New** > **Project**.
3. Import your `tasknest` repository.
4. In the **Environment Variables** section, add:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
5. Click **Deploy**.
6. In your Supabase dashboard under **Authentication** > **URL Configuration**:
   - Set **Site URL** to your Vercel deployment URL (e.g., `https://tasknest.vercel.app`).
   - Add `https://<your-project>.vercel.app/auth/callback` to **Redirect URLs**.

---

## 🔮 Future Improvements

- Add task priority levels (Low, Medium, High).
- Due date selection with upcoming deadline reminders.
- Task tagging and category labels.
- Supabase Realtime subscriptions for instant multi-tab sync.
- Dark mode toggle with persisted preference.

---

## 📄 License

MIT License. Developed as a technical assessment for Architech Labs.
