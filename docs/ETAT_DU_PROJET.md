# État du projet SmartPot — 12 octobre 2026

| Élément | État vérifiable | Suite |
|---|---|---|
| Dépôt | Présentation SmartPot, fichiers personnels et références pédagogiques séparés | Conserver la provenance |
| Schéma | RAK3172, SHT40, BQ25570, antenne CST ; ERC : 0 erreur, 6 avertissements | Revoir les avertissements et le fonctionnement |
| PCB | 30 × 60 mm, quatre couches, antenne CST adaptée ; DRC : 0 violation, 0 connexion manquante | Resimuler le raccord RF et optimiser les blocs d’alimentation |
| Boîtiers RF | R6/C6/L1 en 0603 ; R6=0 Ω, C6/L1 non montés au départ | Caractériser et ajuster sur prototype |
| Antenne | Six rectangles CST transposés sur A1 ; branche de masse IFA conservée | Valider l’alimentation physique et les quatre couches dans CST |
| Mécanique | 3MF du pot, STL dérivé et STEP de la carte assemblée | Vérifier impression, encombrement et influence RF |
| Fabrication | Non validée | Empilage fabricant, revue électrique/RF, prototype |

## Remplacement de l’antenne

Le PCB utilise désormais une adaptation de [TP1_M2_Smart_2-3.cst](../CST/TP1_M2_Smart_2-3.cst). Le choix confirmé est de conserver 30 × 60 mm : la largeur de cuivre a été réduite de 29,1 à 29,0 mm pour les marges, et la longue source lumped CST a été remplacée par un raccord physique. La branche de court-circuit vers GND est conservée comme net tie. Voir [la fiche d’intégration](../pot_fleur/docs/INTEGRATION_ANTENNE_CST.md).

Les captures de simulation du projet CST original ne valident pas encore cette adaptation. Les [exports pour resimulation](../CST/integration_kicad/README.md) décrivent le cuivre intégré. La simulation doit inclure l’empilage réel, le raccord physique, les composants 0603 et le pot.

Le [rapport DRC actuel](../pot_fleur/docs/DRC_antenne_CST.txt) indique 0 violation, 0 connexion manquante et 0 problème de parité. Le [rapport de réorganisation](DRC_verification_reorganisation.txt) est historique : il concernait l’ancienne antenne TI avant remplacement. Les variantes CST, l’ancienne empreinte TI et l’historique Git restent disponibles.

La revue du placement de CREF1, CBYP1, CIN2 et LBUCK1 autour du BQ25570 reste nécessaire avant fabrication, indépendamment du remplacement de l’antenne. Les sauvegardes locales et réglages d’interface KiCad ne sont pas des livrables de fabrication.

## Exports mécaniques disponibles

Le [STEP assemblé](../Mecanique/PCB/SmartPot_assemble.step), le [STEP nu](../Mecanique/PCB/SmartPot_carte_nue.step), le GLB et les rendus KiCad sont publiés. Les 35 composants physiques montés sont présents ; l’antenne est représentée par le cuivre du PCB. Le placement et la visualisation du PCB dans le pot restent à réaliser après l’import mécanique. Voir [la fiche 3D](../Mecanique/PCB/README.md).
