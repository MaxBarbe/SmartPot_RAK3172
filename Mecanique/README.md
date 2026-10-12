# Pot SmartPot — conception mécanique

Modèle fourni par Maxime, conçu dans Shapr3D. Les fichiers sont conservés dans `Pot_fleur/`.

- [Pot_fleur.3mf](Pot_fleur/Pot_fleur.3mf) : export original fourni, unité millimètre, un objet maillé.
- [Pot_fleur.stl](Pot_fleur/Pot_fleur.stl) : export dérivé pour afficher le maillage, notamment sur GitHub. Il reprend les 657 sommets et 1310 triangles du 3MF, sans changement d'échelle.
- [Vue intérieure](Pot_fleur/pot-fleur-vue.png).
- [Vue latérale](Pot_fleur/pot-fleur-vue2.png).

![Vue intérieure du pot](Pot_fleur/pot-fleur-vue.png)

![Vue latérale du pot](Pot_fleur/pot-fleur-vue2.png)

Le fichier natif `.shapr` n'est pas fourni ; les formats 3MF et STL sont des maillages, pas l'historique de conception paramétrique. La géométrie est publiée comme conception mécanique du pot. L'impression, l'étanchéité, le logement de la carte et les effets du matériau sur l'antenne restent à vérifier avant fabrication.

## PCB à importer dans le pot

Le [STEP de la carte assemblée](PCB/SmartPot_assemble.step), la [carte nue](PCB/SmartPot_carte_nue.step) et les [vues 3D KiCad](PCB/README.md) sont disponibles. Importer le STEP assemblé dans le projet du pot pour vérifier les dégagements avant de préparer la visualisation de l’ensemble.
