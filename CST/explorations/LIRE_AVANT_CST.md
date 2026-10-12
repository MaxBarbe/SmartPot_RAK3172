# Antenne zigzag en haut du PCB pour CST

Le fichier original fourni est conserve dans TP1_M2_Smart_original.cst. Il n'est pas modifie. La macro ANTENNE_ZIGZAG_HAUT.mcs doit etre executee une seule fois sur une COPIE ouverte dans CST, puis enregistree sous un nouveau nom, par exemple TP1_M2_Smart_zigzag.cst. Ne pas l'executer sur un projet KiCad importe : elle remplace les objets PCB, GND, ANT1 a ANT5 et le port 1 du projet de TP.

## Utilisation
1. Ouvrir l'original dans CST, puis Enregistrer sous un nouveau nom.
2. Ouvrir l'editeur de macros VBA de CST (menu Macros ; intitule selon la version). Charger le fichier .mcs, ou copier son contenu dans une nouvelle macro de structure.
3. Executer Sub Main. Verifier visuellement PCB, GND, ANT_ZZ et le port 1. Les commandes sont ajoutees a l'historique pour conserver le modele.
4. Le haut du PCB correspond a Y positif : PCB X=-15..15, Y=-30..30 mm. Masse Y=-30..13,65 mm ; zone antenne X=-14,75..14,75 et Y=13,65..30 mm, soit 29,5 x 16,35 mm. Le meandre comporte deux passages horizontaux dans le sens des 29,5 mm et un retour vertical. Le dernier bout reste ouvert ; aucun court-circuit vers la masse.
5. Ajouter un moniteur Farfield a 0,868 GHz, lancer le solveur et verifier S11, impedance, rendement et convergence de maillage. La plage initiale est 0,5..1,2 GHz pour chercher la resonance, puis peut etre resserree.

## Parametres
Les nouveaux parametres portent le prefixe zz_ pour eviter de confondre les anciens parametres du TP avec ceux du nouveau modele. zz_board_x=30, zz_board_y=60, zz_board_h=0,8 mm ; zz_ground_top=13,65 ; zz_gap=0,5 ; zz_width=0,8 ; zz_halfspan=13,5 ; zz_first_y=17 ; zz_pitch=7 mm. La longueur de chemin sur l'axe du cuivre est initialement environ 63,85 mm. Cette longueur est une hypothese de depart, pas un calcul garantissant la resonance a 868 MHz.

## Limites
La macro n'a pas pu etre executee dans CST ici. Les appels Brick, DiscretePort, Solver et WCS sont repris du fichier de TP ; l'union Solid.Add est documentee dans l'API CST utilisee par HERMES/CNRS : https://src.koda.cnrs.fr/hermes/cst-python-api/-/merge_requests/9/commits . Verifier l'execution et la geometrie dans CST avant toute simulation.

Ce modele remplace l'antenne du TP par un monopole en meandre SUR UNE FACE. Il ne reproduit pas l'antenne helicoidale deux faces TI du KiCad, ni les quatre couches de la carte finale. Le substrat Epoxy resin du TP est conserve avec epsilon_r=4 et pertes nulles ; il faut les remplacer par les donnees reelles. Les plans internes, les composants, les adaptations 0603 et le boitier ne sont pas representes. Le port de reference 50 ohms ne garantit pas une antenne adaptee a 50 ohms. Ne pas transferer cette geometrie au PCB de fabrication sans validation EM puis prototype.
