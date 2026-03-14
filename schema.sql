-- =============================================
-- FARMA MILOSEVIC — Supabase SQL Schema
-- Pokrenuti u: Supabase → SQL Editor → New query
-- =============================================

-- PRODUCTS
create table if not exists products (
  id text primary key,
  name text not null,
  category text,
  price numeric default 0,
  unit text default 'kom',
  stock integer default 0,
  description text,
  image_url text,
  active boolean default true,      -- sezonski toggle: false = privremeno nedostupno
  created_at timestamptz default now()
);

-- ORDERS
create table if not exists orders (
  id text primary key,
  customer jsonb,    -- { name, phone, address?, village?, note? }
  delivery jsonb,    -- { type: 'dostava'|'preuzimanje', date, slotId?, slotLabel?, pickupNote? }
  items jsonb,       -- [{ id, name, price, qty, unit, category }]
  total numeric default 0,
  status text default 'nova',
  created_at timestamptz default now()
);

-- SLOTS (termini dostave / preuzimanja)
create table if not exists slots (
  id text primary key,
  label text,
  time text,
  type text default 'dostava',   -- 'dostava' ili 'preuzimanje'
  active boolean default true
);

-- STATS (posete i sl.)
create table if not exists stats (
  key text primary key,
  value integer default 0
);

-- =============================================
-- DOZVOLE (RLS)
-- =============================================
alter table products enable row level security;
alter table orders enable row level security;
alter table slots enable row level security;
alter table stats enable row level security;

-- Products
create policy "Public read products" on products for select using (true);
create policy "Anon insert products" on products for insert with check (true);
create policy "Anon update products" on products for update using (true);
create policy "Anon delete products" on products for delete using (true);

-- Orders
create policy "Public insert orders" on orders for insert with check (true);
create policy "Public read orders" on orders for select using (true);
create policy "Public update orders" on orders for update using (true);
create policy "Public delete orders" on orders for delete using (true);

-- Slots
create policy "Public read slots" on slots for select using (true);
create policy "Anon insert slots" on slots for insert with check (true);
create policy "Anon update slots" on slots for update using (true);
create policy "Anon delete slots" on slots for delete using (true);

-- Stats
create policy "Public read stats" on stats for select using (true);
create policy "Public update stats" on stats for update using (true);
create policy "Public insert stats" on stats for insert with check (true);

-- =============================================
-- DEFAULT PODACI
-- =============================================
insert into slots (id, label, time, type, active) values
  ('jutro', '🌅 Pre podne', '08:00 – 12:00', 'dostava', true),
  ('popodne', '🌇 Posle podne', '13:00 – 17:00', 'dostava', true),
  ('preuzimanje', '🏡 Preuzimanje na farmi', '09:00 – 17:00', 'preuzimanje', true)
on conflict (id) do nothing;

insert into stats (key, value) values ('visits', 0)
on conflict (key) do nothing;

-- =============================================
-- DEMO ARTIKLI (opciono — obriši ako ne trebaš)
-- =============================================
insert into products (id, name, category, price, unit, stock, description, active) values
  ('p1',  'Jaja (10 kom)',              'Jaja',           180,  'pak',  30, 'Sveža domaća jaja, slobodan uzgoj.',                    true),
  ('p2',  'Mleko sveže (1L)',           'Mlečni proizvodi', 120, 'lit', 20, 'Punomasno kravlje mleko, jutarnja muža.',              true),
  ('p3',  'Kajmak (250g)',              'Mlečni proizvodi', 450, 'pak', 15, 'Domaći kajmak, blago slan.',                           true),
  ('p4',  'Sir beli (500g)',            'Mlečni proizvodi', 650, 'pak', 10, 'Domaći meki beli sir u salamuri.',                    true),
  ('p5',  'Med livadski (500g)',        'Med i pčelinj.', 1200, 'teg',  20, 'Čist livadski med, sakupljen u junu.',                  true),
  ('p6',  'Med od bagrema (500g)',      'Med i pčelinj.', 1400, 'teg',  12, 'Svetli bagremov med, blag i aromatičan.',              true),
  ('p7',  'Paradajz (1kg)',             'Voće i povrće',  120,  'kg',   40, 'Domaći paradajz, sazreo na suncu.',                    true),
  ('p8',  'Paprike babure (1kg)',       'Voće i povrće',  100,  'kg',   35, 'Crvene i žute babure, mesnate.',                       false),
  ('p9',  'Jabuke (1kg)',               'Voće i povrće',  90,   'kg',   60, 'Domaće jabuke, mešane sorte.',                         false),
  ('p10', 'Ajvar ljuti (720ml)',        'Prerađevine',    550,  'teg',  25, 'Domaći ljuti ajvar, pečen i sterilizan.',               true),
  ('p11', 'Džem od šljiva (400g)',      'Prerađevine',    380,  'teg',  18, 'Džem bez konzervansa, samo šljive i šećer.',            true),
  ('p12', 'Slanina dimljena (500g)',    'Prerađevine',    900,  'pak',  8,  'Dimljena slanina od domaćeg svinjskog mesa.',           true)
on conflict (id) do nothing;
