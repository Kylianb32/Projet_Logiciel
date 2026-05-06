<div class="carte carte-connexion">
    <div style="font-size:32px;margin-bottom:8px">⚓</div>
    <h2 class="titre-page" style="text-align:center">Connexion</h2>
    <p style="font-size:12px;color:var(--gris);margin-bottom:16px">Accès réservé au personnel Oro Jackson</p>
    <?php if (isset($_GET['erreur'])): ?>
        <div class="alerte alerte-critique" style="margin-bottom:12px">Identifiant ou mot de passe incorrect.</div>
    <?php endif; ?>
    <form method="POST" action="index.php?page=login">
        <div class="form-groupe" style="text-align:left"><label>Identifiant</label><input class="form-input" name="username" placeholder="ex : matudicharo" required></div>
        <div class="form-groupe" style="text-align:left"><label>Mot de passe</label><input class="form-input" name="mdp" type="password" placeholder="••••••••" required></div>
        <button type="submit" class="btn btn-navy" style="width:100%;justify-content:center">Se connecter</button>
    </form>
    <p style="font-size:10px;color:#AAA;margin-top:12px">Démo : mdp = <code>ce mot de passe m'a été promis il y a 3000ans  </code></p>
    <a href="index.php?page=accueil" style="font-size:12px">← Accueil</a>
</div>
