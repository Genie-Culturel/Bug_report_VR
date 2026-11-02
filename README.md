# Bug Report VR — VRC Session Manager

## Accéder à l'application

# 👉 [https://genie-culturel.github.io/Bug_report_VR/](https://genie-culturel.github.io/Bug_report_VR/)

Outil web pour gérer les sessions de playtest VR : création de sessions, saisie de bugs, feedbacks et remarques en direct, synchronisation avec Google Sheets.

---

## Fonctionnalités

- Gestion des sessions de playtest (jeu, date, panel, prise de notes)
- Saisie structurée des retours : bugs, feedbacks, questions, remarques
- Chronométrage et suivi du temps écoulé pendant la session
- Export et synchronisation des données vers Google Sheets
- Interface légère, utilisable directement dans le navigateur

## Utilisation

1. Ouvrir le lien ci-dessus
2. Saisir le code d'accès si demandé
3. Créer ou rejoindre une session de playtest
4. Enregistrer les retours au fil de la session

### Préfill via URL (pour intégration externe)

L'application supporte la création de sessions pré-remplies via des paramètres URL, permettant une intégration depuis d'autres outils (ex: module GM).

**Format de l'URL:**
```
https://genie-culturel.github.io/Bug_report_VR/?game=<nom_du_jeu>&date=YYYY-MM-DD&time=HH:MM&panel=<nombre>&gm=<nom_gm>&remarks=<remarques>&ref=<id_externe>&autostart=1
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
| `ref` | ID de référence externe | `session-123` | Non |
| `autostart` | Créer et démarrer automatiquement | `1` | Non |

**Comportement:**

- Si seul `game` est présent : ouvre le formulaire de nouvelle session avec le champ `game` pré-rempli
- Si `autostart=1` : crée et démarre la session automatiquement, l'utilisateur arrive directement sur "Ajouter une entrée"
- **Détection de doublons** : évite de créer des sessions en double
  - Par `ref` : si une session avec `[ref:xxx]` dans les remarques existe déjà, elle est ouverte
  - Par `game`+`date`+`time` : si une session identique existe, elle est ouverte
- L'URL est nettoyée après traitement (pas de recréation au rechargement)
- Les paramètres sont préservés durant l'authentification

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
sessionUrl.searchParams.set('autostart', '1');

window.open(sessionUrl.toString(), '_blank');
```

## Structure du dépôt

| Dossier / fichier | Description |
|---|---|
| `docs/` | Version déployée sur GitHub Pages |
| `VRC - SM - V4.html` | Dernière version source de l'application |
| `edit/` | Versions antérieures et fichiers de développement |

---

*Conçu et développé par Julien Quinodoz.*
