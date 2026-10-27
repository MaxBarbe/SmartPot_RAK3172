# Piste raccordee en haut, port lumped dans le gap du bas

Projet : `SmartPot_V3_ANTENNE_PISTE_HAUT_3QUARTS_LUMP_2019.cst`.

La fine piste verticale d'origine au milieu (largeur 0,2 mm, autour de X = 52,044673 mm) est retiree entre le haut de l'antenne et sa pastille inferieure. La branche de court-circuit de l'IFA a gauche reste conservee.

Le rectangle ajoute auparavant en bas est supprime. Il est remplace par une piste de cuivre de 1 mm de large et 7 mm de long, d'epaisseur 35 micrometres, entre X = 52,45 et 53,45 mm, Y = -58,4 et -51,4 mm, Z = 0,765 et 0,8 mm. Cette piste est raccordee au cuivre du haut de l'antenne avec un recouvrement de 0,1 mm2. Elle n'est pas directement raccordee en bas au plan de masse.

Un unique port discret/lumped de 50 ohms est place verticalement dans l'espace restant en bas, entre (52,95 ; -58,3 ; 0,8) et (52,95 ; -60,75 ; 0,8) mm. La longueur geometrique entre ses points est de 2,45 mm ; la partie sans cuivre entre le bas de la piste et la masse mesure environ 2,1 mm. Aucun cuivre existant ne traverse ce gap au droit du port.

Le port excite l'antenne vers la masse de la carte. L'ancienne chaine RF et ses pistes restent geometriquement presentes, mais la suppression de la fine piste centrale les decouple du nouveau point d'alimentation d'antenne. R4 et R6 restent modelises par des conducteurs idealises de 0 ohm.

Les quatre couches et les vias sont conserves. Le fichier KiCad d'origine n'est pas modifie : il s'agit d'une proposition de geometrie CST a reporter sur la carte si elle est retenue.

Objectif : S11 <= -14 dB a 868 MHz. Aucun ancien resultat (-12 dB ou -5,88 dB) ne constitue le S11 de cette nouvelle geometrie. Le FR4 reste provisoire et le solveur frequentiel hexaedrique CST 2019 traite le cuivre comme PEC. Une validation a une seule frequence ne donne pas la frequence du minimum de resonance ni la bande passante.
