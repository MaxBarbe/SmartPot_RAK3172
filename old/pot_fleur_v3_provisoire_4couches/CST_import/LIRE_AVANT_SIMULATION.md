# SmartPot V3 — import CST, carte routée du 26 octobre 2026

Source géométrique : commit 348791b. Export natif KiCad, PCB source non modifié.

## Fichier à importer

Importer `SmartPot_V3_CST_IPC2581.xml` via l'import ECAD / IPC-2581 de CST si disponible. Le fichier contient le cuivre des quatre couches, les plans remplis, les pads, les informations de perçage, les réseaux, le contour et l'empilage avec matériaux.

Alternative : `SmartPot_V3_CST_ODB.zip` via l'import ODB++. L'archive contient les quatre couches, les surfaces de cuivre, les perçages métallisés et non métallisés, le profil et les réseaux. Vérifier et renseigner les épaisseurs/matériaux à l'import ODB++ : ne pas supposer qu'ils ont été automatiquement repris.

Ne pas importer simultanément les deux fichiers. Ne pas superposer l'ancien radiateur CST à celui importé. Choisir un projet HF 3D pour antenne rayonnante ; un simple calcul de réseau PCB ne fournit pas le rayonnement.

## Empilage provisoire à vérifier après import

Du dessus vers le dessous, épaisseurs en mm :

| Couche | Épaisseur | Matériau |
|---|---:|---|
| F.Cu | 0,035 | cuivre |
| DIELECTRIC_1 | 0,127 | FR4 provisoire, er=4,3, tan delta=0,02 |
| In1.Cu | 0,035 | cuivre |
| DIELECTRIC_2 | 0,406 | FR4 provisoire, er=4,3, tan delta=0,02 |
| In2.Cu | 0,035 | cuivre |
| DIELECTRIC_3 | 0,127 | FR4 provisoire, er=4,3, tan delta=0,02 |
| B.Cu | 0,035 | cuivre |

Total cuivre + diélectrique : 0,800 mm. L'IPC-2581 indique 0,820 mm avec les deux couches de vernis de 0,010 mm. Vernis er=3,3 exporté ; pertes à confirmer. Les ouvertures F.Mask sont des ouvertures, pas du métal ni des couches de vernis pleines. Le radiateur est sans vernis. Vérifier l'interprétation du masque par l'importeur. Conserver tous les dégagements sous l'antenne, le court-circuit IFA A1/GND, les vias et les deux trous de fixation.

## Excitation et composants — indispensables avant calcul

Les fichiers ECAD ne sont PAS un projet CST prêt à lancer. Aucun port, solveur, frontière ou modèle électrique de composant n'est créé par l'export KiCad. Les corps et connexions internes du module RAK3172 ne sont pas modélisés électromagnétiquement par cet export.

Pour un premier calcul du réseau antenne/PCB :

- U1 : ne pas charger la sortie RF par un modèle du circuit actif. Exciter la ligne à la pastille U1.12 (RF_FEED) avec un port discret 50 ohms vers la masse de référence In1.Cu directement sous ce point. Vérifier dans la vue 3D les deux extrémités physiques du port après import ; ne pas placer le port entre deux points du même conducteur.
- R4 et R6 : remplacer les résistances montées 0 ohm par deux ponts conducteurs entre leurs pastilles, ou des modèles électriques appropriés. Le cuivre KiCad seul laisse un espace entre les deux pads de chaque résistance. L'approximation par pont ne représente pas les parasites du boîtier 0603.
- C6, L1, J3 : non montés. Conserver les pads mais ne pas ajouter de composant/liaison à travers les espaces des pads. Le court-circuit IFA prévu dans A1 doit rester intact.
- Autres composants : les pads sont présents, mais leurs propriétés électriques/corps réels ne sont pas automatiquement modélisés. Cette première simulation de cuivre nu avec ponts RF ne constitue donc pas le modèle complet de la carte assemblée.

Repérage XY (mm), origine conservée, coordonnées natives dans l'IPC-2581 :

| Point | X | Y |
|---|---:|---:|
| U1.12, signal du port | 57,925 | -71,965 |
| R4.1 | 54,675 | -69,800 |
| R4.2 | 56,325 | -69,800 |
| R6.1 | 54,825 | -63,300 |
| R6.2 | 53,175 | -63,300 |

Les coordonnées KiCad ont Y positif vers le bas ; celles de l'IPC ont Y inversé. CST peut translater/retourner le modèle à l'import. Les références de pads priment alors sur ces coordonnées. Z dépend du positionnement de l'empilage par l'importeur : sélectionner les surfaces F.Cu et In1.Cu dans CST, ne pas supposer Z=0.

## Réglages du premier calcul

- Unités : mm, GHz.
- Bande : 0,700 à 1,000 GHz.
- Port 1 : discret, référence 50 ohms.
- Fond : air ; frontières ouvertes avec espace ajouté autour du PCB sur les six faces.
- Solveur HF 3D adapté aux antennes (transitoire ou fréquentiel selon licence/modèle).
- Moniteurs à 0,868 GHz : farfield et courants de surface.
- Maillage local au départ RF, sur les pistes de largeur 0,229278 mm, autour des ponts 0603 et des espaces de l'antenne. Contrôler la convergence en affinant le maillage : une courbe unique non convergée n'est pas une validation.

Lire S11 à 0,868 GHz et sa bande sous -10 dB, le gain réalisé, le rendement et les courants. Ajouter ensuite boîtier/pot, câbles et environnement proche avec leurs vrais matériaux. L'empilage et les pertes sont des hypothèses à remplacer par les données du fabricant.

## Vérifications de l'export

Archive ODB++ : intégrité ZIP vérifiée ; quatre couches de cuivre non vides ; perçages traversants et non métallisés présents. XML IPC-2581 : bien formé ; quatre couches de cuivre et sept couches de l'empilage cuivre/FR4 présentes. DRC source : 0 violation / 0 connexion manquante / 0 défaut de parité.

L'import et la simulation n'ont pas été exécutés dans CST. Aucun résultat S11 ou fréquence de résonance n'est affirmé par ce dossier.
