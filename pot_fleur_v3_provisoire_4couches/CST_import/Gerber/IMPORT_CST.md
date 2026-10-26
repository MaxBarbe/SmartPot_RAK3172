# Import Gerber de la V3 dans CST

Export natif RS-274X, mm, précision 4.6, sans attributs X2 ni macros d'ouverture pour compatibilité. PCB source 348791b ; géométrie inchangée. Décompresser le pack avant import.

Importer les Gerber comme surfaces de cuivre remplies (traits, flashes ET régions, en respectant la polarité), pas comme simples lignes. Même origine et même échelle pour tous les fichiers, aucune mise en miroir séparée de B.Cu. Le contour est 30 x 60 mm. Ne pas recentrer chaque couche indépendamment.

Un Gerber n'apporte ni matériau, ni empilage, ni modèle de composant, ni port CST. L'import monocouche doit être répété pour les quatre cuivres ; si l'assistant propose plusieurs couches, utiliser le même ordre.

Convention Z proposée : bas du cuivre inférieur à Z=0, dessus du cuivre supérieur à Z=0,800 mm. Toutes les coordonnées Z ci-dessous sont en mm. Ne pas ajouter deux fois les épaisseurs si l'assistant crée déjà les solides.

| Fichier/couche | Z min | Z max | Matériau |
|---|---:|---:|---|
| pot_fleur-B_Cu.gbr | 0 | 0,035 | cuivre |
| diélectrique inférieur à créer | 0,035 | 0,162 | FR4 provisoire |
| pot_fleur-In2_Cu.gbr | 0,162 | 0,197 | cuivre |
| cœur à créer | 0,197 | 0,603 | FR4 provisoire |
| pot_fleur-In1_Cu.gbr | 0,603 | 0,638 | cuivre |
| diélectrique supérieur à créer | 0,638 | 0,765 | FR4 provisoire |
| pot_fleur-F_Cu.gbr | 0,765 | 0,800 | cuivre |

Les trois diélectriques utilisent provisoirement er=4,3, tan delta=0,02. Créer leurs contours à partir de Edge_Cuts, sans cuivre dans les zones d'exclusion de l'antenne. Le substrat, lui, reste sous l'antenne.

`pot_fleur-Edge_Cuts.gbr` représente le contour, pas une couche métallique. `pot_fleur-F_Mask.gbr` et `pot_fleur-B_Mask.gbr` représentent les OUVERTURES du vernis : ne pas transformer ces dessins en cuivre ou en vernis plein. Vernis provisoire 0,010 mm, er=3,3 ; F.Mask s'étend de 0,800 à 0,810 et B.Mask de -0,010 à 0, mais seulement hors ouvertures. Pertes du vernis à confirmer.

`pot_fleur-PTH.drl` contient les perçages métallisés : recréer les trous et les parois conductrices/vias dans CST si l'import Gerber ne les crée pas. Les vias traversants de la carte sont Ø extérieur 0,60 / perçage 0,30 mm. Les pads Gerber seuls ne relient PAS les couches. Les parois doivent respecter les connexions et dégagements du dessin ; ne pas connecter arbitrairement tous les réseaux aux plans.

`pot_fleur-NPTH.drl` contient les trous non métallisés ; aucun tube conducteur sur ces trous. Les deux trous de fixation sont Ø3 mm.

Pour le port, les deux ponts R4/R6 et la simulation 0,700–1,000 GHz : lire `../LIRE_AVANT_SIMULATION.md`. Avec cette convention Z, le cuivre supérieur est entre 0,765 et 0,800 et la référence In1 entre 0,603 et 0,638. Sélectionner les surfaces réelles pour le port ; ne pas placer les deux bornes sur le même conducteur.

L'import n'a pas été testé dans CST. Ce pack est une géométrie à reconstruire en 3D, pas un projet .cst prêt à lancer. L'empilage est provisoire, non fourni par le fabricant.
