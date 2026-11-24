import subprocess
import os

os.chdir(r'c:\Users\PRATYAKSH\OneDrive\Desktop\Assignment\tasknest')

# Unstage everything first
subprocess.run(['git', 'reset'], check=True)

commits = [
    ([
        'package.json',
        'package-lock.json',
        'tsconfig.json',
        'tailwind.config.ts',
        'postcss.config.js',
        'next.config.mjs',
        'eslint.config.mjs',
        '.gitignore',
        'public',
        'app/globals.css',
        'app/layout.tsx',
        'app/favicon.ico',
        'lib/utils.ts'
    ], "chore: initialize Next.js project"),
    ([
        'supabase',
        'types',
        'lib/supabase',
        'middleware.ts',
        'app/auth'
    ], "feat: configure Supabase client and authentication"),
    ([
        'app/login',
        'app/signup',
        'app/page.tsx'
    ], "feat: implement login and signup pages"),
    ([
        'components/dashboard'
    ], "feat: build responsive dashboard UI"),
    ([
        'components/tasks',
        'app/dashboard'
    ], "feat: implement task CRUD operations and status management"),
    ([
        'README.md',
        'AI_LOG.md',
        '.env.example'
    ], "docs: add README and AI usage log")
]

for files, msg in commits:
    subprocess.run(['git', 'add'] + files, check=True)
    subprocess.run(['git', 'commit', '-m', msg], check=True)

subprocess.run(['git', 'log', '--oneline'], check=True)

