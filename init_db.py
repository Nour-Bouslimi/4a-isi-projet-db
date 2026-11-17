import sqlite3
from pathlib import Path

DOSSIER = Path(__file__).parent
FICHIER_BD = DOSSIER / "pol_eat_heck.db"

connexion = sqlite3.connect(FICHIER_BD)

# 1. Création des tables, puis 2. insertion des données de test
connexion.executescript((DOSSIER / "schema.sql").read_text(encoding="utf-8"))
connexion.executescript((DOSSIER / "seed.sql").read_text(encoding="utf-8"))
connexion.commit()

# 3. Vérification : nombre de lignes dans chaque table
tables = ["utilisateur", "produit", "menu", "menu_produit",
          "fermeture", "commande", "ligne_commande"]
for table in tables:
    nombre = connexion.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
    print(f"{table} : {nombre} ligne(s)")

connexion.close()
print(f"Base créée : {FICHIER_BD.name}")