<?php

$utilisateur = get_utilisateur_connecte($connexion);


if (!$utilisateur || !a_permission($connexion, $utilisateur['idU'], "Gérer l'équipage")) {
    header('Location: index.php?page=erreur403');
    exit;
}

$idB = isset($_GET['idB']) ? (int)$_GET['idB'] : ($utilisateur['idB'] ?? 1);
$q = "SELECT 
        U.idU,
        U.usernameU,
        U.nameU,
        U.surnameU,
        (SELECT descriptionR FROM ROLE WHERE idR = U.idR) AS role,
        (SELECT nameB FROM BOAT WHERE idB = U.idB) AS bateau 
      FROM USER U 
      ORDER BY U.idR, U.nameU";

$r = mysqli_query($connexion, $q);
?>
<div class="entete-page">
    <div>
        <h2 class="titre-page">⚙️ Gestion globale de l'équipage</h2>
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
                <th>Bateau assigné</th>
            </tr>
        </thead>
        <tbody>
            <?php while ($m = mysqli_fetch_assoc($r)): ?>[cite: 11]
                <tr>
                    <td style="font-family:monospace; font-size:11px">
                        <?= htmlspecialchars($m['usernameU']) ?>[cite: 11]
                    </td>
                    <td>
                        <?= htmlspecialchars($m['surnameU'] . ' ' . $m['nameU']) ?>[cite: 11]
                    </td>
                    <td>
                        <span class="badge badge-<?= strtolower(str_replace(' ', '', $m['role'])) ?>">
                            <?= htmlspecialchars($m['role']) ?>[cite: 11]
                        </span>
                    </td>
                    <td style="font-size:12px">
                        <?= htmlspecialchars($m['bateau'] ?? 'Non assigné') ?>[cite: 11]
                    </td>
                </tr>
            <?php endwhile; ?>
        </tbody>
    </table>
</div>