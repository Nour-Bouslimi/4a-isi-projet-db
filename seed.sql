PRAGMA foreign_keys = ON;

-- Utilisateurs de test
-- ATTENTION : les mots de passe sont des valeurs provisoires, pas de vrais hachés.
-- Ces comptes ne pourront pas se connecter tant que le back n'aura pas défini la méthode de hachage.
INSERT INTO utilisateur (nom_utilisateur, mot_de_passe, role, bloque) VALUES
    ('admin',  'HASH_A_REMPLACER', 'admin',    0),
    ('alice',  'HASH_A_REMPLACER', 'standard', 0),
    ('bob',    'HASH_A_REMPLACER', 'standard', 0),
    ('charlie','HASH_A_REMPLACER', 'standard', 1);  -- compte bloqué

-- Produits
INSERT INTO produit (nom, description, prix, stock, disponible) VALUES
    ('Sandwich jambon-beurre', 'Baguette, jambon, beurre',   3.50, 20, 1),
    ('Salade César',           'Poulet, parmesan, croûtons', 5.00, 10, 1),
    ('Quiche lorraine',        'Part individuelle',          4.00, 8,  1),
    ('Yaourt nature',          NULL,                         1.20, 30, 1),
    ('Tarte aux pommes',       'Part individuelle',          2.50, 12, 1),
    ('Eau 50 cl',              NULL,                         1.00, 50, 1),
    ('Jus d''orange',          'Bouteille 33 cl',            1.80, 0,  0);  -- rupture, masqué

-- Menus (un jour, une semaine, permanent)
INSERT INTO menu (nom, description, prix, date_debut, date_fin) VALUES
    ('Menu du lundi',      'Quiche + dessert + boisson', 6.50, '2026-11-23', '2026-11-23'),
    ('Menu de la semaine', 'Sandwich + yaourt + eau',    5.00, '2026-11-23', '2026-11-27'),
    ('Menu permanent',     'Sandwich + eau',             4.00, NULL, NULL);

-- Composition des menus
INSERT INTO menu_produit (menu_id, produit_id) VALUES
    (1, 3), (1, 5), (1, 6),   -- Menu du lundi : quiche, tarte, eau
    (2, 1), (2, 4), (2, 6),   -- Menu de la semaine : sandwich, yaourt, eau
    (3, 1), (3, 6);           -- Menu permanent : sandwich, eau

-- Jours de fermeture
INSERT INTO fermeture (date_fermeture, motif) VALUES
    ('2026-12-25', 'Noël'),
    ('2027-01-01', 'Jour de l''an');

-- Commandes
INSERT INTO commande (utilisateur_id, date_commande, date_retrait, statut) VALUES
    (2, '2026-11-17 10:00:00', '2026-11-23', 'en_attente'),   -- alice
    (3, '2026-11-16 09:30:00', '2026-11-17', 'recuperee'),    -- bob
    (4, '2026-11-10 12:00:00', '2026-11-12', 'non_honoree');  -- charlie

-- Lignes de commande (soit un produit, soit un menu)
INSERT INTO ligne_commande (commande_id, produit_id, menu_id, quantite) VALUES
    (1, NULL, 1, 1),   -- alice : 1 menu du lundi
    (1, 2, NULL, 1),   -- alice : 1 salade César
    (2, 1, NULL, 2),   -- bob : 2 sandwichs
    (3, NULL, 2, 1);   -- charlie : 1 menu de la semaine