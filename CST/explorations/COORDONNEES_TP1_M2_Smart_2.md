# Coordonnees pour TP1_M2_Smart_2.cst

Repere GLOBAL du nouveau projet, en mm. PCB x_PCB=29,1, y_PCB=59,1, z_PCB=0,8 ; bornes X=-14,55..14,55, Y=-29,55..29,55.

IMPORTANT : le projet fourni a Y_ANT=10. Pour conserver la hauteur d'antenne demandee de 16,35 mm, changer Y_ANT a 16.35 puis reconstruire le modele. La masse doit alors se terminer a Y=13,2 mm (29,55-16,35), au lieu de 19,55 mm. Les coordonnees du CSV ne sont valides qu'apres cette modification ; sinon les pistes recouvrent la masse.

La largeur physique du PCB du nouveau projet est 29,1 mm, pas 29,5 mm. Le meandre de largeur 27,8 mm y tient, avec 0,65 mm de marge de chaque cote. Pour obtenir une zone complete de largeur 29,5 mm, modifier aussi x_PCB a 29.5. Le meandre reste centre et les coordonnees X ne changent pas.

Creer les quatre Bricks du CSV en Copper (pure), Z=0..0,035 mm. Les reunir par union booleenne ; les jonctions sont volontairement chevauchantes. Point d'alimentation : (-13,5 ; 13,7 ; 0,035). Port discret de reference 50 ohms entre (-13,5 ; 13,2 ; 0,035), bord de masse, et ce point d'alimentation. Extremite haute a gauche ouverte.

L'original CST n'est pas modifie. Geometrie initiale a simuler, non accordee ni validee a 868 MHz. Le moniteur Farfield a 0,868 GHz est deja present dans ce nouveau projet.
