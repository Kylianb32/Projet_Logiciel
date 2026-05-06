<?php


$utilisateur = get_utilisateur_connecte($connexion);


if (!$utilisateur) {
    header('Location: index.php?page=connexion');
    exit;
}

$idB = isset($_GET['idB']) ? (int)$_GET['idB'] : ($utilisateur['idB'] ?? 1);
$fiche = get_fiche_bateau($connexion, $idB);
$equipage = get_equipage_bateau($connexion, $idB);
?>

<div class="entete-page">
    <div>
        <h2 class="titre-page">
            👥 Équipage — <?= htmlspecialchars($fiche['nameB'] ?? '') ?>
        </h2>
    </div>
    <a href="index.php?page=bateau&idB=<?= $idB ?>" class="btn btn-contour btn-sm">
        ← Retour
    </a>
</div>

<div class="carte">
    <table class="tableau">
        <thead>
            <tr>
                <th>Identifiant</th>
                <th>Nom Complet</th>
                <th>Rôle</th>
                <th>Permissions</th>
                <th>Actions réalisées</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($equipage as $m): ?>
                <tr>
                    <td style="font-family:monospace; font-size:11px">
                        <?= htmlspecialchars($m['usernameU']) ?>
                    </td>
                    <td>
                        <?= htmlspecialchars($m['surnameU'] . ' ' . $m['nameU']) ?>
                    </td>
                    <td>
                        <span class="badge badge-<?= strtolower(str_replace(' ', '', $m['role'])) ?>">
                            <?= htmlspecialchars($m['role']) ?>
                        </span>
                    </td>
                    <td style="font-size:11px">
                        <?= $m['nb_permissions'] ?>
                    </td>
                    <td style="font-size:11px">
                        <?= $m['nb_actions'] ?>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>