MOLOKSA3ASMP RANK APPLICATION WEBSITE
=====================================

Included files
- index.html: public website with five application types: Media, Streamer, YouTuber, Admin, Helper.
- admin.html: private login dashboard for reviewing, filtering, accepting and rejecting applications.
- schema.sql: Supabase database and access policies.

IMPORTANT
This is a static website starter. The forms will not save submissions until you connect Supabase.
Never put a Supabase service_role/secret key in HTML. Only use the Project URL and public anon/publishable key.

SETUP (FREE HOSTING)
1. Create a project at https://supabase.com/
2. Open SQL Editor in the Supabase project and run all of schema.sql.
3. Open Project Settings / API and copy the Project URL and public anon/publishable key.
4. In BOTH index.html and admin.html, replace:
   PASTE_YOUR_SUPABASE_PROJECT_URL_HERE
   PASTE_YOUR_SUPABASE_ANON_KEY_HERE
   with the values from your own project.
5. In Supabase Authentication, create your admin user.
6. Copy that user's UUID from Authentication > Users.
7. In SQL Editor run (replace the UUID):
   insert into public.media_admins (user_id) values ('YOUR-ADMIN-USER-UUID');
8. Upload index.html, admin.html, schema.sql, and this README to the root of your GitHub repository.
9. In GitHub repository Settings > Pages, choose Deploy from a branch, branch main, folder /(root), then Save.
10. Your public site is at https://YOUR-GITHUB-USERNAME.github.io/YOUR-REPOSITORY/
    Admin dashboard: add admin.html to the end of that URL.

UPGRADING AN EXISTING SUPABASE DATABASE
Run schema.sql in SQL Editor. The script adds the new fields and rank options. If an earlier version has a constraint that differs, review any SQL error before continuing.

SECURITY
- Public visitors can submit applications but cannot read them.
- Only UUIDs listed in media_admins can read/update applications.
- Never share admin passwords or secret keys.
- This starter is not a substitute for a production anti-spam/rate-limit system.
