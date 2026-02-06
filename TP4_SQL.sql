-- TP 4 – Commandes SQL (Base Voyageur)
-- Auteur : Alberto Nahra
-- =========================
-- Sélections simples
-- =========================

-- 1) Afficher tous les voyageurs.
SELECT * FROM Voyageur;

-- 2) Afficher le nom et la région de tous les voyageurs vivant en Corse.
SELECT nom, region
FROM Voyageur
WHERE region = 'Corse';

-- 3) Afficher les logements situés dans les Alpes.
SELECT *
FROM Logement
WHERE lieu = 'Alpes';

-- 4) Afficher le nom et le type des logements ayant une capacité supérieure à 30.
SELECT nom, type
FROM Logement
WHERE capacite > 30;

-- 5) Afficher les logements dont le type est Hôtel ou Gîte.
SELECT *
FROM Logement
WHERE type IN ('Hôtel', 'Gîte');

-- 6) Afficher les voyageurs dont la région n’est pas Bretagne.
SELECT *
FROM Voyageur
WHERE region <> 'Bretagne';

-- 7) Afficher les séjours commençant avant le jour 20.
SELECT *
FROM Sejour
WHERE debut < 20;

-- 8) Afficher les activités dont la description contient le mot dériveur.
SELECT *
FROM Activite
WHERE description LIKE '%dériveur%';

-- =========================
-- Tri et limitation
-- =========================

-- 9) Afficher les voyageurs triés par nom alphabétique.
SELECT *
FROM Voyageur
ORDER BY nom ASC;

-- 10) Afficher les logements triés par capacité décroissante.
SELECT *
FROM Logement
ORDER BY capacite DESC;

-- 11) Afficher les 2 logements ayant la plus grande capacité.
SELECT *
FROM Logement
ORDER BY capacite DESC
LIMIT 2;

-- =========================
-- AND / OR / NOT
-- =========================

-- 12) Afficher les voyageurs habitant Corse ou Bretagne.
SELECT *
FROM Voyageur
WHERE region = 'Corse' OR region = 'Bretagne';

-- 13) Afficher les logements situés en Corse et de type Gîte.
SELECT *
FROM Logement
WHERE lieu = 'Corse' AND type = 'Gîte';

-- 14) Afficher les logements non situés en Alpes.
SELECT *
FROM Logement
WHERE lieu <> 'Alpes';

-- 15) Afficher les séjours ayant un début > 15 et une fin < 23.
SELECT *
FROM Sejour
WHERE debut > 15 AND fin < 23;

-- =========================
-- Jointures entre tables
-- =========================

-- 16) Afficher le nom des voyageurs et le nom du logement de chacun de leurs séjours.
SELECT v.nom AS voyageur, l.nom AS logement
FROM Voyageur v
JOIN Sejour s   ON s.idVoyageur = v.idVoyageur
JOIN Logement l ON l.idLogement = s.idLogement;

-- 17) Afficher les voyageurs ayant séjourné en Corse.
SELECT DISTINCT v.nom
FROM Voyageur v
JOIN Sejour s   ON s.idVoyageur = v.idVoyageur
JOIN Logement l ON l.idLogement = s.idLogement
WHERE l.lieu = 'Corse';

-- 18) Afficher les voyageurs ayant séjourné dans les Alpes.
SELECT DISTINCT v.nom
FROM Voyageur v
JOIN Sejour s   ON s.idVoyageur = v.idVoyageur
JOIN Logement l ON l.idLogement = s.idLogement
WHERE l.lieu = 'Alpes';

-- 19) Afficher le type et le lieu des logements visités par Nicolas Bouvier.
SELECT DISTINCT l.type, l.lieu
FROM Voyageur v
JOIN Sejour s   ON s.idVoyageur = v.idVoyageur
JOIN Logement l ON l.idLogement = s.idLogement
WHERE v.nom = 'Nicolas Bouvier';

-- 20) Afficher les activités proposées dans les logements où Phileas Fogg a séjourné.
SELECT DISTINCT a.*
FROM Voyageur v
JOIN Sejour s    ON s.idVoyageur = v.idVoyageur
JOIN Logement l  ON l.idLogement = s.idLogement
JOIN Activite a  ON a.idLogement = l.idLogement
WHERE v.nom = 'Phileas Fogg';

-- 21) Afficher les séjours avec le nom du voyageur et le lieu du logement associé.
SELECT s.*, v.nom AS voyageur, l.lieu AS lieu_logement
FROM Sejour s
JOIN Voyageur v ON v.idVoyageur = s.idVoyageur
JOIN Logement l ON l.idLogement = s.idLogement;

-- 22) Afficher le nom des voyageurs ayant effectué au moins un séjour, ainsi que l’identifiant du séjour.
SELECT v.nom, s.idSejour
FROM Voyageur v
JOIN Sejour s ON s.idVoyageur = v.idVoyageur;

-- 23) Afficher le nom des voyageurs et le nom des logements uniquement pour les séjours existants.
SELECT v.nom AS voyageur, l.nom AS logement
FROM Sejour s
JOIN Voyageur v ON v.idVoyageur = s.idVoyageur
JOIN Logement l ON l.idLogement = s.idLogement;

-- 24) Afficher tous les voyageurs, ainsi que leurs séjours s’ils existent.
SELECT v.*, s.*
FROM Voyageur v
LEFT JOIN Sejour s ON s.idVoyageur = v.idVoyageur;

-- 25) Afficher les voyageurs n’ayant effectué aucun séjour.
SELECT v.*
FROM Voyageur v
LEFT JOIN Sejour s ON s.idVoyageur = v.idVoyageur
WHERE s.idSejour IS NULL;

-- 26) Afficher tous les logements, ainsi que les activités proposées (si elles existent).
SELECT l.*, a.*
FROM Logement l
LEFT JOIN Activite a ON a.idLogement = l.idLogement;

-- 27) Afficher tous les séjours, même si le logement associé n’existe pas.
SELECT s.*, l.*
FROM Sejour s
LEFT JOIN Logement l ON l.idLogement = s.idLogement;

-- 28) Afficher tous les voyageurs et tous les séjours, y compris ceux sans correspondance.
-- NOTE : FULL OUTER JOIN n'existe pas dans MySQL. OK sur PostgreSQL/SQL Server/Oracle.
SELECT v.*, s.*
FROM Voyageur v
FULL OUTER JOIN Sejour s ON s.idVoyageur = v.idVoyageur;

-- 29) Afficher les logements qui ne proposent aucune activité.
SELECT l.*
FROM Logement l
LEFT JOIN Activite a ON a.idLogement = l.idLogement
WHERE a.idActivite IS NULL;

-- 30) Afficher les voyageurs qui n’ont jamais séjourné dans aucun logement.
SELECT v.*
FROM Voyageur v
LEFT JOIN Sejour s ON s.idVoyageur = v.idVoyageur
WHERE s.idSejour IS NULL;

-- =========================
-- Conditions sur plusieurs tables
-- =========================

-- 31) Afficher les voyageurs ayant fait un séjour dans un logement dont la capacité est supérieure à 30.
SELECT DISTINCT v.*
FROM Voyageur v
JOIN Sejour s   ON s.idVoyageur = v.idVoyageur
JOIN Logement l ON l.idLogement = s.idLogement
WHERE l.capacite > 30;

-- 32) Afficher les logements qui n’ont aucune activité.
SELECT l.*
FROM Logement l
LEFT JOIN Activite a ON a.idLogement = l.idLogement
WHERE a.idActivite IS NULL;

-- 33) Afficher les voyageurs n’ayant jamais séjourné dans un hôtel.
SELECT v.*
FROM Voyageur v
WHERE NOT EXISTS (
  SELECT 1
  FROM Sejour s
  JOIN Logement l ON l.idLogement = s.idLogement
  WHERE s.idVoyageur = v.idVoyageur
    AND l.type = 'Hôtel'
);

-- 34) Afficher les logements où plusieurs voyageurs différents ont séjourné.
SELECT l.*
FROM Logement l
JOIN Sejour s ON s.idLogement = l.idLogement
GROUP BY l.idLogement, l.nom, l.type, l.lieu, l.capacite
HAVING COUNT(DISTINCT s.idVoyageur) > 1;

-- =========================
-- Agrégats
-- =========================

-- 35) Compter le nombre total de voyageurs.
SELECT COUNT(*) AS nb_voyageurs
FROM Voyageur;

-- 36) Compter le nombre de logements par type.
SELECT type, COUNT(*) AS nb_logements
FROM Logement
GROUP BY type;

-- 37) Compter le nombre de séjours effectués par chaque voyageur.
SELECT idVoyageur, COUNT(*) AS nb_sejours
FROM Sejour
GROUP BY idVoyageur;

-- 38) Afficher le nombre d’activités proposées par chaque logement.
SELECT idLogement, COUNT(*) AS nb_activites
FROM Activite
GROUP BY idLogement;

-- 39) Afficher la capacité moyenne des logements.
SELECT AVG(capacite) AS capacite_moyenne
FROM Logement;

-- 40) Trouver le logement ayant la capacité maximale.
SELECT *
FROM Logement
WHERE capacite = (SELECT MAX(capacite) FROM Logement);

-- 41) Afficher les voyageurs ayant fait au moins 2 séjours.
SELECT v.*
FROM Voyageur v
JOIN Sejour s ON s.idVoyageur = v.idVoyageur
GROUP BY v.idVoyageur, v.nom, v.region
HAVING COUNT(*) >= 2;

-- 42) Compter combien de séjours ont eu lieu en Corse.
SELECT COUNT(*) AS nb_sejours_corse
FROM Sejour s
JOIN Logement l ON l.idLogement = s.idLogement
WHERE l.lieu = 'Corse';

-- =========================
-- Sous-requêtes
-- =========================

-- 43) Afficher les voyageurs ayant fait un séjour dans les Alpes (EXISTS).
SELECT v.*
FROM Voyageur v
WHERE EXISTS (
  SELECT 1
  FROM Sejour s
  JOIN Logement l ON l.idLogement = s.idLogement
  WHERE s.idVoyageur = v.idVoyageur
    AND l.lieu = 'Alpes'
);

-- 44) Afficher les voyageurs n’ayant jamais fait de séjour en Corse (NOT EXISTS).
SELECT v.*
FROM Voyageur v
WHERE NOT EXISTS (
  SELECT 1
  FROM Sejour s
  JOIN Logement l ON l.idLogement = s.idLogement
  WHERE s.idVoyageur = v.idVoyageur
    AND l.lieu = 'Corse'
);

-- 45) Afficher les logements où ont séjourné des voyageurs de la même région que le logement (IN).
SELECT l.*
FROM Logement l
WHERE l.idLogement IN (
  SELECT s.idLogement
  FROM Sejour s
  JOIN Voyageur v ON v.idVoyageur = s.idVoyageur
  WHERE v.region = l.lieu
);

-- 46) Afficher les logements qui n’ont pas d’activités (NOT IN).
SELECT l.*
FROM Logement l
WHERE l.idLogement NOT IN (
  SELECT DISTINCT idLogement
  FROM Activite
);

-- 47) Afficher les voyageurs dont le nombre de séjours est supérieur à la moyenne.
SELECT v.*
FROM Voyageur v
JOIN Sejour s ON s.idVoyageur = v.idVoyageur
GROUP BY v.idVoyageur, v.nom, v.region
HAVING COUNT(*) > (
  SELECT AVG(nb_sej)
  FROM (
    SELECT COUNT(*) AS nb_sej
    FROM Sejour
    GROUP BY idVoyageur
  ) t
);

-- =========================
-- Opérations ensemblistes
-- =========================

-- 48) Afficher la liste des régions des voyageurs ou des lieux de logement (UNION).
SELECT region AS val
FROM Voyageur
UNION
SELECT lieu AS val
FROM Logement;

-- 49) Afficher les régions communes aux voyageurs et aux lieux de logement (INTERSECT).
SELECT region
FROM Voyageur
INTERSECT
SELECT lieu
FROM Logement;

-- 50) Afficher les régions présentes chez les voyageurs mais absentes dans les lieux de logement (EXCEPT/MINUS).
SELECT region
FROM Voyageur
EXCEPT
SELECT lieu
FROM Logement;

-- =========================
-- Pour aller plus loin
-- =========================

-- 51) Afficher les voyageurs et le nombre total de jours passés en séjour (fin - debut).
SELECT v.nom, SUM(s.fin - s.debut) AS total_jours
FROM Voyageur v
JOIN Sejour s ON s.idVoyageur = v.idVoyageur
GROUP BY v.nom;

-- 52) Afficher la liste des voyageurs avec les activités qu’ils ont pu pratiquer
-- (Voyageur → Séjour → Logement → Activité).
SELECT DISTINCT v.nom AS voyageur, a.nom AS activite
FROM Voyageur v
JOIN Sejour s    ON s.idVoyageur = v.idVoyageur
JOIN Logement l  ON l.idLogement = s.idLogement
JOIN Activite a  ON a.idLogement = l.idLogement
ORDER BY v.nom, a.nom;

-- 53) Trouver les logements ayant toutes les activités disponibles dans la base
-- (HAVING COUNT(DISTINCT ...) = (SELECT COUNT(...))).
SELECT l.*
FROM Logement l
JOIN Activite a ON a.idLogement = l.idLogement
GROUP BY l.idLogement, l.nom, l.type, l.lieu, l.capacite
HAVING COUNT(DISTINCT a.idActivite) = (SELECT COUNT(*) FROM Activite);

-- 54) Afficher les voyageurs qui ont séjourné dans toutes les régions existantes.
SELECT v.*
FROM Voyageur v
WHERE NOT EXISTS (
  SELECT DISTINCT lieu
  FROM Logement
  EXCEPT
  SELECT DISTINCT l.lieu
  FROM Sejour s
  JOIN Logement l ON l.idLogement = s.idLogement
  WHERE s.idVoyageur = v.idVoyageur
);
