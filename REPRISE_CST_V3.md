# Reprendre les simulations SmartPot V3 sur un autre ordinateur

Dernière préparation : 27 octobre 2026. Les fichiers KiCad et les anciens CST sont conservés.

## Projet à utiliser : PCB complet

Ouvrir `CST/V3_ODB_carte_complete/SmartPot_V3_PCB_COMPLET.cst`. Garder son dossier compagnon `SmartPot_V3_PCB_COMPLET/` à côté du fichier. Les données Model et les diagnostics sont versionnés ; les caches de maillage et fichiers temporaires peuvent être régénérés par CST.

Le PCB nu est reconstruit depuis l’archive ODB++ : quatre cuivres avec leurs découpes, substrat, 228 perçages métallisés et deux non métallisés. Port 50 Ω à U1.12 vers In1.Cu ; bande 700–1 000 MHz. Lire `LIRE_AVANT_SIMULATION.md` pour l’empilage provisoire, les ponts R4/R6 et les composants/boîtiers non modélisés.

**Aucun S11 du PCB complet n’a été calculé.** CST Learning Edition a refusé le test : 41 143 faces pour 500 autorisées et 127 942 cellules pour 100 000 autorisées. Preuve : `journal_test_CST.log`. Il faut une édition/licence permettant ce modèle pour poursuivre ; la copie sur un autre ordinateur ne retire pas ces limites.

## Si le nouveau CST ne peut pas ouvrir le fichier Learning Edition

Le projet a été enregistré avec CST Learning Edition 2026. Si ton édition refuse ce format, reconstruire un projet natif dans le CST installé, à partir des géométries déjà préparées :

```powershell
cd chemin\vers\SmartPot_RAK3172
powershell -File .\CST\V3_ODB_carte_complete\build_full_cst.ps1
```

La commande utilise l’API COM du CST installé, crée le projet dans `CST/V3_ODB_carte_complete/reconstruction_cst/`, puis tente le solveur. Elle conserve le projet livré et refuse d’écraser un projet de reconstruction existant. Fermer les dialogues CST en attente avant de lancer. La reconstruction complète peut prendre plusieurs minutes.

Le fichier `full_geometry_jobs.json` contient les opérations géométriques préparées : aucun Python ni MATLAB n’est nécessaire pour cette reconstruction. Le script `rebuild_full_odb.py` sert seulement à régénérer ces opérations depuis ODB++ ; il nécessite Python 3 et Shapely 2 (`python -m pip install "shapely>=2,<3"`).

Avec une édition disposant de l’import ODB++, on peut également repartir de `CST/SmartPot_V3_CST_ODB.zip` et du guide `pot_fleur_v3_provisoire_4couches/CST_import/LIRE_AVANT_SIMULATION.md`. Vérifier les matériaux, les composants RF et les deux bornes du port après import.

## Essais précédents à ne pas confondre

- `CST/V3_ODB_modele_reduit/` : masses simplifiées ; deux simulations terminées. Exports S11 texte, CSV et Touchstone inclus. Le S11 à 868 MHz varie d’environ −0,30 à −0,06 dB ; la convergence n’est pas établie. Ces résultats ne valident pas la V3 complète.
- `SmartPot_V3_S11.cst` : projet importé initial fourni, créé avec une édition commerciale. Ce n’est pas le nouveau modèle complet reconstruit.
- `CST/TP1_M2_Smart_2-3.cst` et les captures `S11-868.PNG` : ancienne simulation de l’antenne. Son excitation, sa géométrie et ses matériaux diffèrent de la V3 ; elle reste à comparer proprement avec le PCB complet.

## Récupération

Pour un nouveau dossier : `git clone https://github.com/MaxBarbe/SmartPot_RAK3172.git`.
Pour une copie existante sans modifications locales : `git pull --ff-only` depuis ce dépôt.
Ne pas utiliser les courbes du modèle réduit comme résultat de la carte complète.
