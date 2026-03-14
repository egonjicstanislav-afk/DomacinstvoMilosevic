-- =============================================
-- FARMA MILOSEVIC — Settings tabela
-- Pokrenuti u Supabase → SQL Editor → New query
-- =============================================

create table if not exists settings (
  key   text primary key,
  value text
);

alter table settings enable row level security;

create policy "Public read settings"  on settings for select using (true);
create policy "Public insert settings" on settings for insert with check (true);
create policy "Public update settings" on settings for update using (true);

-- Defaultne vrednosti
insert into settings (key, value) values
  ('notification_emails', ''),
  ('notification_from',   'Farma Milošević <onboarding@resend.dev>')
on conflict (key) do nothing;
