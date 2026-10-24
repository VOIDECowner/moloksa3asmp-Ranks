-- Run this in Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.media_applications (
  id uuid primary key default gen_random_uuid(),
  rank text not null default 'Media' check (rank in ('Media','Streamer','YouTuber','Admin','Helper')),
  minecraft_username text not null check (char_length(minecraft_username) between 3 and 16),
  discord_username text not null check (char_length(discord_username) between 1 and 80),
  platform text,
  channel_url text,
  followers text,
  age integer,
  experience text,
  reason text not null check (char_length(reason) between 20 and 1200),
  status text not null default 'pending' check (status in ('pending','accepted','rejected')),
  created_at timestamptz not null default now(),
  check (
    (rank in ('Media','Streamer','YouTuber') and platform is not null and channel_url is not null and followers is not null)
    or
    (rank in ('Admin','Helper') and age is not null and experience is not null)
  )
);

-- If upgrading an older database, add the new fields safely:
alter table public.media_applications add column if not exists rank text not null default 'Media';
alter table public.media_applications add column if not exists age integer;
alter table public.media_applications add column if not exists experience text;
-- These fields are optional for staff applications; creator ranks validate them below.
alter table public.media_applications alter column platform drop not null;
alter table public.media_applications alter column channel_url drop not null;
alter table public.media_applications alter column followers drop not null;
alter table public.media_applications drop constraint if exists media_applications_rank_check;
alter table public.media_applications add constraint media_applications_rank_check check (rank in ('Media','Streamer','YouTuber','Admin','Helper'));
alter table public.media_applications drop constraint if exists media_applications_rank_fields_check;
alter table public.media_applications add constraint media_applications_rank_fields_check check (
  (rank in ('Media','Streamer','YouTuber') and platform is not null and channel_url is not null and followers is not null)
  or
  (rank in ('Admin','Helper') and age is not null and experience is not null)
);

create table if not exists public.media_admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

alter table public.media_applications enable row level security;
alter table public.media_admins enable row level security;

drop policy if exists "Anyone can submit media applications" on public.media_applications;
create policy "Anyone can submit media applications"
on public.media_applications for insert to anon, authenticated
with check (
  rank in ('Media','Streamer','YouTuber','Admin','Helper')
  and char_length(minecraft_username) between 3 and 16
  and char_length(reason) between 20 and 1200
  and status = 'pending'
);

drop policy if exists "Admins can view applications" on public.media_applications;
create policy "Admins can view applications"
on public.media_applications for select to authenticated
using (exists (select 1 from public.media_admins a where a.user_id = auth.uid()));

drop policy if exists "Admins can update applications" on public.media_applications;
create policy "Admins can update applications"
on public.media_applications for update to authenticated
using (exists (select 1 from public.media_admins a where a.user_id = auth.uid()))
with check (exists (select 1 from public.media_admins a where a.user_id = auth.uid()));

drop policy if exists "Admins can view own admin row" on public.media_admins;
create policy "Admins can view own admin row"
on public.media_admins for select to authenticated
using (user_id = auth.uid());

-- After creating your admin user in Supabase Authentication, add their UUID:
-- insert into public.media_admins (user_id) values ('PASTE-ADMIN-USER-UUID-HERE');
