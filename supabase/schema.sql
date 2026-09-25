create extension if not exists pgcrypto;

create table if not exists public.workspaces(id uuid primary key default gen_random_uuid(),name text not null,plan text not null default 'PUBLIC',created_at timestamptz default now());
create table if not exists public.workspace_members(workspace_id uuid references public.workspaces(id) on delete cascade,user_id uuid references auth.users(id) on delete cascade,role text not null default 'member',created_at timestamptz default now(),primary key(workspace_id,user_id));
create table if not exists public.blocks(id uuid primary key default gen_random_uuid(),workspace_id uuid references public.workspaces(id) on delete cascade,owner_id uuid references auth.users(id),division text,block_code text not null,area_ha numeric,planting_year int,classification text,rainfall_mm numeric,rain_days numeric,avg_ph numeric,soil_status text,dominant_pest text,avg_attack_pct numeric,created_at timestamptz default now(),unique(workspace_id,block_code));
create table if not exists public.maintenance_records(id uuid primary key default gen_random_uuid(),workspace_id uuid references public.workspaces(id) on delete cascade,owner_id uuid references auth.users(id),inspection_date date,division text,block_code text,planting_year int,classification text,area_ha numeric,soil_condition text,ph numeric,moisture text,rainfall_mm numeric,rain_days numeric,fertilizer_type text,dose_kg_per_palm numeric,realization_kg numeric,pest_disease text,attack_pct numeric,control_status text,control_action text,pic text,note text,created_at timestamptz default now());
create table if not exists public.analyses(id uuid primary key default gen_random_uuid(),workspace_id uuid references public.workspaces(id) on delete cascade,owner_id uuid references auth.users(id),block_id uuid references public.blocks(id),parameter text,finding text,cause text,recommendation text,verification_status text,source_note text,risk_score numeric,risk_level text,ai_model text,created_at timestamptz default now());
create table if not exists public.actions(id uuid primary key default gen_random_uuid(),workspace_id uuid references public.workspaces(id) on delete cascade,owner_id uuid references auth.users(id),block_id uuid references public.blocks(id),analysis_id uuid references public.analyses(id),block_code text,priority text,finding text,action_text text,pic text,due_date date,status text default 'Open',created_at timestamptz default now(),updated_at timestamptz default now());
create table if not exists public.knowledge_base(id uuid primary key default gen_random_uuid(),workspace_id uuid references public.workspaces(id) on delete cascade,created_by uuid references auth.users(id),title text not null,source text,category text,content text not null,created_at timestamptz default now());
create table if not exists public.evidence(id uuid primary key default gen_random_uuid(),workspace_id uuid references public.workspaces(id) on delete cascade,owner_id uuid references auth.users(id),analysis_id uuid references public.analyses(id) on delete cascade,storage_path text not null,file_name text,file_type text,created_at timestamptz default now());

-- RLS: browser clients can only access records belonging to workspaces they belong to.
do $$ declare t text; begin
foreach t in array array['blocks','maintenance_records','analyses','actions','knowledge_base','evidence'] loop
execute format('alter table public.%I enable row level security',t);
execute format('create policy "%s member read" on public.%I for select using (exists(select 1 from public.workspace_members wm where wm.workspace_id=workspace_id and wm.user_id=auth.uid()))',t,t);
execute format('create policy "%s member write" on public.%I for insert with check (exists(select 1 from public.workspace_members wm where wm.workspace_id=workspace_id and wm.user_id=auth.uid()))',t,t);
execute format('create policy "%s member update" on public.%I for update using (exists(select 1 from public.workspace_members wm where wm.workspace_id=workspace_id and wm.user_id=auth.uid()))',t,t);
end loop; end $$;

alter table public.workspaces enable row level security;
alter table public.workspace_members enable row level security;
create policy "workspace member read" on public.workspaces for select using (exists(select 1 from public.workspace_members wm where wm.workspace_id=id and wm.user_id=auth.uid()));
create policy "member self read" on public.workspace_members for select using (user_id=auth.uid());

insert into storage.buckets(id,name,public) values('evidence','evidence',false) on conflict(id) do nothing;
create policy "evidence member read" on storage.objects for select using(bucket_id='evidence' and exists(select 1 from public.workspace_members wm where wm.workspace_id=(storage.foldername(name))[1]::uuid and wm.user_id=auth.uid()));
create policy "evidence member insert" on storage.objects for insert with check(bucket_id='evidence' and exists(select 1 from public.workspace_members wm where wm.workspace_id=(storage.foldername(name))[1]::uuid and wm.user_id=auth.uid()));

-- New user automatically gets a private workspace.
create or replace function public.create_default_workspace() returns trigger language plpgsql security definer set search_path=public as $$
declare w uuid;
begin
insert into public.workspaces(name) values(coalesce(new.raw_user_meta_data->>'workspace_name','My Agronomy Workspace')) returning id into w;
insert into public.workspace_members(workspace_id,user_id,role) values(w,new.id,'owner');
return new;
end $$;
drop trigger if exists on_auth_user_created_agro on auth.users;
create trigger on_auth_user_created_agro after insert on auth.users for each row execute function public.create_default_workspace();

create index if not exists idx_blocks_ws on public.blocks(workspace_id);
create index if not exists idx_maint_ws on public.maintenance_records(workspace_id);
create index if not exists idx_actions_ws_status on public.actions(workspace_id,status);
create index if not exists idx_analysis_ws_risk on public.analyses(workspace_id,risk_score);
create index if not exists idx_kb_ws_category on public.knowledge_base(workspace_id,category);
