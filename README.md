# Bug Report VR — VRC Session Manager

## Accéder à l'application

# 👉 [https://genie-culturel.github.io/Bug_report_VR/](https://genie-culturel.github.io/Bug_report_VR/)

Outil web pour gérer les sessions de playtest VR : création de sessions, saisie de bugs, feedbacks et remarques en direct, synchronisation avec Supabase.

---

## Fonctionnalités

- Gestion des sessions de playtest (jeu, date, panel, prise de notes)
- Saisie structurée des retours : bugs, feedbacks, questions, remarques
- Tri du journal par criticité, persisté via `gh_bug_entries.position`
- Export JSON / journal texte
- Interface légère, utilisable directement dans le navigateur (un seul `docs/index.html`)

## Utilisation

1. Ouvrir le lien ci-dessus
2. Saisir le code d'accès si demandé
3. Créer ou rejoindre une session de playtest
4. Enregistrer les retours au fil de la session

### Préfill via URL (pour intégration externe)

L'application supporte la création de sessions pré-remplies via des paramètres URL, permettant une intégration depuis d'autres outils (ex: module GM).

**Format de l'URL:**
```
https://genie-culturel.github.io/Bug_report_VR/?game=<nom_du_jeu>&date=YYYY-MM-DD&time=HH:MM&panel=<nombre>&gm=<nom_gm>&remarks=<remarques>&ref=<id_externe>&session_id=<uuid_vr_sessions>&autostart=1
```

**Paramètres disponibles:**

| Paramètre | Description | Exemple | Obligatoire |
|-----------|-------------|---------|-------------|
| `game` | Nom du jeu | `Bataille de la Planta` | Oui (déclenche le préfill) |
| `date` | Date de la session | `2026-10-31` | Non |
| `time` | Heure de début | `13:45` | Non |
| `panel` | Nombre de joueurs | `5` | Non |
| `gm` | Nom du GM/preneur de notes | `GM-423` | Non |
| `remarks` | Remarques générales | `Session test` | Non |
| `ref` | ID de référence externe (`gh_bug_sessions.ref`) | `session-123` | Non |
| `session_id` | UUID de la session GM (`vr_sessions.id` → `gh_bug_sessions.vr_session_id`) | `a1b2c3d4-...` | Non |
| `autostart` | Créer et démarrer automatiquement | `1` | Non |

**Comportement:**

- Si seul `game` est présent : ouvre le formulaire de nouvelle session avec le champ `game` pré-rempli
- Si `autostart=1` : crée et démarre la session automatiquement, l'utilisateur arrive directement sur "Ajouter une entrée"
- **Détection de doublons** : évite de créer des sessions en double, dans cet ordre
  - Par `session_id` : `gh_bug_sessions.vr_session_id` (clé primaire de dédup)
  - Par `ref` : colonne unique `gh_bug_sessions.ref`
  - Sinon par `game` + `date` + `time`
- Si `session_id` n'existe pas dans `vr_sessions` (contrainte FK), la session est tout de même créée **sans** `vr_session_id` (avertissement dans la console)
- L'URL est nettoyée après traitement (`history.replaceState`, pas de recréation au rechargement)
- Les paramètres sont préservés durant l'authentification (PIN)
- Si Supabase est injoignable : message **« Impossible de charger les données, réessaie »** + bouton Réessayer. Aucune écriture n'est tentée.

**Exemple d'URL complète:**
```
https://genie-culturel.github.io/Bug_report_VR/?game=Bataille%20de%20la%20Planta&date=2026-10-31&time=13:45&panel=5&gm=GM-423&remarks=Session%20test&ref=session-123&autostart=1
```

**Exemple d'intégration JavaScript:**
```javascript
const sessionUrl = new URL('https://genie-culturel.github.io/Bug_report_VR/');
sessionUrl.searchParams.set('game', 'Bataille de la Planta');
sessionUrl.searchParams.set('date', '2026-10-31');
sessionUrl.searchParams.set('time', '13:45');
sessionUrl.searchParams.set('panel', '5');
sessionUrl.searchParams.set('gm', 'GM-423');
sessionUrl.searchParams.set('ref', 'session-abc-123');
sessionUrl.searchParams.set('session_id', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890');
sessionUrl.searchParams.set('autostart', '1');

window.open(sessionUrl.toString(), '_blank');
```

## Stockage (Supabase)

Base de production partagée (`https://dnxyidnkmtrmkxucqrry.supabase.co`). Client `supabase-js` chargé depuis un CDN, sans build.

| Table | Rôle |
|---|---|
| `gh_bug_sessions` | Une ligne par session de jeu |
| `gh_bug_entries` | Une ligne par entrée (Bug / Info / Suggestion / Log) |

Les écritures sont des insert / update / delete **par ligne**. L'application ne réécrit jamais le jeu de données entier.

### Configuration RLS

Les tables utilisent Row Level Security (RLS) avec des politiques permettant au rôle `anon` d'effectuer toutes les opérations (SELECT, INSERT, UPDATE, DELETE). L'authentification est gérée par un code PIN (1950) côté client.

Voir `migrations/` pour les fichiers SQL de configuration de la base de données.

## Structure du dépôt

| Dossier / fichier | Description |
|---|---|
| `docs/` | Version déployée sur GitHub Pages |
| `VRC - SM - V5.html` | Ancienne version source |
| `edit/` | Versions antérieures et fichiers de développement |

---

*Conçu et développé par Julien Quinodoz.*
