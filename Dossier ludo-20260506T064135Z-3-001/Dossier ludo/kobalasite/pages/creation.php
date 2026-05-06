<?php

$utilisateur = get_utilisateur_connecte($connexion); 

$estAutorise = ($utilisateur['role'] === 'Admin') || a_permission($connexion, $utilisateur['idU'], 'Lancer des recherches');
if (!$utilisateur) {
    header('Location: index.php?page=connexion');
    exit;
}
if (!$estAutorise) {
    header('Location: index.php?page=rapports&idB=' . ($utilisateur['idB'] ?? 1) . '&erreur=acces_refuse');
    exit;
}

$idB = isset($_GET['idB']) ? (int)$_GET['idB'] : ($utilisateur['idB'] ?? 1);
$query_zones = "SELECT idMz, nameMz FROM MARITIMEZONE ORDER BY nameMz";
$rz = mysqli_query($connexion, $query_zones);

?>

<div class="entete-page">
    <div>
        <h2 class="titre-page">✏️ Nouveau rapport</h2>
    </div>
    <a href="index.php?page=rapports&idB=<?= $idB ?>" class="btn btn-contour btn-sm">
        ← Retour
    </a>
</div>

<div class="carte" style="max-width:600px">
    <form method="POST" action="index.php?page=rapports&idB=<?= $idB ?>">
        

        <div class="form-groupe">
            <label>Type de recherche</label>
            <input class="form-input" name="typeS" placeholder="SONAR, RADAR, Température...">
        </div>

        <div class="form-groupe">
            <label>Zone maritime</label>
            <select class="form-input" name="idMz">
                <?php while ($z = mysqli_fetch_assoc($rz)): ?>
                    <option value="<?= $z['idMz'] ?>">
                        <?= htmlspecialchars($z['nameMz']) ?>
                    </option>
                <?php endwhile; ?>
            </select>
        </div>

        <div class="form-groupe">
            <label>Contenu</label>
            <textarea class="form-input" name="contenu" placeholder="Décrivez vos observations ici..."></textarea>
        </div>
        <div class="ligne">
            <button type="submit" class="btn btn-principal">Publier</button>
            <button type="button" class="btn btn-contour">Brouillon</button>
        </div>

    </form>
</div>