<?php
$utilisateur = get_utilisateur_connecte($connexion);
if (!$utilisateur) {
    header('Location: index.php?page=connexion');
    exit;
}
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
?>
<h2 class="titre-page">🚢 Flotte Vogue Merry</h2>
<p class="sous-titre-page">Sélectionnez un navire pour accéder au système embarqué</p>

<div class="grille-3">
    <?php foreach ($bateaux as $b): ?>
        <a href="index.php?page=bateau&idB=<?= $b['idB'] ?>" class="carte" style="text-decoration:none; color:inherit">
            <div class="carte-titre">
                ⛵ <?= htmlspecialchars($b['nameB']) ?>
            </div>
           <div style="font-size:11px; color:var(--gris)">
                Zone: <?= htmlspecialchars($b['zone_maritime'] ?? '—') ?> · 
                <?= htmlspecialchars($b['registrationB']) ?>
            </div>

            <div style="font-size:11px; color:var(--gris)">
                <?= $b['nb_membres'] ?> / <?= $b['capacityB'] ?> membres · 
                <?= $b['nb_capteurs'] ?> capteurs
                <?php if ($b['portes_ouvertes'] > 0): ?>
                    · <span style="color:var(--rouge)">
                        <?= $b['portes_ouvertes'] ?> porte(s) ouverte(s)
                      </span>
                <?php endif; ?>
            </div>

        </a>
    <?php endforeach; ?>
</div>

<?php if (empty($bateaux)): ?>
    <div class="carte">
        <p style="color:var(--gris)">Aucun navire n'est actuellement assigné à votre compte.</p>
    </div>
<?php endif; ?>