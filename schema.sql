-- รันใน Supabase > SQL Editor > New query แล้วกด Run ทั้งหมด
create table if not exists public.inspections (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  user_email text,
  inspector text,
  system_key text,
  system_name text,
  date text,
  month text,
  data jsonb,
  photo_urls text[],
  ok_count int default 0,
  bad_count int default 0
);
alter table public.inspections enable row level security;
create policy "read all" on public.inspections for select using (true);
create policy "insert auth" on public.inspections for insert with check (true);
create policy "delete auth" on public.inspections for delete using (true);

-- Storage bucket สำหรับรูปถ่าย
insert into storage.buckets (id, name, public) values ('photos','photos', true) on conflict (id) do nothing;
create policy "public read photos" on storage.objects for select using (bucket_id='photos');
create policy "upload photos" on storage.objects for insert with check (bucket_id='photos');
create policy "delete photos" on storage.objects for delete using (bucket_id='photos');
