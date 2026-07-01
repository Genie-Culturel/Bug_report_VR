# Connexion Supabase (VRC Session Manager)

## 1) Créer la table + policies
Exécute le script SQL suivant dans **Supabase → SQL Editor** :
- `supabase_playtest_entries.sql`

## 2) Checklist des changements app (déjà appliqués)
Dans `VRC_Session_Manager.html` :
- Remplacement des appels `window.dataSdk.create/update/delete` par `supabase-js` via `window.supabaseSync`.
- Suppression des scripts `/_sdk/data_sdk.js` et `/_sdk/element_sdk.js` (non nécessaires).
- `loadDataFromSupabase()` fusionne maintenant **sans doublons** :
  - sessions dédupliquées par `id`
  - entrées Supabase dédupliquées par `__backendId`
  - entrées “local only” (sans `__backendId`) conservées

## 3) Vérification rapide
- Ouvre l’app, ajoute une entrée (bug/feedback/…).
- Dans Supabase → Table Editor → `playtest_entries`, vérifie qu’une ligne apparaît.
- Recharge la page : l’entrée doit revenir depuis Supabase.

## Notes importantes (sécurité)
Ce setup correspond à “**données partagées** + **pas d’auth Supabase**”.
Donc si tu utilises les policies permissives (ou RLS désactivé), **toute personne qui a accès à ton fichier HTML** peut lire/écrire dans la table.

