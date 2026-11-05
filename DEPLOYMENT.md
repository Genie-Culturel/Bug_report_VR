# Guide de déploiement

## Étapes pour restaurer les liens profonds GMassignee

### 1. Appliquer la migration RLS (À faire AVANT de merger la PR)

La migration SQL **doit être appliquée** sur la base de production avant que les changements ne soient déployés sur GitHub Pages.

**Base de données :** https://dnxyidnkmtrmkxucqrry.supabase.co

#### Comment appliquer la migration

**Option recommandée - Dashboard Supabase :**

1. Se connecter sur https://supabase.com/dashboard
2. Sélectionner le projet avec ref `dnxyidnkmtrmkxucqrry`
3. Aller dans **SQL Editor** (icône dans la barre latérale gauche)
4. Créer une nouvelle requête
5. Copier-coller le contenu complet de `migrations/001_enable_rls_gh_bug_tables.sql`
6. Cliquer sur **Run** ou **Execute**
7. Vérifier qu'il n'y a pas d'erreurs

**Autres options :**
- Via Supabase CLI : voir `migrations/README.md`
- Via MCP tools dans Cursor : utiliser `apply_migration`

### 2. Merger la Pull Request

Une fois la migration appliquée avec succès :

1. Aller sur https://github.com/Genie-Culturel/Bug_report_VR/pull/2
2. Vérifier que tous les changements sont corrects
3. Merger vers `main`
4. GitHub Pages se mettra à jour automatiquement (peut prendre 1-2 minutes)

### 3. Tester le déploiement

#### Test 1 : Accès direct

1. Ouvrir https://genie-culturel.github.io/Bug_report_VR/
2. Entrer le PIN `1950`
3. Créer une nouvelle session
4. Ajouter quelques entrées de bugs
5. Vérifier qu'il n'y a pas d'erreur « Impossible de charger les données »

#### Test 2 : Lien profond GMassignee

1. Ouvrir le lien profond (exemple) :
```
https://genie-culturel.github.io/Bug_report_VR/?game=Bataille+de+la+Planta&date=2026-11-05&time=15%3A29&panel=8&gm=julien.quinodoz%40gmail.com&ref=ac95b170-9cbc-4a24-baed-0c9471056db6&autostart=1&session_id=ac95b170-9cbc-4a24-baed-0c9471056db6
```

2. Entrer le PIN `1950`
3. Vérifier que :
   - La session se charge automatiquement sans erreur
   - Les champs sont pré-remplis correctement
   - On arrive directement sur l'écran « Ajouter une entrée »
4. Ajouter un bug de test
5. Recharger la page et vérifier que le bug est toujours là

#### Test 3 : Vérification en base de données

Depuis le dashboard Supabase (SQL Editor) :

```sql
-- Vérifier que les données sont bien enregistrées
SELECT * FROM gh_bug_sessions ORDER BY created_at DESC LIMIT 5;
SELECT * FROM gh_bug_entries ORDER BY created_at DESC LIMIT 10;

-- Vérifier que les politiques RLS sont actives
SELECT schemaname, tablename, policyname, permissive, roles, cmd
FROM pg_policies 
WHERE tablename IN ('gh_bug_sessions', 'gh_bug_entries');
```

### Dépannage

#### « Impossible de charger les données »

**Causes possibles :**
1. La migration RLS n'a pas été appliquée → Appliquer `migrations/001_enable_rls_gh_bug_tables.sql`
2. Les tables n'existent pas → Vérifier que `gh_bug_sessions` et `gh_bug_entries` existent dans la base
3. La clé anon est incorrecte → Vérifier dans le code que `SUPABASE_ANON_KEY` correspond à celle du projet Supabase

#### Les sessions en double se créent

Vérifier que les colonnes `ref` et `vr_session_id` sont bien des UUID valides et uniques.

#### Les politiques RLS bloquent les requêtes

Vérifier avec :
```sql
-- Voir les politiques actuelles
SELECT * FROM pg_policies WHERE tablename = 'gh_bug_sessions';

-- Tester l'accès anon
SET ROLE anon;
SELECT * FROM gh_bug_sessions LIMIT 1;
RESET ROLE;
```

Si l'erreur persiste, réappliquer la migration ou contacter l'admin de la base de données.

## Configuration actuelle

- **Base de données :** https://dnxyidnkmtrmkxucqrry.supabase.co
- **Tables :** `gh_bug_sessions`, `gh_bug_entries`
- **Authentification :** PIN 1950 (côté client)
- **Rôle DB :** `anon` (avec politiques RLS permettant toutes les opérations)
- **GitHub Pages :** https://genie-culturel.github.io/Bug_report_VR/

## Historique

- **Avant :** Base `vxeprhyswkqugyewpwfm` (INACTIVE), tables `bug_sessions` / `bug_entries`
- **Après :** Base `dnxyidnkmtrmkxucqrry` (partagée avec GMassignee), tables `gh_bug_sessions` / `gh_bug_entries`
