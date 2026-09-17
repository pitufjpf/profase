-- Ejecutar una sola vez en Supabase: SQL Editor → New query → pegar todo → Run

create table if not exists productos (
  id bigint generated always as identity primary key,
  nombre text not null,
  section text not null,
  section_num integer not null,
  color text not null,
  codigos_sidico text[] default '{}',
  snomed_code text,
  snomed_fsn text,
  snomed_es text,
  snomed_nota text,
  clase_riesgo text,
  clase_fuente text,
  descripcion text[] default '{}',
  medidas text[] default '{}',
  usos text[] default '{}',
  tipo_material text[] default '{}',
  generalidades text[] default '{}',
  presentacion text[] default '{}',
  almacenamiento text[] default '{}',
  imagen_url text,
  imagen_fuente text,
  created_at timestamptz not null default now()
);

alter table productos enable row level security;

drop policy if exists "Lectura pública de productos" on productos;
create policy "Lectura pública de productos"
  on productos for select
  using (true);

drop policy if exists "Alta pública de productos" on productos;
create policy "Alta pública de productos"
  on productos for insert
  with check (true);

drop policy if exists "Baja pública de productos" on productos;
create policy "Baja pública de productos"
  on productos for delete
  using (true);

-- Storage para las fotos cargadas desde el formulario
insert into storage.buckets (id, name, public)
values ('productos-fotos', 'productos-fotos', true)
on conflict (id) do nothing;

drop policy if exists "Lectura pública de fotos" on storage.objects;
create policy "Lectura pública de fotos"
  on storage.objects for select
  using (bucket_id = 'productos-fotos');

drop policy if exists "Subida pública de fotos" on storage.objects;
create policy "Subida pública de fotos"
  on storage.objects for insert
  with check (bucket_id = 'productos-fotos');

drop policy if exists "Borrado público de fotos" on storage.objects;
create policy "Borrado público de fotos"
  on storage.objects for delete
  using (bucket_id = 'productos-fotos');
