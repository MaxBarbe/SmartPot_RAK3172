# Antenne SmartPot — CST, bande 868 MHz

**Version finale confirmée par Maxime : [TP1_M2_Smart_2-3.cst](TP1_M2_Smart_2-3.cst).** Les versions [-1](TP1_M2_Smart_2-1.cst) et [-2](TP1_M2_Smart_2-2.cst) restent disponibles comme variantes antérieures. Les projets source ont été conservés sans modification.

## Modèle et configuration lus dans le projet final

| Paramètre | Valeur |
|---|---:|
| x_PCB | 29,1 mm |
| y_PCB | 59,1 mm |
| z_PCB | 0,8 mm |
| Y_ANT | 10 mm |
| MET_TH | 0,035 mm |
| Substrat | Epoxy resin, εr=4, pertes diélectriques nulles |
| Cuivre | Copper (pure) |
| Plage finale | 0,75–1 GHz |
| Solveur | HF Time Domain |
| Port | Discrete Port, S-Parameter, 50 Ω |

Le dernier port actif de l'historique est défini par P1=(-13 ; 28,55 ; 0,035) mm et P2=(-13 ; 19 ; 0) mm, dans le repère global, direction inversée. Ce port de simulation s'étend sur plusieurs millimètres : il ne représente pas à lui seul une piste d'alimentation fabriquée. Son équivalent physique doit être défini et vérifié lors du transfert vers KiCad.

La géométrie est une antenne imprimée repliée avec une branche de court-circuit reliée au plan de masse et un point d'alimentation distinct, de type F inversé (IFA). Dans cette topologie, la liaison de la branche de court-circuit à GND est intentionnelle ; l'analyse précédente fondée sur un monopole isolé ne s'applique pas directement. Les six rectangles ANT1..ANT6 sont décrits dans [la fiche de géométrie](geometrie_finale.json). L'historique comporte aussi un import SAT intermédiaire ; les rectangles exportés ne remplacent pas une inspection du modèle final dans CST.

## Captures fournies

![Géométrie de l'antenne](ant-868.PNG)

![Carte simulée](carte-868.PNG)

![S11](S11-868.PNG)

| Lecture de la capture S11 | Valeur |
|---|---:|
| Minimum affiché | 0,869 GHz / −17,892 dB |
| Marqueur gauche | 0,8667 GHz / −9,9109 dB |
| Marqueur droit | 0,87126 GHz / −9,7531 dB |

Les marqueurs voisins sont proches de −10 dB, mais ne sont pas les intersections exactes de ce seuil. La largeur de bande à −10 dB et S11 exactement à 868 MHz doivent être extraits de la courbe numérique ; ils ne sont pas inventés à partir de cette image.

![Champ lointain à 868 MHz](farfield-868.PNG)

La capture est en **directivité**, pas en gain réalisé. À 0,868 GHz elle affiche :

- directivité maximale : **1,805 dBi** ;
- rendement de rayonnement : **−0,5623 dB**, soit **environ 87,9 %** ;
- rendement total : **−0,7056 dB**, soit **environ 85,0 %**.

Ces chiffres proviennent des captures fournies avec la version finale ; la simulation n'a pas été relancée ici. Les fichiers de résultats numériques et le journal de convergence ne sont pas fournis. Le modèle ne reproduit pas encore le PCB KiCad à quatre couches, le boîtier du pot et les composants RF 0603. Les performances annoncées sont donc celles du modèle simulé, pas des mesures sur une carte fabriquée.

## Avant intégration au PCB

1. Reproduire la branche de court-circuit, le radiateur et un raccordement RF physique compatible avec le port étudié.
2. Réconcilier les dimensions CST (29,1 × 59,1 mm) et KiCad (30 × 60 mm), ainsi que la zone de masse et l'empilage réel.
3. Vérifier dans CST l'effet de l'alimentation réelle, des couches internes et du pot, puis ajuster l'adaptation en 0603.
4. Vérifier ERC/DRC après intégration et mesurer l'adaptation sur prototype.

`explorations/` contient les anciennes propositions de macros et de coordonnées. Elles sont historiques et ne constituent pas l'antenne finale choisie.
