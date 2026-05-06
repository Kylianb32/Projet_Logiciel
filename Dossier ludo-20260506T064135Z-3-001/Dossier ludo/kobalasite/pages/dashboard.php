<?php


$utilisateur = get_utilisateur_connecte($connexion);


if (!a_permission($connexion, $utilisateur['idU'], 'Gérer les alertes')) {
    header('Location: index.php?page=bateau&erreur=acces_refuse');
    exit; 
}

$idB = isset($_GET['idB']) ? (int)$_GET['idB'] : ($utilisateur['idB'] ?? 1);

$fiche = get_fiche_bateau($connexion, $idB);
$equipage = get_equipage_bateau($connexion, $idB);

$qa = "SELECT D.nameDo,
       (SELECT nameRo FROM ROOM WHERE idRo = D.idRo1) AS salle 
       FROM DOOR D 
       WHERE D.statusDo = 'OUVERT' 
       AND D.idRo1 IN (SELECT idRo FROM ROOM WHERE idB = $idB)";
       
$ra = mysqli_query($connexion, $qa);

?>

<div class="entete-page">
    <div>
        <h2 class="titre-page">
            📊 Dashboard — <?= htmlspecialchars($fiche['nameB']) ?> 
        </h2>
        <p class="sous-titre-page">Vue capitaine</p>
    </div>
    <a href="index.php?page=bateau&idB=<?= $idB ?>" class="btn btn-contour btn-sm">← Retour</a>
</div>

<div class="grille-2">
    
    <div class="carte">
        <div class="carte-titre">🚨 Alertes en cours</div>
        
        <?php while ($a = mysqli_fetch_assoc($ra)): ?>
            <div class="alerte alerte-critique">
                <strong>⚠ <?= htmlspecialchars($a['nameDo']) ?></strong> 
                — <?= htmlspecialchars($a['salle']) ?>
            </div>
        <?php endwhile; ?>

        <?php if (mysqli_num_rows($ra) === 0): ?>
            <div class="alerte alerte-info">Tout est nominal. Aucune alerte détectée.</div>
        <?php endif; ?>
    </div>
    <div class="carte">
        <div class="carte-titre">🚢 État général</div>
        <div class="grille-3">
            <div>
                <div style="font-size:10px;color:var(--gris)">Capteurs</div>
                <strong style="font-size:18px"><?= $fiche['nb_captors'] ?></strong> 
            </div>
            <div>
                <div style="font-size:10px;color:var(--gris)">Salles</div>
                <strong style="font-size:18px"><?= $fiche['nb_room'] ?></strong> 
            </div>
            <div>
                <div style="font-size:10px;color:var(--gris)">Portes</div>
                <strong style="font-size:18px"><?= $fiche['nb_door'] ?></strong> 
            </div>
        </div>
    </div>

</div>

<div class="carte">
    <div class="carte-titre">
        👥 Membres d'équipage (<?= $fiche['nb_member'] ?>) 
    </div>
    
    <?php foreach ($equipage as $m): ?>
        <div style="display:flex;align-items:center;gap:8px;padding:8px 0;border-bottom:1px solid var(--bordure)">
            <span class="point point-vert"></span>
            <span style="font-size:13px">
                <?= htmlspecialchars($m['surnameU'] . ' ' . $m['nameU']) ?>
            </span>
            <span class="badge badge-<?= strtolower(str_replace(' ', '', $m['role'])) ?>" style="margin-left:auto">
                <?= htmlspecialchars($m['role']) ?>
            </span>
        </div>
    <?php endforeach; ?>
</div>