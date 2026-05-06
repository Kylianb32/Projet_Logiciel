use bandjougou;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM RECEIVED_DATA;
DELETE FROM CONDUCTS;
DELETE FROM IS_ALLOWED_TO;
DELETE FROM DISPOSE_OF;
DELETE FROM MEASURE;
DELETE FROM RESEARCH;
DELETE FROM RESEARCHRESULT;
DELETE FROM DOOR;
DELETE FROM DEVICE;
DELETE FROM ROOM;
DELETE FROM USER;
DELETE FROM BOAT;
DELETE FROM MARITIMEZONE;
DELETE FROM DEVICETYPE;
DELETE FROM PERMISSION;
DELETE FROM ROLE;
-- -------------------------
-- ROLE
-- -------------------------
INSERT INTO ROLE (idR, descriptionR) VALUES
(1, 'Administrateur'),
(2, 'Capitaine'),
(3, 'Pilote maritime'),
(4, 'Second'), 
(5, 'Matelots'),
(6, 'Technicien'),
(7, 'Opérateur de bord'),
(8, 'Cuisinier'),
(9, 'Scientifique');

-- -------------------------
-- PERMISSION
-- -------------------------
INSERT INTO PERMISSION (idP, descriptionP) VALUES 
(1, 'Lire les mesures des capteurs (Multisensor)'),
(2, 'Modifier/Écrire les mesures des capteurs'),
(3, 'Administrer les serveurs Raspberry (redémarrage, MAJ, logs)'),
(4, 'Maintenance et étalonnage des capteurs'),
(5, 'Contrôler les radars (activation, portée, configuration)'),
(6, 'Consulter les données GPS et géolocalisation'),
(7, 'Gérer les utilisateurs (création, modification, suppression)'),
(8, 'Gérer les bateaux (ajout, suppression, modification)'),
(9, 'Gérer l''équipage (matelots, affectation aux bateaux)'),
(10, 'Lancer des campagnes de recherche'),
(11, 'Consulter les résultats de recherche'),
(12, 'Administrer tous les devices (configuration, flashing OS)'),
(13, 'Lire les logs système des devices'),
(14, 'Contrôler l''accès aux salles (portes)'),
(15, 'Consulter les données de navigation (radar + GPS)'),
(16, 'Exporter les données (mesures, recherches, logs)'),
(17, 'Gérer les alertes et anomalies'),
(18, 'Administrer la base de données maritime');
-- -------------------------
-- MARITIMEZONE
-- -------------------------
INSERT INTO MARITIMEZONE (idMz, nameMz, typeMz, latitudeMz, longitudeMz, radiusMz, descriptionMz) VALUES
(1, 'Zone Atlantique Nord', 'EXCLUSIVE', 47.5000, -8.2000, 120.0, 'Zone économique exclusive côte ouest'),
(2, 'Zone Méditerranée Ouest', 'SURVEILLANCE', 42.3000, 4.8000, 80.0, 'Surveillance trafic maritime intensif'),
(3, 'Zone Golfe de Gascogne', 'RESTRICTED', 45.0000, -4.5000, 60.0, 'Zone à accès restreint, pêche interdite'),
(4, 'Zone Manche Est', 'TRANSIT', 50.9000, 1.7000, 50.0, 'Couloir de transit international'),
(5, 'Zone Archipel des Açores', 'PROTECTED', 38.7200, -27.2200, 200.0, 'Zone de protection de la biodiversité marine'),
(6, 'Zone Mer du Nord', 'SURVEILLANCE', 56.0000, 3.5000, 150.0, 'Zone d exploitation pétrolière surveillée');

-- -------------------------
-- DEVICETYPE 
-- -------------------------
INSERT INTO DEVICETYPE (idDt, nameDt, actionDt) VALUES
(1,'Multisensor',      'MESURE'),
(2,'Prise connect', 'MESURE'),
(3, 'Door/Window Sensor', 'DETECTION' ),
(4, 'GPS',   'LOCALISATION'),
(5, 'Radar marin',    'DETECTION'),
(6, 'Boutton', 'DETECTION' ),
(7, 'Serveur', 'GESTION' );

-- -------------------------
-- BATEAU
-- -------------------------
INSERT INTO BOAT  (idB, nameB, maxspeedB, capacityB,registrationB, lenghtB) VALUES
(1, 'Le Téméraire',      22.5, 18, 'FR-BRE-2019-0042', 48.2),
(2, 'L''Intrépide',      19.0, 12, 'FR-MED-2021-0117', 38.7),
(3, 'Millenium Falcon',  28.0, 6,  'FR-ATL-2020-0008', 62.0),
(4, 'La Gavroche',       16.5, 24, 'FR-MAN-2018-0233', 55.0),
(5, 'Nautilus II',       31.0, 8,  'FR-BRE-2022-0055', 70.5),
(6, 'Le Petit Prince',   14.0, 10, 'FR-MED-2017-0089', 32.0),
(7, 'Enterprise',        25.5, 30, 'FR-ATL-2023-0003', 88.0),
(8, 'La Pérouse',        20.0, 15, 'FR-MAN-2016-0155', 45.0);

-- -------------------------
-- SALLE
-- -------------------------
INSERT INTO ROOM (idRo, nameRo, typeRo, descriptionRo, idB) VALUES
(1,  'Passerelle de commandement', 'COMMANDEMENT', 'Pont principal de navigation',            1),
(2,  'Salle des machines',         'TECHNIQUE',    'Moteurs et systèmes de propulsion',        1),
(3,  'Cabine capitaine',           'CABINE',        'Cabine privée du capitaine',               1),
(4,  'Passerelle principale',      'COMMANDEMENT', 'Centre de contrôle',                       2),
(5,  'Salle radar',                'TECHNIQUE',    'Équipements radar et sonar',               2),
(6,  'Salle de repos',             'VIE',           'Espace de repos pour l équipage',          2),
(7,  'Poste de pilotage',          'COMMANDEMENT', 'Pilotage automatique et manuel',           3),
(8,  'Soute à matériel',           'STOCKAGE',     'Stockage équipements et vivres',           3),
(9,  'Passerelle de commandement', 'COMMANDEMENT', 'Pont de navigation du Gavroche',           4),
(10, 'Infirmerie',                 'VIE',           'Soins médicaux de base',                   4),
(11, 'Centre de contrôle Nautilus','COMMANDEMENT', 'Contrôle plongée et systèmes embarqués',  5),
(12, 'Laboratoire',                'TECHNIQUE',    'Analyse des données et échantillons',      5),
(13, 'Cuisine et réfectoire',      'VIE',           'Repas et détente équipage',               6),
(14, 'Pont avant',                 'TECHNIQUE',    'Équipements de pêche et caméras',          6),
(15, 'Salle de commandement',      'COMMANDEMENT', 'Centre névralgique Enterprise',            7),
(16, 'Salle de conférence',        'VIE',           'Réunions et briefings',                   7),
(17, 'Salle des machines',         'TECHNIQUE',    'Turbines et systèmes électriques',         8),
(18, 'Poste de garde',             'SECURITE',     'Surveillance périmétrique',                8);


-- -------------------------
-- USER
-- -------------------------
INSERT INTO USER (idU, usernameU, surnameU, nameU, emailU, pwdU, crea_date, idR, idB) VALUES
(1,  'jmartin',       'Martin',      'Matin',        'matin.martin@maritime.fr',         'aaa', '2021-01-15', 1, NULL),
(2,  'sdupont',       'Dupont',      'Antoine',      'antoine.dupont@maritime.fr',       'aaa', '2021-03-22', 2, 1),
(3,  'lbernard',      'Bernard',     'Arnaud',       'l.bernard@maritime.fr',           'aaa', '2021-06-10', 3, 1),
(4,  'byron16',      'Love' ,    'Byron' ,      'byron.love@maritime.fr',     'aaa', '2022-01-05', 4, 1),
(5,  'hsolomon',      'Solomon',     'Han',         'han.solomon@maritime.fr',         'aaa', '2022-04-18', 5, 1),
(6,  'jverne_obs',    'Ovnie',       'Jul',       'jules.verne@maritime.fr',         'aaa', '2020-07-04', 5, 1),
(7,  'nemo.captain',  'Nita',        'Leon',   'leon.nita@maritime.fr',        'aaa', '2020-02-14', 5, 1),
(8,  'mleroy',        'Leroy',       'Merlin',      'merlin.leroy@maritime.fr',        'aaa', '2022-08-30', 6, 1),
(9,  'cgarcia',     'Faure',    'Thomas',          'carmen.garcia@maritime.fr',       'aaa', '2023-01-20', 7, 1),
(10, 'tmoreau',    'Dixsept' , 'Nicolas',      'thomas.moreau@maritime.fr',       'aaa', '2023-03-11', 8, 1),
(11, 'lfontaine',       'Sadiaka',   'Kais',       'lucie.fontaine@maritime.fr',      'aaa', '2021-11-08', 8, 1),
(12, 'tromich',    'Trogneux',      'Michel ',    'jeanluc.picard@maritime.fr',      'aaa', '2020-10-21', 9, 1),
(13, 'nakaya',      'Nakamura',       'aya',        'remi.detoo@maritime.fr',          'aaa', '2022-06-15', 9, 1),
(14, 'isabelleT',     'Ichigo',      'kurosaki',    'isabelle.toulon@maritime.fr',     'aaa', '2021-09-03', 9, 1),
(15, 'ladkoba',     'LaD',      'Koba',    'isabelle.toulon@maritime.fr',     'aaa', '2021-09-03', 9, 1),
(16, 'pdvandjik',     'PlusDur',      'Vandjik',    'plusdure.vandjik@maritime.fr',     'aaa', '2021-09-03', 9, 1),
(17, 'admin_sys',     'Admin',       'Système',     'admin@maritime.fr',               'aaa', '2020-01-01', 9, 1),

(18, 'cap_tainhook',   'Hook',        'James',        'hook.james@maritime.fr',          'aaa', '2021-02-10', 2, 2),
(19, 'jack_sparow',    'Sparow',      'Jacky',        'jacky.sparow@maritime.fr',        'aaa', '2021-05-12', 3, 2),
(20, 'mer_credi',      'Credi',       'Mer',          'mer.credi@maritime.fr',           'aaa', '2022-03-18', 4, 2),
(21, 'flotte_man',     'Flotte',      'Manuel',       'manuel.flotte@maritime.fr',       'aaa', '2022-07-21', 5, 2),
(22, 'ala_derives',      'Derives',     'Alain',        'alain.derives@maritime.fr',       'aaa', '2020-11-09', 5, 2),
(23, 'naufrageur',     'Naufrage',    'Hugo',         'hugo.naufrage@maritime.fr',       'aaa', '2023-01-02', 5, 2),
(24, 'tech_ocean',     'Ocean',       'Theo',         'theo.ocean@maritime.fr',          'aaa', '2021-09-14', 6, 2),
(25, 'radar_lamouette','Lamouette',   'Jean',         'jean.lamouette@maritime.fr',      'aaa', '2022-06-30', 7, 2),
(26, 'khtu_lu',        'Khturin',       'Lucy',         'karl.sonar@maritime.fr',          'aaa', '2023-02-25', 7, 2),
(27, 'chef_otarie',    'Otarie',      'Gordon',       'gordon.otarie@maritime.fr',       'aaa', '2021-04-01', 8, 2),
(28, 'ratat_mer',      'Ratat',       'Mer',          'ratat.mer@maritime.fr',           'aaa', '2022-12-12', 8, 2),
(29, 'dr_kraken',      'Kraken',      'Victor',       'victor.kraken@maritime.fr',       'aaa', '2020-08-08', 9, 2),
(30, 'algue_bra',      'Bra',         'Alain',        'alain.bra@maritime.fr',           'aaa', '2021-10-19', 9, 2),
(31, 'planctonix',     'Plancton',    'Felix',        'felix.plancton@maritime.fr',      'aaa', '2023-03-03', 9, 2),
(32, 'deep_blue',      'Blue',        'Deep',         'deep.blue@maritime.fr',           'aaa', '2022-05-27', 3, 2),
(33, 'marin_dsel',     'Sel',         'Marin',        'marin.sel@maritime.fr',           'aaa', '2021-07-17', 5, 2),
(34, 'admin_bis',      'Admin',       'Secondaire',   'admin2@maritime.fr',              'aaa', '2020-01-02', 1, NULL);

-- -------------------------
-- DEVICE
-- -------------------------
INSERT INTO DEVICE (idD, nameD, statusD, idDt, idRo) VALUES
 
-- ============================================================
-- SERVEURS (1 par bateau, placé dans la salle principale)
-- idDt=7, idM=NULL (pas de mesure, gestion uniquement)
-- ============================================================
(1,  'Raspberry-01',    'ACTIF', 7, 1),
(2,  'Raspberry-02',    'ACTIF', 7, 4),
(3,  'Raspberry-03',   'ACTIF', 7, 7),
(4,  'Raspberry-04',     'ACTIF', 7, 9),
(5,  'Raspberry-05',     'ACTIF', 7, 11),
(6,  'Raspberry-06',  'ACTIF', 7, 13),
(7,  'Raspberry-07',   'ACTIF', 7, 15),
(8,  'Raspberry-08',    'ACTIF', 7, 17), 
-- ============================================================
-- MULTISENSORS (2-3 par bateau, salles clés)
-- idDt=1
-- ============================================================
-- Bateau 1 - Le Téméraire
(9,  'Multi-01 Passerelle TEM', 'ACTIF', 1, 1),
(10, 'Multi-02 Machines TEM',   'ACTIF', 1, 2),
(11, 'Multi-03 Cabine TEM',     'ACTIF', 1, 3),
-- Bateau 2 - L'Intrépide
(12, 'Multi-04 Passerelle INT', 'ACTIF', 1, 4),
(13, 'Multi-05 Repos INT',      'ACTIF', 1, 6),
-- Bateau 3 - Millenium Falcon
(14, 'Multi-06 Pilotage MLF',   'ACTIF', 1, 7),
(15, 'Multi-07 Soute MLF',      'ACTIF', 1, 8),
-- Bateau 4 - La Gavroche
(16, 'Multi-08 CMD GAV',        'ACTIF', 1, 9),
(17, 'Multi-09 Infirmerie GAV', 'ACTIF', 1, 10),
-- Bateau 5 - Nautilus II
(18, 'Multi-10 CtrlNaut NAU',   'ACTIF', 1, 11),
(19, 'Multi-11 Labo NAU',       'ACTIF', 1, 12),
-- Bateau 6 - Le Petit Prince
(20, 'Multi-12 Cuisine PPR',    'ACTIF', 1, 13),
(21, 'Multi-13 Pont PPR',       'ACTIF', 1, 14),
-- Bateau 7 - Enterprise
(22, 'Multi-14 CMD ENT',        'ACTIF', 1, 15),
(23, 'Multi-15 Conference ENT', 'ACTIF', 1, 16),
-- Bateau 8 - La Pérouse
(24, 'Multi-16 Machines LPE',   'ACTIF', 1, 17),
(25, 'Multi-17 Garde LPE',      'ACTIF', 1, 18),
 
-- ============================================================
-- GPS (1 par bateau)
-- idDt=4
-- ============================================================
(26, 'GPS-01 Téméraire',        'ACTIF', 4, 1),
(27, 'GPS-02 Intrépide',        'ACTIF', 4, 4),
(28, 'GPS-03 MillFalcon',       'ACTIF', 4, 7),
(29, 'GPS-04 Gavroche',         'ACTIF', 4, 9),
(30, 'GPS-05 Nautilus',         'ACTIF', 4, 11),
(31, 'GPS-06 PetitPrince',      'ACTIF', 4, 13),
(32, 'GPS-07 Enterprise',       'ACTIF', 4, 15),
(33, 'GPS-08 LaPerouse',        'ACTIF', 4, 17),
 
-- ============================================================
-- RADAR (sur les bateaux qui en ont besoin)
-- idDt=5
-- ============================================================
(34, 'Radar-01 Téméraire',      'ACTIF',       5, 1),
(35, 'Radar-02 Intrépide',      'ACTIF',       5, 4),
(36, 'Radar-03 Gavroche',       'ACTIF',       5, 9),
(37, 'Radar-04 Enterprise',     'ACTIF',       5, 15),
(38, 'Radar-05 LaPerouse',      'MAINTENANCE', 5, 17),
 
-- ============================================================
-- DOOR/WINDOW SENSORS (1 par porte — 18 portes au total)
-- idDt=3, idM=NULL (détection, pas de mesure continue)
-- ============================================================
(39, 'Door-01 Passerelle TEM',  'ACTIF', 3, 1),
(40, 'Door-02 Machines TEM',    'ACTIF', 3, 2),
(41, 'Door-03 Cabine TEM',      'ACTIF', 3, 3),
(42, 'Door-04 Passerelle INT',  'ACTIF', 3, 4),
(43, 'Door-05 Radar INT',       'ACTIF', 3, 5),
(44, 'Door-06 Repos INT',       'ACTIF', 3, 6),
(45, 'Door-07 Soute MLF',       'ACTIF', 3, 8),
(46, 'Door-08 Pilotage MLF',    'ACTIF', 3, 7),
(47, 'Door-09 CMD GAV',         'ACTIF', 3, 9),
(48, 'Door-10 Infirmerie GAV',  'ACTIF', 3, 10),
(49, 'Door-11 Nautilus CMD',    'ACTIF', 3, 11),
(50, 'Door-12 Labo NAU',        'ACTIF', 3, 12),
(51, 'Door-13 Cuisine PPR',     'ACTIF', 3, 13),
(52, 'Door-14 Pont PPR',        'ACTIF', 3, 14),
(53, 'Door-15 CMD ENT',         'ACTIF', 3, 15),
(54, 'Door-16 Conference ENT',  'ACTIF', 3, 16),
(55, 'Door-17 Machines LPE',    'ACTIF', 3, 17),
(56, 'Door-18 Garde LPE',       'ACTIF', 3, 18);

-- -------------------------
-- MEASURE (avant DEVICE car DEVICE référence MESURES)
-- -------------------------
INSERT INTO MEASURE (idM, typeM, dataM, dateM, idD) VALUES
(1,  'TEMPERATURE', '{"valeur": 18.4, "unite": "°C"}', '2026-04-15 10:00:00', 9),
(2,  'PRESSION',    '{"valeur": 1013.2, "unite": "hPa"}', '2026-04-15 10:05:00', 9),
(3,  'HUMIDITE',    '{"valeur": 72, "unite": "%"}', '2026-04-15 10:10:00', 10),
(4,  'VITESSE_VENT','{"valeur": 24.5, "unite": "km/h", "direction": "NNO"}', '2026-04-15 10:15:00', 9),
(5,  'TEMPERATURE', '{"valeur": 21.1, "unite": "°C"}', '2026-04-15 10:20:00', 11),
(6,  'SONAR',       '{"profondeur": 340, "anomalies": false}', '2026-04-16 08:30:00', 18),
(7,  'GPS',         '{"lat": 47.23, "lon": -5.67, "precision": 2.1}', '2026-04-16 08:35:00', 26),
(8,  'RADAR',       '{"portee": 48, "cibles_detectees": 3}', '2026-04-16 08:40:00', 34),
(9,  'TEMPERATURE', '{"valeur": 15.8, "unite": "°C"}', '2026-04-16 09:00:00', 12),
(10, 'PRESSION',    '{"valeur": 1008.7, "unite": "hPa"}', '2026-04-16 09:05:00', 12),
(11, 'SONAR',       '{"profondeur": 210, "anomalies": true}', '2026-04-16 09:10:00', 16),
(12, 'GPS',         '{"lat": 50.12, "lon": 1.98, "precision": 1.5}', '2026-04-16 09:15:00', 27),
(13, 'HUMIDITE',    '{"valeur": 85, "unite": "%"}', '2026-04-16 09:20:00', 13),
(14, 'VITESSE_VENT','{"valeur": 42.0, "unite": "km/h", "direction": "SO"}', '2026-04-17 14:00:00', 12),
(15, 'RADAR',       '{"portee": 36, "cibles_detectees": 7}', '2026-04-17 14:05:00', 35),
(16, 'BATHYMETRIE', '{"profondeur": 1250.5, "type_sol": "vaseux", "pente": "5%"}', '2026-04-17 14:10:00', 19),
(17, 'MAGNETOMETRIE', '{"intensite": 48000, "unite": "nT", "anomalie": "positive"}', '2026-04-17 14:15:00', 19),
(18, 'HYDROPHONE', '{"frequence": 15000, "db": 110, "signature": "cliquetis_cetace"}', '2026-04-17 14:20:00', 18),
(19, 'QUALITE_EAU', '{"ph": 8.1, "salinite": 35.2, "oxygene_dissous": 6.5}', '2026-04-17 14:25:00', 19),
(20, 'TURBIDITE', '{"valeur": 1.2, "unite": "NTU", "visibilite": "bonne"}', '2026-04-17 14:30:00', 21),
(21, 'COURANTOMETRIE', '{"vitesse": 1.5, "noeud": 0.8, "direction": 185}', '2026-04-17 14:35:00', 21),
(22, 'HOULOMETRIE', '{"hauteur_vagues": 3.2, "periode": 8.5, "unite": "sec"}', '2026-04-17 14:40:00', 23),
(23, 'LUMINOSITE', '{"valeur": 450, "unite": "lux", "couverture_nuageuse": "2/8"}', '2026-04-17 14:45:00', 22),
(24, 'AIS_DATA', '{"mmsi": 227123450, "vitesse": 12.4, "destination": "Brest"}', '2026-04-17 14:50:00', 34),
(25, 'RADAR_ECHO', '{"distance": 12, "angle": 45, "taille_echo": "petite"}', '2026-04-17 14:55:00', 34);

-- -------------------------
-- SEARCHRESULT (avant SEARCH car SEARCH référence SEARCHRESULT)
-- -------------------------
INSERT INTO RESEARCHRESULT (idRr, typeRr, dataRr, reliabilityRr, idD) VALUES
(1, 'OBJET_FLOTTANT', '{"taille": "2m", "nature": "debris_plastique"}',  87.5, NULL),
(2, 'NAVIRE',         '{"pavillon": "PT", "type": "cargo"}',              94.0, NULL),
(3, 'ANOMALIE_FOND',  '{"type": "epave", "profondeur_estimee": 320}',     72.0, NULL),
(4, 'NAVIRE',         '{"pavillon": "ES", "type": "peche"}',              91.0, NULL),
(5, 'MAMMIFERE',      '{"espece_probable": "dauphin", "groupe": 12}',     65.0, NULL),
(6, 'OBJET_FLOTTANT', '{"taille": "0.5m", "nature": "inconnu"}',         55.0, NULL),
(7, 'NAVIRE',         '{"pavillon": "FR", "type": "voilier"}',            98.0, NULL),
(8, 'ANOMALIE_FOND',  '{"type": "concentration_algues"}',                 80.0, NULL),
(9, 'FORMATION_GEOLOGIQUE', '{"nom": "Canyon Interne", "type": "faille", "sediment": "rocheux"}', 89.0, NULL),
(10, 'RESSOURCE_MINERALE', '{"type": "nodules_polymetalliques", "densite": "elevee"}', 62.5, NULL),
(11, 'MAMMIFERE', '{"espece": "Rorqual commun", "taille_groupe": 2, "comportement": "transit"}', 95.0, NULL),
(12, 'FLORE_PROTEGEE', '{"espece": "Herbier de Posidonie", "etat": "degrade"}', 78.0, NULL),
(13, 'PHENOMENE_METEO', '{"type": "Grain", "rafale_max": 55, "duree_estimee": "30min"}', 92.0, NULL),
(14, 'DERIVE_OBJET', '{"type": "nappe_hydrocarbure", "surface_estimee": "500m2"}', 85.0, NULL),
(15, 'NAVIRE_SUSPECT', '{"motif": "AIS_coupe", "vitesse_anormale": true}', 70.0, NULL),
(16, 'EPAVE_FLOTTANTE', '{"type": "conteneur_isole", "danger_navigation": "eleve"}', 99.0, NULL);



-- -------------------------
-- SEARCH
-- -------------------------
INSERT INTO RESEARCH (idRs, typeRs, paramRs,research_dateRs ,  idRr, idMz,idB , statusRs) VALUES
(1,  'SONAR',      '{"profondeur_min": 100, "profondeur_max": 500}', '2026-01-10 08:00:00', 3, 1, 3, 'TERMINE'),
(2,  'RADAR',      '{"portee": 50, "filtre_taille": "moyen"}',       '2026-01-12 14:30:00', 2, 4, 1, 'TERMINE'),
(3,  'VISUEL',     '{"heure": "diurne", "conditions": "bonnes"}',    '2026-01-15 10:15:00', 1, 2, 2, 'TERMINE'),
(4,  'RADAR',      '{"portee": 30, "filtre_type": "peche"}',         '2026-02-01 09:00:00', 4, 3, 7, 'ABANDONNE'),
(5,  'SONAR',      '{"profondeur_min": 50, "profondeur_max": 200}',  '2026-02-05 11:45:00', 5, 5, 5, 'TERMINE'),
(6,  'VISUEL',     '{"heure": "crepuscule"}',                        '2026-02-10 18:20:00', 6, 2, 6, 'EN_COURS'),
(7,  'RADAR',      '{"portee": 40, "filtre_pavillon": "FR"}',        '2026-03-01 13:00:00', 7, 4, 4, 'EN_COURS'),
(8,  'SONAR',      '{"profondeur_min": 10, "profondeur_max": 80}',   '2026-03-05 15:30:00', 8, 6, 8, 'TERMINE'),
(9,  'SCAN_FONDS', '{"resolution": "haute", "frequence": "100kHz"}', '2026-03-10 07:45:00', 9, 5, 1, 'ABANDONNE'),
(10, 'OBS_BIO',    '{"methode": "echantillonnage_eau", "duree": "24h"}', '2026-03-20 12:00:00', 11, 2, 2, 'EN_COURS'),
(11, 'METEO_SURV', '{"alerte_seuil": "vent_fort", "intervalle_mesure": "10min"}', '2026-04-01 16:10:00', 13, 1, 3, 'EN_COURS'),
(12, 'RADAR_PATROL', '{"mode": "anti_collision", "rayon": 20}',      '2026-04-10 10:00:00', 16, 4, 4, 'TERMINE');


-- -------------------------
-- DISPOSE (rôle → permission)
-- -------------------------
INSERT INTO DISPOSE_OF (idR, idP) VALUES 
-- Administrateur (idR=1) : tous les droits
(1, 1),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7),(1, 8),(1, 9),(1, 10),(1, 11),(1, 12),(1, 13),(1, 14),(1, 15),(1, 16),(1, 17),(1, 18),

-- Capitaine (idR=2)
(2, 1),(2, 3),(2, 5),(2, 6),(2, 9),(2, 10),(2, 11),(2, 15),(2, 17),

-- Pilote maritime (idR=3)
(3, 1),(3, 5),(3, 6),(3, 15),(3, 17),

-- Second (idR=4)
(4, 1),(4, 3),(4, 6),(4, 11),(4, 13),(4, 17),

-- Matelots (idR=5)
(5, 1),(5, 14),(5, 17),

-- Technicien (idR=6)
(6, 1),(6, 2),(6, 3),(6, 4),(6, 12),(6, 13),(6, 16),

-- Opérateur de bord (idR=7)
(7, 1),(7, 5),(7, 6),(7, 10),(7, 11),(7, 15),(7, 16),

-- Cuisinier (idR=8)
(8, 1),(8, 17),

-- Scientifique (idR=9)
(9, 1),(9, 2),(9, 4),(9, 10),(9, 11),(9, 16);

-- -------------------------
-- PEUT_EFFECTUER
-- -------------------------

INSERT INTO IS_ALLOWED_TO  (idU, idP, idD, action) VALUES
-- Admin (idU=1) : admin BDD + gestion
(1, 18, 1, 'ADMIN_BDD'),

-- Capitaine Téméraire (idU=2)
(2, 3, 1, 'REDEMARRER_SERVEUR'),
(2, 5, 34, 'ACTIVER_RADAR'),
(2, 6, 34, 'MODIFIER_PORTEE_RADAR'),
(2, 9, 1, 'AJOUTER_MATELOT'),
(2, 10, 34, 'LANCER_RECHERCHE'),

-- Second Téméraire (idU=4)
(4, 3, 1, 'CONSULTER_LOGS_SERVEUR'),
(4, 13, 1, 'LIRE_LOGS_SYSTEME'),

-- Technicien Téméraire (idU=8)
(8, 4, 9, 'ETALONNER_CAPTEUR'),
(8, 12, 1, 'MAINTENANCE_SERVEUR'),

-- Opérateur Téméraire (idU=7)
(7, 5, 34, 'LIRE_DONNEES_RADAR'),
(7, 6, 26, 'LIRE_GPS'),
(7, 16, 34, 'EXPORTER_DONNEES_RADAR'),

-- Scientifique Nautilus (idU=12)
(12, 4, 19, 'ETALONNER_CAPTEUR'),
(12, 10, 19, 'LANCER_RECHERCHE'),
(12, 16, 19, 'EXPORTER_MESURES'),

-- Cuisinier Téméraire (idU=10)
(10, 17, 1, 'SIGNALER_PENURIE'),

-- Matelot Téméraire (idU=5)
(5, 14, 39, 'FERMER_PORTE'),
(5, 17, 1, 'SIGNALER_ANOMALIE_SERVEUR'),

-- Capitaine Intrépide (idU=18)
(18, 3, 2, 'REDEMARRER_SERVEUR'),
(18, 5, 35, 'ACTIVER_RADAR'),
(18, 9, 2, 'AJOUTER_MATELOT'),

-- Second Intrépide (idU=20)
(20, 3, 2, 'CONSULTER_LOGS_SERVEUR'),

-- Technicien Intrépide (idU=24)
(24, 4, 12, 'ETALONNER_CAPTEUR'),
(24, 12, 2, 'MAINTENANCE_SERVEUR'),

-- Pilote Téméraire (idU=3)
(3, 5, 34, 'LIRE_DONNEES_RADAR'),
(3, 6, 26, 'LIRE_GPS'),

-- Pilote Intrépide (idU=19)
(19, 5, 35, 'LIRE_DONNEES_RADAR'),
(19, 6, 27, 'LIRE_GPS'),

-- Admin système (idU=17)
(17, 12, 1, 'CONFIGURER_RASPBERRY'),
(17, 12, 2, 'CONFIGURER_RASPBERRY'),
(17, 12, 3, 'CONFIGURER_RASPBERRY'),
(17, 12, 4, 'CONFIGURER_RASPBERRY'),
(17, 12, 5, 'CONFIGURER_RASPBERRY'),
(17, 12, 6, 'CONFIGURER_RASPBERRY'),
(17, 12, 7, 'CONFIGURER_RASPBERRY'),
(17, 12, 8, 'CONFIGURER_RASPBERRY'),
(17, 8, 1, 'FLASHER_OS'),
(17, 8, 2, 'FLASHER_OS'),
(17, 8, 3, 'FLASHER_OS'),
(17, 8, 4, 'FLASHER_OS'),
(17, 8, 5, 'FLASHER_OS'),
(17, 8, 6, 'FLASHER_OS'),
(17, 8, 7, 'FLASHER_OS'),
(17, 8, 8, 'FLASHER_OS'),

-- Admin secondaire (idU=34)
(34, 7, 1, 'CONSULTER_TOUS_BATEAUX'),
(34, 8, 2, 'AJOUTER_BATEAU'),

-- Cuisinier Intrépide (idU=11)
(11, 1, 2, 'CONSULTER_RATIONS'),

-- Scientifique Téméraire (idU=13)
(13, 2, 10, 'LIRE_MESURES_MACHINES'),

-- Opérateur Intrépide (idU=9)
(9, 5, 35, 'LIRE_DONNEES_RADAR'),
(9, 6, 27, 'LIRE_GPS');


-- -------------------------
-- EFFECTUER_RECHERCHE
-- -------------------------
INSERT INTO CONDUCTS (idU, idRs) VALUES
(2,  1),
(4,  3),
(7,  5),
(12, 2),
(9,  6),
(10, 7),
(14, 4),
(2,  8),
(7,  2),
(12, 4);


-- -------------------------
-- DOOR
-- -------------------------
INSERT INTO DOOR (idDo, nameDo, statusDo, idRo1, idRo2) VALUES 
(1, 'Porte principale passerelle',  'FERME',  1, 2),
(2,  'Accès machines tribord',  'FERME',  2, NULL),
(3,  'Porte cabine capitaine',  'FERME',  3, 1), 
(4,  'Sas passerelle bâbord',  'OUVERT', 4, 5), 
(5,  'Porte radar accès restreint',  'FERME',  5, NULL), 
(6,  'Porte salle de repos',  'OUVERT', 6, 4),  
(7,  'Écoutille soute avant',  'FERME',  8, NULL), 
(8,  'Porte pilotage auto',  'FERME',  7, 8), 
(9,  'Porte commandement Gavroche',  'FERME',  9, 10), 
(10, 'Porte infirmerie',  'OUVERT', 10, NULL),
(11, 'Sas plongée Nautilus',  'FERME',  11, NULL),
(12, 'Porte labo sécurisé',  'FERME',  12, 11), 
(13, 'Porte réfectoire',  'OUVERT', 13, 14), 
(14, 'Trappe pont avant',  'FERME',  14, NULL),
(15, 'Porte commandement Enterprise', 'FERME',  15, 16), 
(16, 'Salle de conférence entrée', 'OUVERT', 16, NULL), 
(17, 'Porte machines La Pérouse',  'FERME',  17, 18), 
(18, 'Porte poste de garde',  'OUVERT', 18, NULL);




-- -------------------------
-- DONNEES_RECUES
-- -------------------------
INSERT INTO RECEIVED_DATA (idM, idRr) VALUES
(6,  3),
(8,  2),
(1,  1),
(7,  7),
(11, 4),
(15, 7),
(6,  5),
(3,  6),
(12, 4),
(9,  8),
(14, 2),
(5,  1);


SET FOREIGN_KEY_CHECKS = 1;
