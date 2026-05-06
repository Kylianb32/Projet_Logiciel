<?php
$utilisateur = get_utilisateur_connecte($connexion);

if (!$utilisateur) {
    header('Location:index.php?page=connexion');
    exit;
}

$idB_demande = isset($_GET['idB']) ? (int)$_GET['idB'] : ($utilisateur['idB'] ?? 1);

if ($utilisateur['role'] !== 'Admin' && $idB_demande !== (int)$utilisateur['idB']) {
    $idB = (int)$utilisateur['idB']; 
} else {
    $idB = $idB_demande;
}

$fiche = get_fiche_bateau($connexion, $idB);

$tous_les_bateaux = get_liste_bateaux($connexion);

if ($utilisateur['role'] !== 'Admin') {
    $bateaux = [];
    foreach ($tous_les_bateaux as $b) {
        if ($b['idB'] == $utilisateur['idB']) {
            $bateaux[] = $b; 
        }
    }
} else {
    $bateaux = $tous_les_bateaux; 
}
if (!$fiche) {
    echo '<p>Erreur : Fiche technique introuvable Veuillez contacter l"admin au 06 51 07 60 22 ou par mail : 
mathieu.doumai@gmail.com .</p>';
    return;
}

?>

<div class="entete-page">
    <div>
        <h2 class="titre-page">🚢 <?= htmlspecialchars($fiche['nameB']) ?></h2>
        <p class="sous-titre-page">Fiche technique détaillée</p>
    </div>
    <a href="index.php?page=bateau&idB=<?= $idB ?>" class="btn btn-contour btn-sm">
        ← Retour
    </a>
</div>

<div class="onglets-bateaux">
    <?php foreach ($bateaux as $b): ?>
        <a href="index.php?page=fiche&idB=<?= $b['idB'] ?>" 
           class="onglet <?= $b['idB'] == $idB ? 'actif' : '' ?>">
            <?= htmlspecialchars($b['nameB']) ?>
        </a>
    <?php endforeach; ?>
</div>

<div class="carte">
    <div class="carte-titre">📐 Caractéristiques</div>
    <div class="grille-4">
        <div>
            <div style="font-size:10px; color:var(--gris)">Immatriculation</div>
            <strong><?= htmlspecialchars($fiche['registrationB']) ?></strong>
        </div>
        <div>
            <div style="font-size:10px; color:var(--gris)">Longueur</div>
            <strong><?= $fiche['lenghtB'] ?>m</strong>
        </div>
        <div>
            <div style="font-size:10px; color:var(--gris)">Vitesse Max</div>
            <strong><?= $fiche['maxspeedB'] ?>nds</strong>
        </div>
        <div>
            <div style="font-size:10px; color:var(--gris)">Capacité</div>
            <strong><?= $fiche['capacityB'] ?> pers.</strong>
        </div>
        <div>
            <div style="font-size:10px; color:var(--gris)">Zone d'opération</div>
            <strong><?= htmlspecialchars($fiche['zone_maritime'] ?? '—') ?></strong>
        </div>
        <div>
            <div style="font-size:10px; color:var(--gris)">Capteurs actifs</div>
            <strong><?= $fiche['nb_captors'] ?></strong>
        </div>
        <div>
            <div style="font-size:10px; color:var(--gris)">Salles répertoriées</div>
            <strong><?= $fiche['nb_room'] ?></strong>
        </div>
        <div>
            <div style="font-size:10px; color:var(--gris)">Portes & Accès</div>
            <strong><?= $fiche['nb_door'] ?></strong>
        </div>
    </div>
</div>