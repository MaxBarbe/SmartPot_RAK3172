# État du projet SmartPot — 12 octobre 2026

| Élément | État vérifiable | Suite |
|---|---|---|
| Dépôt | Présentation SmartPot, ressources personnelles et pédagogiques séparées | Conserver la provenance |
| Schéma | RAK3172, SHT40, BQ25570 ; dernier ERC : 0 erreur, 6 avertissements | Revoir les avertissements et le fonctionnement |
| PCB | Routage quatre couches avec antenne TI ; dernier DRC : 0 violation, 0 connexion manquante | Intégrer l'antenne CST et optimiser les blocs d'alimentation |
| Boîtiers RF | C6/C7/L1 en 0603 | Conserver ce format et revoir les valeurs |
| Antenne | Projet CST final -3 confirmé et captures S11/farfield fournies | Représenter l'alimentation réelle et les quatre couches |
| Mécanique | 3MF du pot et deux captures ; STL dérivé pour visualisation | Vérifier impression, encombrement et influence RF |
| Fabrication | Non validée | Empilage fabricant, revue électrique/RF, prototype |

## Prochaine correction du PCB

La géométrie CST finale est de type IFA : une branche du radiateur est reliée à GND et l'alimentation est distincte. Le PCB actuel utilise une autre antenne TI, un autre plan de masse et un réseau d'adaptation issu de cette référence. Le remplacement ne consiste donc pas à changer uniquement le dessin A1.

La décision de dimension (29,1 × 59,1 mm dans CST contre 30 × 60 mm dans KiCad), la représentation du long port discret par une alimentation fabriquée et l'empilage réel doivent être résolus avec la revue RF. La capture S11 de la version finale ne prouve pas que la carte KiCad actuelle est adaptée à 868 MHz.

Les variantes CST et l'historique Git ont été conservés. Les sauvegardes locales et les réglages d'interface KiCad ne sont pas des livrables de fabrication.

Vérification après réorganisation : [rapport DRC du 12 octobre](DRC_verification_reorganisation.txt), 0 violation, 0 connexion manquante et 0 problème de parité. Ce rapport concerne le PCB existant avec l’antenne TI, dont le fichier n’a pas été modifié pendant la refonte.
