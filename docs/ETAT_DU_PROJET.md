# État du projet SmartPot — 26 octobre 2026

## V3 provisoire après retour de Dorian

La [copie V3 quatre couches](../pot_fleur_v3_provisoire_4couches/README.md), créée le 25 octobre, applique les corrections du mail du 22 octobre : ajout du GND In2, 130 vias GND, perçages de vias à 0,3 mm minimum, simplification de 18 trajets, réseau RF réorganisé et vernis retiré du radiateur. DRC **0 violation / 0 connexion manquante / 0 problème de parité**, ERC **0 erreur / 6 avertissements**. La largeur de 0,229278 mm vient du calculateur KiCad sur un empilage explicitement provisoire. Des précisions ont été demandées à Dorian ; cette copie attend sa revue et la validation fabricant/RF.

Les états des versions précédentes ci-dessous sont conservés comme historique ; ils ne décrivent pas la V3.


Mise à jour : deux perçages Ø 3 mm ajoutés aux positions demandées. Le DRC actuel compte 1 erreur de chevauchement des zones d’occupation H1/J10, 0 connexion manquante et 0 problème de parité. Les chiffres DRC du 12 octobre ci-dessous sont historiques. Voir [les perçages](../pot_fleur/docs/TROUS_FIXATION.md).

| Élément | État vérifiable | Suite |
|---|---|---|
| Dépôt | Présentation SmartPot, fichiers personnels et références pédagogiques séparés | Conserver la provenance |
| Schéma | RAK3172, SHT40, BQ25570, antenne CST ; ERC : 0 erreur, 6 avertissements | Revoir les avertissements et le fonctionnement |
| PCB | 30 × 60 mm, quatre couches, antenne CST adaptée ; DRC : 0 violation, 0 connexion manquante | Resimuler le raccord RF et optimiser les blocs d’alimentation |
| Boîtiers RF | R6/C6/L1 en 0603 ; R6=0 Ω, C6/L1 non montés au départ | Caractériser et ajuster sur prototype |
| Antenne | Six rectangles CST transposés sur A1 ; branche de masse IFA conservée | Valider l’alimentation physique et les quatre couches dans CST |
| Mécanique | 3MF du pot, STL dérivé et STEP de la carte assemblée | Vérifier impression, encombrement et influence RF |
| Fabrication | Non validée | Empilage fabricant, revue électrique/RF, prototype |

## V2 à deux couches

La [V2 séparée](../pot_fleur_v2_2couches/README.md) conserve tous les composants, connecteurs latéraux et perçages. Le capteur U4 est déplacé au-dessus du module radio. Le routage et les zones de masse n’utilisent que F.Cu/B.Cu : **0 connexion manquante, 0 problème de parité, 0 violation DRC**, ERC **0 erreur / 6 avertissements**. Les pistes minimales de 0,15 mm, les vias compacts de 0,40/0,20 mm et les vias dans certaines pastilles CMS doivent être confirmés avec le fabricant. La RF et les boucles d’alimentation restent à valider ; les simulations CST publiées ne valident pas l’empilage deux couches. J10 conserve ses deux pastilles pour soudure directe des fils ; le boîtier du bornier est retiré, ce qui résout le chevauchement H1/J10 dans cette V2. Le STEP V2, la vue 3D et les masques/Gerbers sont disponibles dans son dossier.

## Remplacement de l’antenne

Le PCB utilise désormais une adaptation de [TP1_M2_Smart_2-3.cst](../CST/TP1_M2_Smart_2-3.cst). Le choix confirmé est de conserver 30 × 60 mm : la largeur de cuivre a été réduite de 29,1 à 29,0 mm pour les marges, et la longue source lumped CST a été remplacée par un raccord physique. La branche de court-circuit vers GND est conservée comme net tie. Voir [la fiche d’intégration](../pot_fleur/docs/INTEGRATION_ANTENNE_CST.md).

Les captures de simulation du projet CST original ne valident pas encore cette adaptation. Les [exports pour resimulation](../CST/integration_kicad/README.md) décrivent le cuivre intégré. La simulation doit inclure l’empilage réel, le raccord physique, les composants 0603 et le pot.

Le [rapport DRC du 12 octobre](../pot_fleur/docs/DRC_antenne_CST.txt) indiquait 0 violation avant les perçages ; le contrôle actuel comporte le conflit H1/J10 décrit en tête de cette page. Le [rapport de réorganisation](DRC_verification_reorganisation.txt) est historique : il concernait l’ancienne antenne TI avant remplacement. Les variantes CST, l’ancienne empreinte TI et l’historique Git restent disponibles.

La revue du placement de CREF1, CBYP1, CIN2 et LBUCK1 autour du BQ25570 reste nécessaire avant fabrication, indépendamment du remplacement de l’antenne. Les sauvegardes locales et réglages d’interface KiCad ne sont pas des livrables de fabrication.

## Exports mécaniques disponibles

Le [STEP assemblé](../Mecanique/PCB/SmartPot_assemble.step), le [STEP nu](../Mecanique/PCB/SmartPot_carte_nue.step), le GLB et les rendus KiCad sont publiés. Les 35 composants physiques montés sont présents ; l’antenne est représentée par le cuivre du PCB. Le placement a été corrigé par Maxime dans Shapr3D ; la capture publiée montre cet assemblage corrigé. Le STEP V2 reste à importer dans ce projet mécanique pour remplacer la carte précédente. Voir [la fiche 3D](../Mecanique/PCB/README.md).

## Redressement des pistes du 26 octobre

La V3 a été reprise sur 27 trajets principaux pour éliminer les petits zigzags ; 63 fragments internes aux pastilles ont aussi été retirés. Total de segments : 674 → 447. Les composants, les largeurs RF, les vias et le schéma sont conservés. DRC final : 0 violation / 0 connexion manquante / 0 problème de parité. [Avant/après](../pot_fleur_v3_provisoire_4couches/docs/Comparaison_pistes_droites.png).
