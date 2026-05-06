-- ============================================================
-- BASE DE DONNÉES OROJACKSON
-- MLD exact du rapport final (page 16)
-- À importer dans phpMyAdmin du Raspberry Pi
-- ============================================================

CREATE DATABASE IF NOT EXISTS orojackson CHARACTER SET utf8mb4;
USE orojackson;

CREATE TABLE ROLE (
    idR INT PRIMARY KEY AUTO_INCREMENT,
    descriptifR VARCHAR(100) NOT NULL
);

CREATE TABLE PERMISSION (
    idP INT PRIMARY KEY AUTO_INCREMENT,
    descriptifP VARCHAR(255) NOT NULL
);

CREATE TABLE DISPOSE (
    idR INT NOT NULL,
    idP INT NOT NULL,
    PRIMARY KEY (idR, idP),
    FOREIGN KEY (idR) REFERENCES ROLE(idR),
    FOREIGN KEY (idP) REFERENCES PERMISSION(idP)
);

CREATE TABLE MARITIMEZONE (
    idMz INT PRIMARY KEY AUTO_INCREMENT,
    nomMz VARCHAR(100) NOT NULL,
    typeMz VARCHAR(50),
    latitudeMz VARCHAR(20),
    longitudeMz VARCHAR(20),
    radiusMz INT,
    descriptifMz TEXT
);

CREATE TABLE DEVICETYPE (
    idDt INT PRIMARY KEY AUTO_INCREMENT,
    nomDt VARCHAR(100) NOT NULL,
    actionDt VARCHAR(100)
);

CREATE TABLE SEARCHRESULT (
    idSr INT PRIMARY KEY AUTO_INCREMENT,
    typeSr VARCHAR(100),
    dataSr TEXT,
    fiabiliteSr INT,
    idD INT DEFAULT NULL
);

CREATE TABLE SEARCH (
    idS INT PRIMARY KEY AUTO_INCREMENT,
    typeS VARCHAR(100),
    paramS TEXT,
    idSr INT,
    idMz INT,
    etatS VARCHAR(30) DEFAULT 'EN_COURS',
    FOREIGN KEY (idSr) REFERENCES SEARCHRESULT(idSr),
    FOREIGN KEY (idMz) REFERENCES MARITIMEZONE(idMz)
);

CREATE TABLE BATEAU (
    idB INT PRIMARY KEY AUTO_INCREMENT,
    nomB VARCHAR(100) NOT NULL,
    vmaxB VARCHAR(20),
    capaciteB INT,
    immatriculationB VARCHAR(50),
    longueurB INT,
    idS INT,
    date_debut DATE,
    FOREIGN KEY (idS) REFERENCES SEARCH(idS)
);

CREATE TABLE USER (
    idU INT PRIMARY KEY AUTO_INCREMENT,
    usernameU VARCHAR(50) NOT NULL UNIQUE,
    nomU VARCHAR(100),
    prenomU VARCHAR(100),
    emailU VARCHAR(150),
    mdpU VARCHAR(255),
    date_crea DATE,
    idR INT,
    idB INT,
    FOREIGN KEY (idR) REFERENCES ROLE(idR),
    FOREIGN KEY (idB) REFERENCES BATEAU(idB)
);

CREATE TABLE SALLE (
    idSa INT PRIMARY KEY AUTO_INCREMENT,
    nomSa VARCHAR(100) NOT NULL,
    typeSa VARCHAR(50),
    descriptifSa TEXT,
    idB INT,
    FOREIGN KEY (idB) REFERENCES BATEAU(idB)
);

CREATE TABLE DOOR (
    idDo INT PRIMARY KEY AUTO_INCREMENT,
    nomDo VARCHAR(100) NOT NULL,
    statutDo VARCHAR(20) DEFAULT 'FERME',
    idSa1 INT,
    idSa2 INT,
    FOREIGN KEY (idSa1) REFERENCES SALLE(idSa),
    FOREIGN KEY (idSa2) REFERENCES SALLE(idSa)
);

CREATE TABLE DEVICE (
    idD INT PRIMARY KEY AUTO_INCREMENT,
    nomD VARCHAR(100) NOT NULL,
    statutD VARCHAR(20) DEFAULT 'ACTIF',
    idDt INT,
    idSa INT,
    date DATE,
    FOREIGN KEY (idDt) REFERENCES DEVICETYPE(idDt),
    FOREIGN KEY (idSa) REFERENCES SALLE(idSa)
);

CREATE TABLE MESURES (
    idM INT PRIMARY KEY AUTO_INCREMENT,
    typeM VARCHAR(50),
    dataM TEXT,
    idD INT,
    FOREIGN KEY (idD) REFERENCES DEVICE(idD)
);

CREATE TABLE PEUT_EFFECTUER (
    idU INT NOT NULL,
    idP INT NOT NULL,
    idD INT NOT NULL,
    action VARCHAR(100),
    FOREIGN KEY (idU) REFERENCES USER(idU),
    FOREIGN KEY (idP) REFERENCES PERMISSION(idP),
    FOREIGN KEY (idD) REFERENCES DEVICE(idD)
);

CREATE TABLE EFFECTUER_RECHERCHE (
    idU INT NOT NULL,
    idS INT NOT NULL,
    PRIMARY KEY (idU, idS),
    FOREIGN KEY (idU) REFERENCES USER(idU),
    FOREIGN KEY (idS) REFERENCES SEARCH(idS)
);

CREATE TABLE DONNEES_RECUES (
    idM INT NOT NULL,
    idSr INT NOT NULL,
    date_reception DATETIME,
    PRIMARY KEY (idM, idSr),
    FOREIGN KEY (idM) REFERENCES MESURES(idM),
    FOREIGN KEY (idSr) REFERENCES SEARCHRESULT(idSr)
);

-- ============================================================
-- DONNÉES D'EXEMPLE (extrait du rapport pages 18-30)
-- ============================================================

INSERT INTO ROLE VALUES (1,'Administrateur'),(2,'Capitaine'),(3,'Pilote maritime'),(4,'Second'),(5,'Matelots'),(6,'Technicien'),(7,'Opérateur de bord'),(8,'Cuisinier'),(9,'Scientifique');

INSERT INTO PERMISSION (idP, descriptifP) VALUES
(1,'Lire les mesures des capteurs'),(2,'Modifier les mesures'),(3,'Administrer les serveurs'),
(4,'Maintenance capteurs'),(5,'Contrôler les radars'),(6,'Consulter GPS'),
(7,'Gérer les utilisateurs'),(8,'Gérer les bateaux'),(9,'Gérer l''équipage'),
(10,'Lancer des recherches'),(11,'Consulter résultats recherche'),(12,'Administrer devices'),
(13,'Lire logs système'),(14,'Contrôler accès salles'),(15,'Consulter navigation'),
(16,'Exporter données'),(17,'Gérer alertes'),(18,'Administrer BDD maritime');

INSERT INTO DISPOSE (idR,idP) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),
(2,1),(2,3),(2,5),(2,6),(2,9),(2,10),(2,11),(2,15),(2,17),
(3,1),(3,5),(3,6),(3,15),(3,17),
(4,1),(4,3),(4,6),(4,11),(4,13),(4,17),
(5,1),(5,14),(5,17),
(6,1),(6,2),(6,3),(6,4),(6,12),(6,13),(6,16),
(7,1),(7,5),(7,6),(7,10),(7,11),(7,15),(7,16),
(8,1),(8,17),
(9,1),(9,2),(9,4),(9,10),(9,11),(9,16);

INSERT INTO MARITIMEZONE VALUES
(1,'Zone Atlantique Nord','EXCLUSIVE','47.5000','-8.2000',120,'Zone économique exclusive'),
(2,'Zone Méditerranée Ouest','SURVEILLANCE','42.3000','4.8000',80,'Surveillance trafic maritime'),
(3,'Zone Golfe de Gascogne','RESTRICTED','45.0000','-4.5000',60,'Zone accès restreint'),
(4,'Zone Manche Est','TRANSIT','50.9000','1.7000',50,'Couloir transit international'),
(5,'Zone Açores','PROTECTED','38.7200','-27.2200',200,'Protection biodiversité marine'),
(6,'Zone Mer du Nord','SURVEILLANCE','56.0000','3.5000',150,'Exploitation pétrolière');

INSERT INTO DEVICETYPE VALUES (1,'Multisensor','MESURE'),(2,'Prise connectée','MESURE'),(3,'Door/Window Sensor','DETECTION'),(4,'GPS','LOCALISATION'),(5,'Radar marin','DETECTION'),(6,'Bouton','COMMANDE'),(7,'Serveur','GESTION');

INSERT INTO SEARCHRESULT (idSr,typeSr,dataSr,fiabiliteSr,idD) VALUES
(1,'OBJET_FLOTTANT','{"taille":"2m","nature":"debris"}',87,NULL),
(2,'NAVIRE','{"pavillon":"PT","type":"cargo"}',94,NULL),
(3,'ANOMALIE_FOND','{"type":"epave","profondeur":320}',72,NULL);

INSERT INTO SEARCH VALUES
(1,'SONAR','{"profondeur_min":100}',3,1,'TERMINE'),
(2,'RADAR','{"portee":50}',2,4,'TERMINE'),
(3,'VISUEL','{"heure":"diurne"}',1,2,'TERMINE');

INSERT INTO BATEAU VALUES
(1,'Le Téméraire','22.5',18,'FR-BRE-2019-0042',48,2,'2019-03-15'),
(2,'L''Intrépide','19.0',12,'FR-MED-2021-0117',38,3,'2021-07-01');

INSERT INTO USER (idU,usernameU,nomU,prenomU,emailU,mdpU,date_crea,idR,idB) VALUES
(1,'jmartin','Martin','Matin','matin.martin@maritime.fr','aaa','2021-01-15',1,NULL),
(2,'sdupont','Dupont','Antoine','antoine.dupont@maritime.fr','aaa','2021-03-22',2,1),
(3,'lbernard','Bernard','Arnaud','l.bernard@maritime.fr','aaa','2021-06-10',3,1),
(4,'byron16','Love','Byron','byron.love@maritime.fr','aaa','2022-01-05',4,1),
(5,'hsolomon','Solomon','Han','han.solomon@maritime.fr','aaa','2022-04-18',5,1),
(6,'mleroy','Leroy','Merlin','merlin.leroy@maritime.fr','aaa','2022-08-30',6,1),
(7,'cgarcia','Faure','Thomas','carmen.garcia@maritime.fr','aaa','2023-01-20',7,1),
(8,'tmoreau','Dixsept','Nicolas','thomas.moreau@maritime.fr','aaa','2023-03-11',8,1),
(9,'tromich','Trogneux','Michel','jeanluc.picard@maritime.fr','aaa','2020-10-21',9,1),
(10,'cap_tainhook','Hook','James','hook.james@maritime.fr','aaa','2021-02-10',2,2),
(11,'attente_user','Attente','Test','attente@maritime.fr','aaa','2024-01-01',5,NULL);

INSERT INTO SALLE VALUES
(1,'Passerelle de commandement','COMMANDEMENT','Pont principal',1),
(2,'Salle des machines','TECHNIQUE','Moteurs et propulsion',1),
(3,'Cabine capitaine','CABINE','Cabine privée du capitaine',1),
(4,'Passerelle principale','COMMANDEMENT','Centre de contrôle',2),
(5,'Salle radar','TECHNIQUE','Équipements radar',2);

INSERT INTO DOOR VALUES
(1,'Porte principale passerelle','FERME',1,2),
(2,'Accès machines tribord','FERME',2,NULL),
(3,'Porte cabine capitaine','FERME',3,1),
(4,'Sas passerelle bâbord','OUVERT',4,5),
(5,'Porte radar accès restreint','FERME',5,NULL);

INSERT INTO DEVICE (idD,nomD,statutD,idDt,idSa,date) VALUES
(1,'Raspberry-01','ACTIF',7,1,'2021-01-01'),
(9,'Multi-01 Passerelle','ACTIF',1,1,'2021-01-10'),
(10,'Multi-02 Machines','ACTIF',1,2,'2021-01-10'),
(26,'GPS-01 Téméraire','ACTIF',4,1,'2021-01-01'),
(34,'Radar-01 Téméraire','ACTIF',5,1,'2021-01-01'),
(39,'Door-01 Passerelle','ACTIF',3,1,'2021-01-15');

INSERT INTO MESURES (idM,typeM,dataM,idD) VALUES
(1,'TEMPERATURE','{"valeur":18.4,"unite":"°C"}',9),
(2,'PRESSION','{"valeur":1013.2,"unite":"hPa"}',9),
(7,'GPS','{"lat":47.23,"lon":-5.67}',26),
(8,'RADAR','{"portee":48,"cibles":3}',34);

INSERT INTO PEUT_EFFECTUER VALUES
(2,3,1,'REDEMARRER_SERVEUR'),
(2,5,34,'ACTIVER_RADAR'),
(2,9,1,'AJOUTER_MATELOT');

INSERT INTO EFFECTUER_RECHERCHE VALUES (2,1),(4,3);

INSERT INTO DONNEES_RECUES VALUES (1,1,'2023-10-05 11:00:00'),(8,2,'2023-10-01 08:15:00');
