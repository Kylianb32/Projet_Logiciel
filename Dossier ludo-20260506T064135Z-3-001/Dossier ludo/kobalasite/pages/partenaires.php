<?php $utilisateur=get_utilisateur_connecte($connexion);if(!$utilisateur){header('Location:index.php?page=connexion');exit;}?>
<div class="entete-page"><div><h2 class="titre-page">🤝 Partenaires & Financeurs</h2></div><a href="index.php?page=bateau" class="btn btn-contour btn-sm">← Retour</a></div>
<div class="grille-2"><div class="carte" style="text-align:center"><div style="font-size:36px;margin-bottom:8px">🏛️</div><h3>Institut DOMONOOB</h3><p style="font-size:12px;color:var(--gris)">Financeur principal ( le papa de Mathieu ). Cartographie des fonds marins.</p></div>
<div class="carte" style="text-align:center"><div style="font-size:36px;margin-bottom:8px">🌊</div><h3>NOAA</h3><p style="font-size:12px;color:var(--gris)">Partenaire scientifique. Modèles climatiques.</p></div></div>
