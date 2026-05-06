<?php
/**
 * header.php — En-tête du site, inclus sur chaque page connectée
 * 
 * Affiche la barre de navigation avec le logo, les liens
 * et le badge du rôle de l'utilisateur.
 * La nav s'adapte aux permissions du user connecté.
 */

$utilisateur = get_utilisateur_connecte($connexion);
$idB_nav = isset($_GET['idB']) ? (int)$_GET['idB'] : ($utilisateur['idB'] ?? 1);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Oro Jackson — Vogue Merry</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<?php if ($utilisateur && !in_array($page_courante, ['accueil', 'connexion', 'attente'])): ?>
<nav class="topbar">
    <a href="index.php?page=selection" class="topbar-logo">⛵ Oro Jackson</a>
    <div class="topbar-nav">
        <a href="index.php?page=bateau&idB=<?= $idB_nav ?>" class="<?= $page_courante === 'bateau' ? 'actif' : '' ?>">Bateau</a>

        <?php if (a_permission($connexion, $utilisateur['idU'], 'Gérer les alertes')): ?>
        <a href="index.php?page=dashboard&idB=<?= $idB_nav ?>" class="<?= $page_courante === 'dashboard' ? 'actif' : '' ?>">Dashboard</a>
        <?php endif; ?>

        <?php if (a_permission($connexion, $utilisateur['idU'], 'Consulter résultats recherche')): ?>
        <a href="index.php?page=rapports&idB=<?= $idB_nav ?>" class="<?= $page_courante === 'rapports' ? 'actif' : '' ?>">Rapports</a>
        <?php endif; ?>

        <a href="index.php?page=fiche&idB=<?= $idB_nav ?>" class="<?= $page_courante === 'fiche' ? 'actif' : '' ?>">Fiche navire</a>
        <a href="index.php?page=equipage&idB=<?= $idB_nav ?>" class="<?= $page_courante === 'equipage' ? 'actif' : '' ?>">Équipage</a>
        <a href="index.php?page=historique&idB=<?= $idB_nav ?>" class="<?= $page_courante === 'historique' ? 'actif' : '' ?>">Historique</a>
        <a href="index.php?page=partenaires" class="<?= $page_courante === 'partenaires' ? 'actif' : '' ?>">Partenaires</a>
    </div>
    <div class="topbar-droite">
        <span class="badge badge-<?= strtolower(str_replace(' ', '', $utilisateur['role'])) ?>">
            <?= htmlspecialchars($utilisateur['role']) ?>
        </span>
        <a href="index.php?page=deconnexion" class="btn btn-deconnexion">⏻</a>
    </div>
</nav>
<?php endif; ?>

<main class="contenu">
