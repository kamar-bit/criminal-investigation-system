INSERT INTO personne VALUES
(1,'Martin','Alice','12 rue Nord'), (2,'Durand','Karim','8 avenue Sud'),
(3,'Petit','Laura','5 rue Est'), (4,'Moreau','Yanis','3 rue Ouest'),
(5,'Bernard','Sara','17 rue Paix'), (6,'Roux','Nabil','20 avenue Gare'),
(7,'Garnier','Emma','4 rue Lac'), (8,'Lopez','Hugo','9 rue Parc'),
(9,'Leroy','Mina','2 rue Port'), (10,'Faye','Omar','6 rue Centre'),
(11,'Benoit','Lina','1 rue Jardin'), (12,'Caron','Sofiane','7 rue Gare'),
(13,'Noel','Ines','11 rue Rivoli'), (14,'Masson','Adam','15 rue Seine'),
(15,'Perrin','Nora','18 rue Stade');

INSERT INTO grade VALUES
('Inspecteur','Police judiciaire'), ('Lieutenant','Criminalité organisée'),
('Capitaine','Homicides'), ('Commissaire','Direction'), ('Analyste','Police scientifique');

INSERT INTO enqueteur VALUES
(1,'MAT001','Inspecteur'), (2,'MAT002','Lieutenant'), (3,'MAT003','Capitaine'),
(11,'MAT004','Commissaire'), (12,'MAT005','Analyste');

INSERT INTO suspect VALUES
(4,'principal'), (5,'secondaire'), (6,'en fuite'), (7,'interrogé'), (8,'mis en examen');

INSERT INTO victime VALUES
(5,'blessure légère'), (9,'vol de biens'), (10,'préjudice moral'),
(13,'dommage matériel'), (14,'menace reçue');

INSERT INTO affaire VALUES
(100,'Cambriolage centre-ville','en cours','2026-01-10'),
(101,'Agression nocturne','ouverte','2026-01-18'),
(102,'Fraude documentaire','en cours','2026-02-02'),
(103,'Disparition inquiétante','ouverte','2026-02-15'),
(104,'Trafic local','en cours','2026-03-01');

INSERT INTO affecter VALUES
(1,100,'responsable'), (2,101,'responsable'), (3,102,'responsable'),
(11,103,'responsable'), (12,104,'responsable');

INSERT INTO temoin VALUES
(1,'Haddad','haddad@mail.fr'), (2,'Mercier','mercier@mail.fr'),
(3,'Blanc','blanc@mail.fr'), (4,'Simon','simon@mail.fr'), (5,'Robert','robert@mail.fr');

INSERT INTO temoigner_dans VALUES
(1,100), (2,101), (3,102), (4,103), (5,104);

INSERT INTO lieu_crime VALUES
('10 rue Bleue','Paris','appartement'), ('5 avenue Rouge','Versailles','parking'),
('2 rue Verte','Massy','bureau'), ('14 quai Nord','Paris','entrepôt'),
('8 rue Blanche','Orsay','commerce');

INSERT INTO associer_lieu_affaire VALUES
('10 rue Bleue',100), ('5 avenue Rouge',101), ('2 rue Verte',102),
('14 quai Nord',103), ('8 rue Blanche',104);

INSERT INTO preuve VALUES
(1000,'empreinte','empreinte retrouvée sur une fenêtre','10 rue Bleue',100),
(1001,'vidéo','enregistrement de caméra','5 avenue Rouge',101),
(1002,'document','faux document administratif','2 rue Verte',102),
(1003,'objet','sac abandonné','14 quai Nord',103),
(1004,'ADN','trace biologique','8 rue Blanche',104);

INSERT INTO lier_preuve_suspect VALUES
(1000,4), (1001,5), (1002,6), (1003,7), (1004,8);

INSERT INTO interrogatoire VALUES
(2000,'2026-01-12','Le suspect nie les faits.',1,4,100),
(2001,'2026-01-20','Le suspect reconnaît sa présence.',2,5,101),
(2002,'2026-02-05','Le suspect refuse de répondre.',3,6,102),
(2003,'2026-02-18','Le suspect donne un alibi.',11,7,103),
(2004,'2026-03-03','Le suspect fournit des informations.',12,8,104);

INSERT INTO arrestation VALUES
(3000,'2026-01-13',2000), (3001,'2026-01-21',2001),
(3002,'2026-02-06',2002), (3003,'2026-02-19',2003), (3004,'2026-03-04',2004);

INSERT INTO accusation VALUES
(4000,'vol aggravé','en instruction',4,100),
(4001,'violence volontaire','en instruction',5,101),
(4002,'faux et usage de faux','ouverte',6,102),
(4003,'séquestration','ouverte',7,103),
(4004,'trafic organisé','en instruction',8,104);
