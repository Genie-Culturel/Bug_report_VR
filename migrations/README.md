# Database Migrations

Ce dossier contient les migrations SQL pour la base de données Supabase.

## Base de données de production

**URL:** https://dnxyidnkmtrmkxucqrry.supabase.co

## Appliquer les migrations

### Option 1 : Via l'interface Supabase (recommandé pour la première fois)

1. Connectez-vous au [dashboard Supabase](https://supabase.com/dashboard)
2. Sélectionnez le projet `dnxyidnkmtrmkxucqrry`
3. Allez dans **SQL Editor** dans la barre latérale gauche
4. Ouvrez le fichier de migration (par exemple `001_enable_rls_gh_bug_tables.sql`)
5. Copiez et collez le contenu dans l'éditeur SQL
6. Cliquez sur **Run** pour exécuter la migration

### Option 2 : Via Supabase CLI

```bash
# Installer Supabase CLI si nécessaire
npm install -g supabase

# Se connecter
supabase login

# Lier le projet
supabase link --project-ref dnxyidnkmtrmkxucqrry

# Appliquer la migration
supabase db execute -f migrations/001_enable_rls_gh_bug_tables.sql
```

### Option 3 : Via les outils MCP Supabase

Si vous avez accès aux outils MCP Supabase dans Cursor, utilisez `apply_migration` avec le contenu du fichier SQL.

## Migrations disponibles

- **001_enable_rls_gh_bug_tables.sql** : Active les politiques RLS (Row Level Security) pour permettre l'accès anonyme aux tables `gh_bug_sessions` et `gh_bug_entries` après l'authentification PIN côté client.

## Structure des tables

### gh_bug_sessions

Stocke les sessions de rapport de bugs VR.

Colonnes :
- `id` (bigint, PK)
- `ref` (uuid)
- `vr_session_id` (uuid, nullable)
- `game` (text)
- `session_date` (text)
- `session_time` (text)
- `panel` (integer)
- `gm` (text)
- `remarks` (text)
- `created_at` (timestamp)
- `updated_at` (timestamp)

### gh_bug_entries

Stocke les entrées de bugs individuelles.

Colonnes :
- `id` (bigint, PK)
- `bug_session_id` (bigint, FK vers gh_bug_sessions)
- `description` (text)
- `criticality` (text)
- `category` (text)
- `position` (integer)
- `status` (text)
- `extra` (jsonb)
- `created_at` (timestamp)
- `updated_at` (timestamp)

## Sécurité

L'authentification est gérée par un code PIN (1950) vérifié côté client. Une fois authentifié, le client utilise la clé anon de Supabase pour accéder aux tables. Les politiques RLS permettent un accès complet (SELECT, INSERT, UPDATE, DELETE) au rôle `anon` car la sécurité réelle est assurée par le PIN côté client.

**Important :** Ce modèle de sécurité suppose que l'application est utilisée dans un environnement de confiance et que le code PIN est suffisant pour contrôler l'accès.
