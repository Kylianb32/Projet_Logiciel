<?php


$utilisateur = get_utilisateur_connecte($connexion);

if (!$utilisateur) {
    header('Location: index.php?page=connexion');
    exit;
}

$idB_demande = isset($_GET['idB']) ? (int)$_GET['idB'] : ($utilisateur['idB'] ?? 1);

if ($utilisateur['role'] !== 'Admin' && $idB_demande !== (int)$utilisateur['idB']) {
    $idB = (int)$utilisateur['idB'];
} else {
    $idB = $idB_demande;
}
$fiche = get_fiche_bateau($connexion, $idB);

if (!$fiche) {
    echo '<p>Bateau introuvable.</p>';
    return;
}

$mesures = get_mesures_bateau($connexion, $idB);
$portes = get_portes_bateau($connexion, $idB);

if ($utilisateur['role'] === 'Admin') {
    $bateaux = get_liste_bateaux($connexion);
} else {
    $tous_les_bateaux = get_liste_bateaux($connexion);
    $bateaux = [];
    foreach ($tous_les_bateaux as $b) {
        if ($b['idB'] == $utilisateur['idB']) {
            $bateaux[] = $b;
        }
    }
}

?>

<div class="entete-page">
    <div>
        <h2 class="titre-page">🌊 <?= htmlspecialchars($fiche['nameB']) ?></h2>
        <p class="sous-titre-page">
            <?= htmlspecialchars($fiche['registrationB']) ?> · <?= htmlspecialchars($fiche['zone_maritime'] ?? '—') ?>
        </p>
    </div>
    
    <div class="ligne">
        <?php if (a_permission($connexion, $utilisateur['idU'], 'Gérer les alertes')): ?>
            <a href="index.php?page=dashboard&idB=<?= $idB ?>" class="btn btn-contour btn-sm">📊 Dashboard</a>
            <a href="index.php?page=gerer&idB=<?= $idB ?>" class="btn btn-contour btn-sm">⚙️ Gérer</a>
        <?php endif; ?>

        <?php if (a_permission($connexion, $utilisateur['idU'], 'Lancer des recherches')): ?>
            <a href="index.php?page=rapports&idB=<?= $idB ?>" class="btn btn-principal btn-sm">📋 Rapports</a>
        <?php endif; ?>
    </div>
</div>

<div class="onglets-bateaux">
    <?php foreach ($bateaux as $b): ?>
        <a href="index.php?page=bateau&idB=<?= $b['idB'] ?>" class="onglet <?= $b['idB'] == $idB ? 'actif' : '' ?>">
            <?= htmlspecialchars($b['nameB']) ?>
        </a>
    <?php endforeach; ?>
</div>

<div class="carte">
    <div class="carte-titre">🔬 Données capteurs</div>
    <table class="tableau">
        <thead>
            <tr>
                <th>Type</th>
                <th>Appareil</th>
                <th>Valeur</th>
                <th>Salle</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($mesures as $m): ?>
                <tr>
                    <td>
                        <strong><?= htmlspecialchars($m['typeM']) ?></strong>
                    </td>
                    <td>
                        <?= htmlspecialchars($m['nom_device']) ?><br>
                        <span style="color:var(--gris);font-size:11px"><?= htmlspecialchars($m['type_device']) ?></span>
                    </td>
                    <td style="font-size:12px">
                        <?= htmlspecialchars(substr($m['dataM'], 0, 60)) ?>
                    </td>
                    <td style="font-size:11px;color:var(--gris)">
                        <?= htmlspecialchars($m['nom_salle']) ?>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>

<div class="carte">
    <div class="carte-titre">🚪 Portes & Écoutilles</div>
    <div class="grille-3">
        <?php foreach ($portes as $p): ?>
            <?php $estOuverte = ($p['statusDo'] === 'OUVERT'); ?>
            <div class="porte <?= $estOuverte ? 'ouverte' : '' ?>">
                <span class="point <?= $estOuverte ? 'point-rouge' : 'point-vert' ?>"></span>
                <div>
                    <div style="font-weight:600"><?= htmlspecialchars($p['nameDo']) ?></div>
                    <div style="font-size:10px;color:var(--gris)">
                        <?= htmlspecialchars($p['salle_source']) ?> — 
                        <?= $estOuverte ? '<b style="color:var(--rouge)">OUVERTE</b>' : 'Fermée' ?>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    </div>
</div>


<div class="ligne">
    <a href="index.php?page=fiche&idB=<?= $idB ?>" class="btn btn-contour">🚢 Fiche</a>
    <a href="index.php?page=equipage&idB=<?= $idB ?>" class="btn btn-contour">👥 Équipage</a>
    <a href="index.php?page=historique&idB=<?= $idB ?>" class="btn btn-contour">📜 Historique</a>
    <a href="index.php?page=partenaires" class="btn btn-contour">🤝 Partenaires</a>
</div>