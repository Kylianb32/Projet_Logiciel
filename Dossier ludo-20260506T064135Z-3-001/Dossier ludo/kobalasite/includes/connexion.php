<?php
/**
 * connexion.php — Connexion à la base de données MariaDB
 * 
 * Ce fichier est inclus par toutes les pages du site.
 * Il ouvre la connexion à la base via mysqli et démarre la session PHP.
 * 
 * Sur le Raspberry Pi :
 *   - Hôte     : localhost (MariaDB tourne en local)
 *   - User     : phpmyadmin (compte par défaut du Raspberry)
 *   - Password : tp (mot de passe par défaut)
 *   - Base     : orojackson (notre base créée via schema.sql)
 * 
 * Justification du choix de mysqli :
 *   - mysqli est l'extension PHP native pour MySQL/MariaDB
 *   - Elle est préinstallée sur le Raspberry Pi
 *   - Pas besoin de PDO pour un projet de cette taille
 */

session_start();

// Paramètres de connexion (à adapter si besoin)
$host = 'localhost';
$user = 'root';
$pass = '';
$base = 'bandjougou';

// Ouverture de la connexion persistante (p: = persistant)
$connexion = mysqli_connect("p:$host", $user, $pass, $base);

// Vérification de la connexion
if (!$connexion) {
    die("Erreur de connexion à la base de données : " . mysqli_connect_error());
}

// On force l'encodage UTF-8 pour éviter les problèmes d'accents
mysqli_set_charset($connexion, 'utf8mb4');
?>
