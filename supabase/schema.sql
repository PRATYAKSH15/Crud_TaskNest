-- ==============================================================================
-- TaskNest Database Schema & Row Level Security (RLS) Setup
-- ==============================================================================
-- Run this script in the Supabase SQL Editor (https://supabase.com/dashboard)
-- 
-- Tagline: "Organize your work. Simplify your day."
-- ==============================================================================

-- 1. Create the `tasks` table
CREATE TABLE IF NOT EXISTS public.tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'todo' CHECK (status IN ('todo', 'done')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 2. Create index on foreign key and frequent filter/sort columns
CREATE INDEX IF NOT EXISTS idx_tasks_user_id ON public.tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON public.tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON public.tasks(created_at DESC);

-- 3. Automatic updated_at trigger function
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_tasks_updated_at ON public.tasks;
CREATE TRIGGER set_tasks_updated_at
    BEFORE UPDATE ON public.tasks
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- 5. Row Level Security Policies
-- SELECT: Users can only view their own tasks
CREATE POLICY "Users can select own tasks"
    ON public.tasks
    FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

-- INSERT: Users can only create tasks for themselves
CREATE POLICY "Users can insert own tasks"
    ON public.tasks
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- UPDATE: Users can only update their own tasks
CREATE POLICY "Users can update own tasks"
    ON public.tasks
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- DELETE: Users can only delete their own tasks
CREATE POLICY "Users can delete own tasks"
    ON public.tasks
    FOR DELETE
    TO authenticated
    USING (auth.uid() = user_id);

