-- Jalankan di Supabase: SQL Editor -> New query -> Run
create table if not exists categories (name text primary key);
create table if not exists admins (user_id uuid primary key references auth.users on delete cascade);
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  sku text unique not null, name text not null, cat text not null,
  normal numeric not null default 0, promo numeric, promo_on boolean not null default false,
  photo_url text, hash text, created_at timestamptz default now());

create or replace function is_admin() returns boolean language sql security definer stable set search_path = public
as $$ select exists (select 1 from admins where user_id = auth.uid()) $$;

alter table products enable row level security;
alter table categories enable row level security;
alter table admins enable row level security;
create policy "products read"  on products   for select using (true);
create policy "products admin" on products   for all using (is_admin()) with check (is_admin());
create policy "cats read"      on categories for select using (true);
create policy "cats admin"     on categories for all using (is_admin()) with check (is_admin());
create policy "admins self"    on admins     for select using (user_id = auth.uid());

insert into storage.buckets (id, name, public) values ('products', 'products', true) on conflict do nothing;
create policy "photos read"  on storage.objects for select using (bucket_id = 'products');
create policy "photos admin" on storage.objects for all
  using (bucket_id = 'products' and is_admin()) with check (bucket_id = 'products' and is_admin());

alter publication supabase_realtime add table products;

-- Setelah membuat user admin di Authentication -> Users, jalankan (ganti emailnya):
-- insert into admins (user_id) select id from auth.users where email = 'admin@contoh.com';
