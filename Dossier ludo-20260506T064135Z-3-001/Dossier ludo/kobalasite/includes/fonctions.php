<?php
/**
 * fonctions.php — Fonctions utilitaires du site Oro Jackson
 * 
 * Contient toutes les fonctions réutilisées par les pages.
 * Chaque fonction utilise des requêtes imbriquées (sous-requêtes)
 * conformément au MLD du rapport.
 */


/**
 * Récupère l'utilisateur connecté avec son rôle et son bateau.
 * Sous-requêtes dans le SELECT pour éviter les JOIN.
 */
function get_utilisateur_connecte($connexion) {
    if (!isset($_SESSION['idU'])) {
        return null;
    }
    $idU = (int) $_SESSION['idU'];

    $query = "SELECT U.idU, U.usernameU, U.nameU, U.surnameU, U.emailU, U.crea_date, U.idR, U.idB,
              (SELECT descriptionR FROM ROLE WHERE idR = U.idR) AS role,
              (SELECT nameB FROM BOAT WHERE idB = U.idB) AS nomBateau
              FROM USER U
              WHERE U.idU = $idU";

    $resultat = mysqli_query($connexion, $query);
    if (!$resultat) return null;
    return mysqli_fetch_assoc($resultat);
}


/**
 * Vérifie si un utilisateur possède une permission donnée.
 * Double imbriquée : USER → ROLE → DISPOSE → PERMISSION
 */
function a_permission($connexion, $idU, $nomPermission) {
    $idU = (int) $idU;
    $nomPermission = mysqli_real_escape_string($connexion, $nomPermission);
    $query = "SELECT COUNT(*) AS perm_disponibles FROM DISPOSE_OF
              WHERE idR = (SELECT idR FROM USER WHERE idU = $idU)
              AND idP = (SELECT idP FROM PERMISSION WHERE descriptionP = '$nomPermission')";

    $resultat = mysqli_query($connexion, $query);
    $ligne = mysqli_fetch_assoc($resultat);
    return ($ligne && $ligne['perm_disponibles'] > 0);
}


/**
 * Récupère la liste des bateaux avec infos calculées.
 * 4 sous-requêtes corrélées dans le SELECT.
 * Le chemin vers la zone maritime passe par BATEAU → SEARCH → MARITIMEZONE.
 */
function get_liste_bateaux($connexion) {
    $query = "SELECT B.idB, 
    B.nameB, 
    B.maxspeedB, 
    B.capacityB, 
    B.registrationB, 
    B.lenghtB, 
    (SELECT nameMz FROM MARITIMEZONE WHERE idMz =
        (SELECT idMz FROM RESEARCH WHERE idB = B.idB LIMIT 1)) AS zone_maritime,
        (SELECT COUNT(*) FROM USER WHERE idB = B.idB) AS nb_membres,
        (SELECT COUNT(*) FROM DEVICE WHERE statusD = 'ACTIF' AND idRo IN
        (SELECT idRo FROM ROOM WHERE idB = B.idB)) AS nb_capteurs,
        (SELECT COUNT(*) FROM DOOR WHERE statusDo = 'OUVERT' AND idRo1 IN
        (SELECT idRo FROM ROOM WHERE idB = B.idB)) AS portes_ouvertes 
FROM BOAT B 
ORDER BY B.idB;";

    $resultat = mysqli_query($connexion, $query);
    $bateaux = [];
    while ($ligne = mysqli_fetch_assoc($resultat)) {
        $bateaux[] = $ligne;
    }
    return $bateaux;
}


/**
 * Récupère les mesures des capteurs d'un bateau.
 * Triple imbriquée : MESURES → DEVICE → SALLE → BATEAU
 */
function get_mesures_bateau($connexion, $idB) {
    $idB = (int) $idB;

$query = "SELECT M.idM, 
M.typeM, 
M.dataM, 
(SELECT nameD FROM DEVICE WHERE idD = M.idD) AS nom_device, 
(SELECT nameDt FROM DEVICETYPE WHERE idDt = 
(SELECT idDt FROM DEVICE WHERE idD = M.idD)) AS type_device, 
(SELECT nameRo FROM ROOM WHERE idRo = 
(SELECT idRo FROM DEVICE WHERE idD = M.idD)) AS nom_salle 
FROM MEASURE M  WHERE M.idD IN 
(SELECT idD FROM DEVICE WHERE idRo IN 
(SELECT idRo FROM ROOM WHERE idB = $idB)) 
ORDER BY M.idM DESC";

    $resultat = mysqli_query($connexion, $query);
    $mesures = [];
    while ($ligne = mysqli_fetch_assoc($resultat)) {
        $mesures[] = $ligne;
    }
    return $mesures;
}


/**
 * Récupère les portes d'un bateau avec le nom des salles.
 * Sous-requêtes dans le SELECT + imbriquée dans le WHERE.
 * 
 */
function get_portes_bateau($connexion, $idB) {
    $idB = (int) $idB;
$query = "SELECT 
        D.idDo, 
        D.nameDo, 
        D.statusDo,
        (SELECT nameRo FROM ROOM WHERE idRo = D.idRo1) AS salle_source,
        (SELECT nameRo FROM ROOM WHERE idRo = D.idRo2) AS salle_destination 
    FROM DOOR D 
    WHERE D.idRo1 IN (SELECT idRo FROM ROOM WHERE idB = $idB) 
       OR D.idRo2 IN (SELECT idRo FROM ROOM WHERE idB = $idB)";

    $resultat = mysqli_query($connexion, $query);
    $portes = [];
    while ($ligne = mysqli_fetch_assoc($resultat)) {
        $portes[] = $ligne;
    }
    return $portes;
}


/**
 * Récupère l'équipage d'un bateau avec rôle et stats.
 * 3 sous-requêtes corrélées dans le SELECT.
 */
function get_equipage_bateau($connexion, $idB) {
    $idB = (int) $idB;

    $query = "SELECT U.idU, U.usernameU, U.nameU, U.surnameU, U.emailU, U.crea_date,
              (SELECT descriptionR FROM ROLE WHERE idR = U.idR) AS role,
              (SELECT COUNT(*) FROM DISPOSE_OF WHERE idR = U.idR) AS nb_permissions,
              (SELECT COUNT(*) FROM IS_ALLOWED_TO WHERE idU = U.idU) AS nb_actions
              FROM USER U
              WHERE U.idB = $idB
              ORDER BY U.idR, U.nameU";

    $resultat = mysqli_query($connexion, $query);
    $membres = [];
    while ($ligne = mysqli_fetch_assoc($resultat)) {
        $membres[] = $ligne;
    }
    return $membres;
}


/**
 * Récupère les recherches scientifiques liées à un bateau.
 * Sous-requêtes dans SELECT. Chemin : BATEAU.idS → SEARCH → SEARCHRESULT + MARITIMEZONE.
 */
function get_recherches_bateau($connexion, $idB) {
    $idB = (int) $idB;

    $query = "SELECT RS.idRs, RS.typeRs, RS.paramRs, RS.StatusRs, 
    (SELECT typeRr FROM RESEARCHRESULT WHERE idRr = RS.idRr) AS type_result, 
    (SELECT dataRr FROM RESEARCHRESULT WHERE idRr = RS.idRr) AS data_result, 
    (SELECT reliabilityRr FROM RESEARCHRESULT WHERE idRr = RS.idRr) AS reliability, 
    (SELECT nameMz FROM MARITIMEZONE WHERE idMz = RS.idMz) AS maritine_zone, 
    (SELECT typeMz FROM MARITIMEZONE WHERE idMz = RS.idMz) AS type_zone 
    FROM RESEARCH RS WHERE RS.idB IN (SELECT idB FROM BOAT WHERE idRs = $idRs);";

    $resultat = mysqli_query($connexion, $query);
    $recherches = [];
    while ($ligne = mysqli_fetch_assoc($resultat)) {
        $recherches[] = $ligne;
    }
    return $recherches;
}


/**
 * Récupère l'historique des actions sur un bateau.
 * 7 sous-requêtes dans SELECT + triple imbriquée dans WHERE.
 */
function get_historique_actions($connexion, $idB) {
    $idB = (int) $idB;

$query = "SELECT AT.action, 
(SELECT usernameU FROM USER WHERE idU = AT.idU) AS user,
(SELECT CONCAT(nameU, ' ', surnameU) FROM USER WHERE idU = AT.idU) AS nom_complet, 
(SELECT descriptionR FROM ROLE WHERE idR = 
(SELECT idR FROM USER WHERE idU = AT.idU)) AS role, 
(SELECT nameD FROM DEVICE WHERE idD = AT.idD) AS nom_device,
(SELECT nameDt FROM DEVICETYPE WHERE idDt =
(SELECT idDt FROM DEVICE WHERE idD = AT.idD)) AS type2lappareil, 
(SELECT descriptionP FROM PERMISSION WHERE idP = AT.idP) AS permission 
FROM IS_ALLOWED_TO AT WHERE AT.idD IN
(SELECT idD FROM DEVICE WHERE idRo IN
(SELECT idRo FROM ROOM WHERE idB = $idB))";

    $resultat = mysqli_query($connexion, $query);
    $actions = [];
    while ($ligne = mysqli_fetch_assoc($resultat)) {
        $actions[] = $ligne;
    }
    return $actions;
}


/**
 * Récupère l'historique des données reçues pour un bateau.
 * Quadruple imbriquée dans WHERE + sous-requêtes dans SELECT.
 */
function get_historique_donnees($connexion, $idB) {
    $idB = (int) $idB;

    $query = "SELECT 
    (SELECT dateM FROM MEASURE WHERE idM = RD.idM) AS date_reception,
    (SELECT typeM FROM MEASURE WHERE idM = RD.idM) AS type_mesure, 
    (SELECT dataM FROM MEASURE WHERE idM = RD.idM) AS donnees_mesure, 
    (SELECT nameD FROM DEVICE WHERE idD = 
    (SELECT idD FROM MEASURE WHERE idM = RD.idM)) AS nom_device,
    (SELECT typeRr FROM RESEARCHRESULT WHERE idRr = RD.idRr) AS type_resultat, 
    (SELECT reliabilityRr FROM RESEARCHRESULT WHERE idRr = RD.idRr) AS fiabilite 
    FROM RECEIVED_DATA RD WHERE RD.idM IN 
    (SELECT idM FROM MEASURE WHERE idD IN
    (SELECT idD FROM DEVICE WHERE idRo IN
    (SELECT idRo FROM ROOM WHERE idB = $idB))) 
    ORDER BY date_reception DESC";

    $resultat = mysqli_query($connexion, $query);
    $donnees = [];
    while ($ligne = mysqli_fetch_assoc($resultat)) {
        $donnees[] = $ligne;
    }
    return $donnees;
}


/**
 * Récupère la fiche technique complète d'un bateau.
 * 6 sous-requêtes dont des doubles imbriquées.
 */
function get_fiche_bateau($connexion, $idB) {
    $idB = (int) $idB;

    $query = "SELECT B.idB, B.nameB, B.maxspeedB, B.capacityB, B.registrationB, B.lenghtB, 
    (SELECT nameMz FROM MARITIMEZONE WHERE idMz =
        (SELECT idMz FROM RESEARCH WHERE idB = B.idB LIMIT 1)) AS zone_maritime, 
    (SELECT typeMz FROM MARITIMEZONE WHERE idMz =
        (SELECT idMz FROM RESEARCH WHERE idB = B.idB LIMIT 1)) AS type_zone,
    (SELECT COUNT(*) FROM USER WHERE idB = B.idB) AS nb_member, 
    (SELECT COUNT(*) FROM DEVICE WHERE statusD = 'ACTIF' AND idRo IN 
        (SELECT idRo FROM ROOM WHERE idB = B.idB)) AS nb_captors,
    (SELECT COUNT(*) FROM ROOM WHERE idB = B.idB) AS nb_room, 
    (SELECT COUNT(*) FROM DOOR WHERE idRo1 IN
        (SELECT idRo FROM ROOM WHERE idB = B.idB)) AS nb_door 
FROM BOAT B 
WHERE B.idB = $idB";

    $resultat = mysqli_query($connexion, $query);
    return mysqli_fetch_assoc($resultat);
}
?>
