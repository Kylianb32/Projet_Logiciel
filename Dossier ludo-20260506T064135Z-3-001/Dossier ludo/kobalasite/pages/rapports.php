<?php


$utilisateur = get_utilisateur_connecte($connexion);

if (!$utilisateur) {
    header('Location: index.php?page=connexion'); 
    exit;
}

$idB = isset($_GET['idB']) ? (int)$_GET['idB'] : ($utilisateur['idB'] ?? 1);

$recherches = get_recherches_bateau($connexion, $idB);[cite: 4]
$fiche = get_fiche_bateau($connexion, $idB);[cite: 4]

$peutPublier = ($utilisateur['role'] === 'Admin') || a_permission($connexion, $utilisateur['idU'], 'Lancer des recherches');

?>

<div class="entete-page">
    <div>
        <h2 class="titre-page">📋 Rapports — <?= htmlspecialchars($fiche['nameB'] ?? '') ?></h2>
    </div>
    <div class="ligne">
        <?php if ($peutPublier): ?>
            <a href="index.php?page=creation&idB=<?= $idB ?>" class="btn btn-principal btn-sm">
                + Nouveau rapport
            </a>
        <?php endif; ?>
        
        <a href="index.php?page=bateau&idB=<?= $idB ?>" class="btn btn-contour btn-sm">
            ← Retour
        </a>
    </div>
</div>

<?php foreach ($recherches as $r): ?>
    <div class="carte" style="border-left:3px solid var(--teal)">
        <div style="font-size:14px;font-weight:700">
            <?= htmlspecialchars($r['typeRs']) ?> — <?= htmlspecialchars($r['type_result'] ?? 'En cours') ?>
        </div>

        <div style="font-size:11px;color:var(--gris);margin-bottom:6px">
            Zone: <?= htmlspecialchars($r['maritine_zone'] ?? '—') ?> · 
            Statut: <?= htmlspecialchars($r['StatusRs']) ?>
            <?php if (!empty($r['reliability'])): ?> · 
                Fiabilité: <?= htmlspecialchars($r['reliability']) ?>%
            <?php endif; ?>[cite: 4]
        </div>

        <div style="font-size:12px;color:#444">
            <?= htmlspecialchars($r['data_result'] ?? '—') ?>
        </div>
    </div>
<?php endforeach; ?>

<?php if (empty($recherches)): ?>
    <div class="carte">
        <p style="color:var(--gris)">Aucune recherche enregistrée pour ce bâtiment.</p>
    </div>
<?php endif; ?>