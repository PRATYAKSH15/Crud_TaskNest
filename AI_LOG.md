# AI-Assisted Development Log (AI_LOG.md)

This log documents the authentic AI-assisted development workflow used during the technical assessment for **TaskNest**.

---

## 1. AI Tools Used

- **Primary AI Assistant**: Antigravity (Powered by Google Gemini 3.8 Flash)
- **Environment**: Windows 11, Node.js v22.18.0, npm 11.2.0, PowerShell Shell

---

## 2. Top Prompts Used During Development

### Prompt 1: Initial Technical Architecture & Scope
> *"Act as a senior full-stack developer and UI/UX engineer. Build a production-quality, simple task management web application called TaskNest. Requirements: Next.js App Router, TypeScript, Tailwind CSS, Lucide React, Supabase Auth + PostgreSQL with Row Level Security (RLS), full CRUD, modern SaaS dashboard with Indigo accents."*

**Outcome**: Formulated project architecture, database schema with four isolated RLS policies (`SELECT`, `INSERT`, `UPDATE`, `DELETE`), and modular directory structure separating UI components from Supabase data utilities.

### Prompt 2: Database Schema & Row Level Security Setup
> *"Provide complete SQL schema and RLS policies for table tasks with columns id (UUID), user_id (UUID referencing auth.users), title, description, status (todo/done), created_at, and updated_at with automatic trigger."*

**Outcome**: Produced production-ready `supabase/schema.sql` with automatic `updated_at` trigger function, index creation on `user_id`, `status`, and `created_at`, plus four discrete RLS policies using `auth.uid() = user_id`.

### Prompt 3: Fixing Windows / OneDrive File Locks & Package Compatibility
> *"Analyze npm installation failure and lock contention in OneDrive directory. Migrate project configuration to battle-tested Next.js LTS with compatible peer dependencies."*

**Outcome**: Diagnosed background OneDrive sync lock (`EBUSY: resource busy or locked`), cleaned stalled directories, and stabilized dependencies using Next.js 14 LTS and Tailwind CSS 3.4.

### Prompt 4: Production Build Verification & Type Safety Fixes
> *"Diagnose Next.js build errors regarding next.config.ts and Supabase middleware TypeScript parameter typing."*

**Outcome**: Converted `next.config.ts` to `next.config.mjs`, fixed parameter typing on `setAll(cookiesToSet: { name: string; value: string; options?: Record<string, unknown> }[])`, and wrapped search parameters in `<Suspense>` for static export compatibility.

---

## 3. How AI Assisted Across Development Areas

### Architecture
- Structured the application with separation of concerns:
  - Database access layer in `lib/supabase/` utilizing `@supabase/ssr` (separate browser and server client creators).
  - Middleware route guard (`middleware.ts`) enforcing authenticated access to `/dashboard` and redirecting logged-in users away from auth pages.
  - Granular component tree (`Sidebar`, `Header`, `StatsCards`, `TaskCard`, `TaskModal`, `DeleteDialog`).

### Coding
- Created type-safe definitions (`types/database.ts`).
- Built optimistic UI updates for task status toggles (marking "Done" or "To Do" updates local state instantly with automatic rollback if database update encounters network failure).
- Automated calculation of task statistics (`Total`, `Pending`, `Completed`, and completion percentages) using `useMemo`.

### UI & Styling
- Designed a modern SaaS interface according to guidelines:
  - Slate background (`bg-slate-50`), navy text (`text-slate-900`), and subtle borders (`border-slate-200`).
  - Indigo primary accents (`bg-indigo-600`, `text-indigo-600`).
  - Distinct badge colors: orange/amber for "To Do" and emerald/green for "Done".
  - Full mobile responsiveness with toggleable slide-over navigation.

---

## 4. Genuine Examples Where AI-Generated Code Was Incorrect or Required Debugging

### Example 1: Next.js Config File Format Incompatibility
- **The Issue**: When the project was initially scaffolded with modern defaults, a `next.config.ts` TypeScript configuration file was created. When running `next build`, Next.js 14 failed with:
  ```text
  Error: Configuring Next.js via 'next.config.ts' is not supported. Please replace the file with 'next.config.js' or 'next.config.mjs'.
  ```
- **Identification**: Caught during the local production build verification step (`npm run build`).
- **Resolution**: Created `next.config.mjs` exporting standard `nextConfig` and removed `next.config.ts`.

### Example 2: Implicit `any` Type Error in Supabase SSR Middleware
- **The Issue**: In `lib/supabase/middleware.ts` and `lib/supabase/server.ts`, the cookie handler `setAll(cookiesToSet)` had no explicit parameter type:
  ```text
  Type error: Parameter 'cookiesToSet' implicitly has an 'any' type.
  ```
- **Identification**: Flagged by the TypeScript type checker during static page generation.
- **Resolution**: Explicitly typed `cookiesToSet` as `{ name: string; value: string; options?: Record<string, unknown> }[]`, resolving the build block.

### Example 3: Synchronous vs. Asynchronous `cookies()` in Next.js 14
- **The Issue**: An earlier draft used `const cookieStore = await cookies()` (a Next.js 15 asynchronous pattern). In Next.js 14, `cookies()` is synchronous.
- **Identification**: Reviewed during server client compilation.
- **Resolution**: Replaced with `const cookieStore = cookies()`.

### Example 4: Unwrapped `useSearchParams()` During Next.js Page Prerendering
- **The Issue**: In `app/login/page.tsx`, `useSearchParams()` was called directly at top-level of the page component. In Next.js App Router, using search params during static prerendering requires a `<Suspense>` boundary to prevent de-opting the entire page.
- **Identification**: Proactively identified during build configuration review.
- **Resolution**: Split `LoginPage` into `LoginForm` and wrapped it within a `<Suspense>` boundary, ensuring smooth client rendering.

---

## 5. Summary of Verification

- [x] TypeScript builds with 0 errors (`npm run build` succeeds).
- [x] All 5 App Router routes (`/`, `/login`, `/signup`, `/dashboard`, `/auth/callback`) generated.
- [x] Database schema & RLS policies documented in `supabase/schema.sql`.
- [x] Cookie-based authentication middleware configured.
- [x] Clean, responsive UI with Lucide icons and Tailwind CSS.

