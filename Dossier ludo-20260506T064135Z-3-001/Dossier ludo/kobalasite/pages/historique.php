<?php

$utilisateur = get_utilisateur_connecte($connexion);
if (!$utilisateur) {
    header('Location: index.php?page=connexion');
    exit;
}

$idB = isset($_GET['idB']) ? (int)$_GET['idB'] : ($utilisateur['idB'] ?? 1);

$actions = get_historique_actions($connexion, $idB);
$donnees = get_historique_donnees($connexion, $idB);
$fiche   = get_fiche_bateau($connexion, $idB);

?>
<div class="entete-page">
    <div>
        <h2 class="titre-page">📜 Historique — <?= htmlspecialchars($fiche['nameB'] ?? '') ?></h2>
    </div>
    <a href="index.php?page=bateau&idB=<?= $idB ?>" class="btn btn-contour btn-sm">
        ← Retour
    </a>
</div>

<div class="grille-2">
    <div class="carte">
        <div class="carte-titre">🔧 Actions techniques</div>
        <table class="tableau">
            <thead>
                <tr>
                    <th>Utilisateur</th>
                    <th>Appareil</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($actions as $a): ?>
                    <tr>
                        <td style="font-size:12px">
                            <?= htmlspecialchars($a['nom_complet']) ?><br>
                            <span style="color:var(--gris); font-size:10px">
                                <?= htmlspecialchars($a['role']) ?>
                            </span>
                        </td>
                        <td style="font-size:12px">
                            <?= htmlspecialchars($a['nom_device']) ?>
                        </td>
                        <td style="font-weight:600">
                            <?= htmlspecialchars($a['action']) ?>
                        </td>
                    </tr>
                <?php endforeach; ?>

                <?php if (empty($actions)): ?>
                    <tr>
                        <td colspan="3" style="color:var(--gris)">Aucune action enregistrée.</td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
    <div class="carte">
        <div class="carte-titre">📊 Données reçues</div>
        <table class="tableau">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Mesure</th>
                    <th>Résultat</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($donnees as $d): ?>
                    <tr>
                        <td style="font-size:11px">
                            <?= htmlspecialchars($d['date_reception']) ?>
                        </td>
                        <td>
                            <?= htmlspecialchars($d['type_mesure']) ?>
                        </td>
                        <td>
                            <?= htmlspecialchars($d['type_resultat']) ?>  
                            (<?= htmlspecialchars($d['fiabilite']) ?>%)
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($donnees)): ?>
                    <tr>
                        <td colspan="3" style="color:var(--gris)">Aucune donnée reçue.</td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>

</div>