# État du projet SmartPot — 28 octobre 2026

| Élément | État actuel | Suite nécessaire |
|---|---|---|
| KiCad | [V4 routée](../pot_fleur_v4_nouvelle_antenne/README.md), quatre couches, DRC 0 violation / 0 connexion manquante / 0 défaut de parité | Revue électrique et empilage fabricant |
| RF à la sortie U1.12 | Largeur 0,229278 mm et empilage provisoire | Vérifier la ligne réelle à 50 Ω et ses transitions |
| Simulation V4 | [M2](../CST/V4_U112_868/README.md) : −8,96572 dB à 868 MHz, minimum −9,02577 dB à 868,9 MHz | Convergence M1/M2 non démontrée ; M3 sans résultat publié |
| Rayonnement V4 M2 | Rendement rayonnement 43,69 %, total 38,14 %, gain réalisé max −2,400 dBi | Valeurs provisoires à confirmer par raffinement |
| Adaptation V5 | [Variante CST](../CST/V5_ADAPTATION_868/README.md) : R6 remplacée par 4,3 nH idéale, C6=3,9 pF idéale | Aucun résultat publié ; ne pas modifier l’assemblage KiCad sur cette seule proposition |
| Mécanique | [Pot et intégration](../Mecanique/README.md), [STEP V4](../pot_fleur_v4_nouvelle_antenne/3D/SmartPot_V4_RF_provisoire.step) | Vérifier le montage et l’influence du pot sur la RF |
| Versions antérieures | [old/](../old/README.md), sans suppression des sources et résultats | Historique uniquement |
| Fabrication | **Non validée** | Confirmer empilage, convergence, avis enseignants, puis mesures sur prototype |

Le résultat X0 à −11,02 dB concerne un autre modèle à port lumped et cuivre PEC. Il ne remplace pas la simulation V4 avec raccord physique et excitation côté radio. Un arrêt temporel sur le critère d’énergie ne démontre pas la convergence spatiale.

Les données ont été synchronisées depuis le commit 8875b36 ; le calcul V5 est décrit comme lancé dans cette publication, sans résultat joint. Aucun calcul CST n’a été exécuté sur ce Mac lors de la mise à jour documentaire.
