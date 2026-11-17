# 4a-isi-projet-db

Base de données SQLite du projet Pol-eat-heck.


## Autres dépôts
- Back : https://github.com/Nour-Bouslimi/4a-isi-projet-back
- Front : https://github.com/Nour-Bouslimi/4a-isi-projet-front

## Conception de la base de données

```mermaid
erDiagram
    utilisateur ||--o{ commande : "passe"
    commande ||--|{ ligne_commande : "contient"
    produit |o--o{ ligne_commande : "commandé dans"
    menu |o--o{ ligne_commande : "commandé dans"
    menu ||--o{ menu_produit : "compose"
    produit ||--o{ menu_produit : "fait partie de"

    utilisateur {
        int id PK
        string nom_utilisateur "unique"
        string mot_de_passe "haché"
        string role "admin ou standard"
        bool bloque
    }
    produit {
        int id PK
        string nom
        string description
        float prix
        int stock
        bool disponible
    }
    menu {
        int id PK
        string nom
        string description
        float prix
        date date_debut
        date date_fin
    }
    menu_produit {
        int menu_id FK
        int produit_id FK
    }
    fermeture {
        int id PK
        date date "unique"
        string motif
    }
    commande {
        int id PK
        int utilisateur_id FK
        datetime date_commande
        date date_retrait
        string statut
    }
    ligne_commande {
        int id PK
        int commande_id FK
        int produit_id FK "vide si menu"
        int menu_id FK "vide si produit"
        int quantite
    }
```

### Légende du diagramme

Chaque extrémité d'un trait indique **combien** d'éléments sont liés :

- `||` → exactement **1**
- `|o` → **0 ou 1**
- `o{` → **0 ou plusieurs**
- `|{` → **1 ou plusieurs**

Abréviations dans les tables :

- **PK** (clé primaire) → identifie chaque ligne de manière unique
- **FK** (clé étrangère) → fait référence à une ligne d'une autre table

Exemple de lecture : `utilisateur ||--o{ commande`
→ une commande appartient à **1** utilisateur, et un utilisateur peut avoir **0 ou plusieurs** commandes.