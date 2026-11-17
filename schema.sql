-- Active la vérification des clés étrangères (désactivée par défaut dans SQLite)
PRAGMA foreign_keys = ON;

-- Supprime les tables si elles existent déjà (pour pouvoir relancer le script)
-- Ordre inverse de la création : on supprime d'abord les tables qui dépendent des autres
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS menu_produit;
DROP TABLE IF EXISTS fermeture;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS produit;
DROP TABLE IF EXISTS utilisateur;

CREATE TABLE utilisateur (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    nom_utilisateur TEXT    NOT NULL UNIQUE,
    mot_de_passe    TEXT    NOT NULL,
    role            TEXT    NOT NULL DEFAULT 'standard' CHECK (role IN ('admin', 'standard')),
    bloque          INTEGER NOT NULL DEFAULT 0 CHECK (bloque IN (0, 1))
);

CREATE TABLE produit (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    nom         TEXT    NOT NULL,
    description TEXT,
    prix        REAL    NOT NULL CHECK (prix >= 0),
    stock       INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    disponible  INTEGER NOT NULL DEFAULT 1 CHECK (disponible IN (0, 1))
);

CREATE TABLE menu (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    nom         TEXT NOT NULL,
    description TEXT,
    prix        REAL NOT NULL CHECK (prix >= 0),
    date_debut  TEXT DEFAULT NULL,
    date_fin    TEXT DEFAULT NULL,
    CHECK (date_debut IS NULL OR date_fin IS NULL OR date_fin >= date_debut)
);

CREATE TABLE menu_produit (
    menu_id    INTEGER NOT NULL REFERENCES menu(id) ON DELETE CASCADE,
    produit_id INTEGER NOT NULL REFERENCES produit(id) ON DELETE CASCADE,
    PRIMARY KEY (menu_id, produit_id)
);

CREATE TABLE fermeture (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    date_fermeture TEXT NOT NULL UNIQUE,
    motif TEXT
);

CREATE TABLE commande (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    utilisateur_id INTEGER NOT NULL REFERENCES utilisateur(id),
    date_commande  TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_retrait   TEXT    NOT NULL,
    statut         TEXT    NOT NULL DEFAULT 'en_attente'
                   CHECK (statut IN ('en_attente', 'recuperee', 'annulee', 'non_honoree'))
);

CREATE TABLE ligne_commande (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    commande_id INTEGER NOT NULL REFERENCES commande(id) ON DELETE CASCADE,
    produit_id  INTEGER REFERENCES produit(id),
    menu_id     INTEGER REFERENCES menu(id),
    quantite    INTEGER NOT NULL DEFAULT 1 CHECK (quantite > 0),
    -- Une ligne contient soit un produit, soit un menu, jamais les deux ni aucun
    CHECK (
        (produit_id IS NOT NULL AND menu_id IS NULL)
        OR (produit_id IS NULL AND menu_id IS NOT NULL)
    )
);