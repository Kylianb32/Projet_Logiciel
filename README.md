# 🚢 Site Web Oro Jackson — Vogue Merry

## Structure du projet

```
orojackson/
├── index.php              ← Point d'entrée unique (routeur)
├── css/
│   └── style.css          ← Feuille de style (séparée du PHP)
├── includes/
│   ├── connexion.php      ← Connexion BDD (mysqli)
│   ├── fonctions.php      ← Fonctions + requêtes SQL imbriquées
│   ├── header.php         ← En-tête + nav (inclus partout)
│   └── footer.php         ← Pied de page (inclus partout)
├── pages/
│   ├── accueil.php        ← Page 1 : Accueil (hero + bouton connexion)
│   ├── connexion.php      ← Page 2 : Formulaire de login
│   ├── attente.php        ← Page 3 : En attente d'attribution
│   ├── selection.php      ← Page 4 : Sélection du bateau (admin/capitaine)
│   ├── bateau.php         ← Page 5 : Monitoring temps réel (capteurs + portes)
│   ├── dashboard.php      ← Page 6 : Tableau de bord (capitaine only)
│   ├── rapports.php       ← Page 7 : Rapports scientifiques
│   ├── creation.php       ← Page 8 : Création de rapport
│   ├── gerer.php          ← Page 9 : Gestion de l'équipage (capitaine only)
│   ├── fiche.php          ← Page 10 : Fiche technique du navire
│   ├── equipage.php       ← Page 11 : Annuaire de l'équipage
│   ├── historique.php     ← Page 12 : Journalisation (actions + données)
│   ├── partenaires.php    ← Page 13 : DOMONOOB + NOAA
│   └── erreur403.php      ← Page 14 : Accès refusé
├── sql/
│   └── schema.sql         ← Création de la BDD + données d'exemple
└── assets/                ← Images (si besoin)
```

## Déploiement sur le Raspberry Pi

1. Copier le dossier dans `/var/www/html/`
2. Importer `sql/schema.sql` dans phpMyAdmin
3. Vérifier les identifiants dans `includes/connexion.php`
4. Accéder au site via `http://192.168.4.1/`

## Comptes de test (mdp = aaa)

| Username       | Rôle           | Bateau        |
|----------------|----------------|---------------|
| sdupont        | Capitaine      | Le Téméraire  |
| tromich        | Scientifique   | Le Téméraire  |
| hsolomon       | Matelots       | Le Téméraire  |
| attente_user   | Matelots       | Non assigné   |
| jmartin        | Administrateur | —             |
