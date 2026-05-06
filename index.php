<?php
/**
 * index.php — Point d'entrée unique du site Oro Jackson
 * 
 * Ce fichier gère le routage : il charge la bonne page PHP
 * selon le paramètre ?page= dans l'URL.
 * 
 * Architecture choisie (justification) :
 *   - Un seul index.php qui inclut les pages → permet de factoriser
 *     l'en-tête, le pied de page et la connexion BDD.
 *   - Les includes sont séparés (connexion, fonctions, header, footer)
 *     pour respecter le principe de responsabilité unique.
 *   - Chaque page est un fichier PHP indépendant dans /pages/.
 */

// Chargement de la connexion BDD et des fonctions
// Chargement de la connexion BDD et des fonctions
require __DIR__ . '/includes/connexion.php';
require __DIR__ . '/includes/fonctions.php';

// Récupération de la page demandée (défaut = accueil)
$page_courante = isset($_GET['page']) ? $_GET['page'] : 'accueil';


// ============================================================
// TRAITEMENT DU LOGIN (formulaire POST)
// ============================================================
if ($page_courante === 'login' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = mysqli_real_escape_string($connexion, $_POST['username'] ?? '');
    $mdp      = mysqli_real_escape_string($connexion, $_POST['mdp'] ?? '');

    // Requête imbriquée : on récupère l'utilisateur avec son rôle
    $query = "SELECT idU, idB,
              (SELECT descriptifR FROM ROLE WHERE idR = USER.idR) AS role
              FROM USER
              WHERE usernameU = '$username' AND mdpU = '$mdp'";

    $resultat = mysqli_query($connexion, $query);
    $user = mysqli_fetch_assoc($resultat);

    if ($user) {
        $_SESSION['idU'] = $user['idU'];

        // Redirection selon le rôle et l'affectation
        if ($user['idB'] === null) {
            header('Location: index.php?page=attente');
        } elseif (in_array($user['role'], ['Administrateur', 'Capitaine'])) {
            header('Location: index.php?page=selection');
        } else {
            header('Location: index.php?page=bateau&idB=' . $user['idB']);
        }
    } else {
        header('Location: index.php?page=connexion&erreur=1');
    }
    exit;
}


// ============================================================
// DÉCONNEXION
// ============================================================
if ($page_courante === 'deconnexion') {
    session_destroy();
    header('Location: index.php?page=accueil');
    exit;
}


// ============================================================
// RENDU DE LA PAGE
// ============================================================

// Inclusion de l'en-tête (topbar, <head>, etc.)
include __DIR__ . '/includes/header.php';

// Chargement de la page demandée
$pages_valides = [
    'accueil', 'connexion', 'attente', 'selection',
    'bateau', 'dashboard', 'rapports', 'creation',
    'gerer', 'fiche', 'equipage', 'historique',
    'partenaires', 'erreur403'
];

if (in_array($page_courante, $pages_valides)) {
    include __DIR__ . '/pages/' . $page_courante . '.php';
} else {
    include __DIR__ . '/pages/erreur403.php';
}

// Inclusion du pied de page
include __DIR__ . '/includes/footer.php';

// Fermeture propre de la connexion BDD
mysqli_close($connexion);
?>
