# Antenne PCB 868 MHz - base de conception

Source : TI DN038 / SWRA416 et Gerber SWRR082, copies conservees dans ce dossier.
https://www.ti.com/lit/an/swra416/swra416.pdf
https://www.ti.com/lit/zip/swrr082

## Integration
- A1 conserve son identifiant et recoit l'empreinte locale SmartPot_RF:TI_DN038_868MHz_Helical.
- Traces reproduites a partir des Gerber TI : 11 segments dessus, 27 dessous, 19 vias perces a 0,381 mm. Radiateur environ 19 x 12 mm ; courtyard du radiateur 19,5 x 12,5 mm.
- Les pistes de l'antenne sont des pads de cuivre de numero 1, sans pate ni ouverture de masque sauf au point d'alimentation. Tous les vias du radiateur portent aussi le numero 1.
- La broche 2 du symbole est une reference de masse pour le port, pas un court-circuit du radiateur.
- Ancien R5 -> C6, non monte, adaptation shunt optionnelle.
- Ancien R6 -> C7, 1 pF serie, C0G/NP0 RF a faible tolerance.
- Ancien R7 -> L1, 12 nH shunt cote antenne, inductance RF a Q eleve et frequence d'auto-resonance superieure a 868 MHz.
- Le label local RF_FEED relie effectivement l'entree du reseau au pad RF 12 du RAK3172.
- R4 et J3 sont non montes pour la variante antenne PCB. J3 recoit une empreinte U.FL Hirose pour une variante de test ; ne pas monter les deux branches simultanement sans reselection/adaptation RF.

## Carte proposee
- Contour 30 x 60 mm, coordonnees (50,50) a (80,110) mm.
- Region antenne : y=50 a 70 mm ; electronique : y=70 a 110 mm.
- Quatre couches cuivre configurees. Les deux couches internes ne participent pas au radiateur.
- Zone d'exclusion des plans de cuivre sur les quatre couches dans la region rayonnante. Ne pas y ajouter de pistes, composants, vis ou metal ; seuls les conducteurs de l'antenne sont admis.
- Epaisseur 0,8 mm provisoire, correspondant a la reference TI. Stackup de fabrication et boitier non fournis : ne pas lancer la fabrication sur cette hypothese.
- PCB contenant les 48 composants du schema, y compris les 11 empreintes non montees. Aucun composant manquant. Placement preliminaire de toute l electronique dans la zone 30 x 40 mm.
- Routage preliminaire present sur les quatre couches. Module tourne pour rapprocher la broche RF 12 de C7 ; liaison RF tracee manuellement en F.Cu, largeur provisoire 0,20 mm. La largeur de ligne 50 ohms depend du stackup, de la distance au plan de masse et du cuivre.

## Verification et limites
- ERC global apres integration : 0 erreur, 6 avertissements.
- DRC apres routage et remplissage des zones : 0 violation, 0 liaison non routee, 0 probleme de parite schema/PCB. References, valeurs, empreintes, champs et nets synchronises.
- La geometrie du radiateur est reprise de TI ; son adaptation 1 pF / 12 nH correspond au support TI, pas a une mesure de cette carte.
- Le plan de masse 30 x 40 mm, les quatre couches, le stackup et le boitier changent l'impedance. Ajuster C7/L1 sur un prototype avec un VNA ; viser S11 <= -10 dB dans les canaux 868 MHz utilises, puis verifier la portee et l'efficacite.
- Le keepout permet les pads du radiateur et le placement de son empreinte. Verifier visuellement qu'aucun autre pad ni composant ne soit ajoute dans la region rayonnante.

Sauvegarde avant modification : ../../sauvegardes/pot_fleur_avant_antenne_868MHz/

## Etat du routage au 7 octobre 2026
- Les 48 empreintes sont presentes ; 11 sont non montees, dont C22.
- Broches accessibles sur les cotes : J1/J4/J5/J19 a gauche ; J2/J7/J6 a droite. J10 reste dans la partie inferieure.
- Routage general calcule puis repris localement pour fermer les connexions de U3 et du capteur. Pistes de largeur au moins 0,20 mm ; vias de signal 0,60 mm / percage 0,30 mm. Les vias du radiateur conservent la geometrie TI.
- Plans GND remplis sur F.Cu, In1.Cu et B.Cu, avec exclusion sous le radiateur sur les quatre couches. In1.Cu comporte egalement des pistes : ce n'est pas encore un plan de reference continu reserve a la masse.
- La liaison RF et le branchement a C6/R4 sont courts. R4 est DNP et isole la prise U.FL J3 ; ne pas monter R4 dans la variante antenne PCB sans revoir l'adaptation.
- Verification KiCad avec parite schema/PCB : voir DRC_routage_4couches.txt et ERC_routage_4couches.txt. Apercu : APERCU_routage_4couches.pdf.
- Les contraintes du projet n'ont pas ete abaissees pour faire passer le DRC. Les sorties de pads et les vias conflictuels ont ete corriges.

### Revue avant fabrication
Ce routage est une version preliminaire, pas une validation electrique ou RF. Le fabricant et son empilage quatre couches ne sont pas encore connus. L'epaisseur 0,8 mm et la largeur RF 0,20 mm sont des hypotheses, pas une impedance 50 ohms certifiee. Recalculer la ligne RF pour l'empilage reel et valider l'antenne au VNA sur prototype.

Le placement du BQ25570 reste a optimiser par blocs fonctionnels : notamment CREF1, CBYP1, CIN2 et LBUCK1 sont eloignes de U3. Rapprocher le decouplage et reduire les boucles de commutation avant fabrication. Un DRC sans erreur ne controle ni ces boucles, ni le bruit du signal VREF_SAMP, ni la performance de l'antenne. Les avertissements ERC restants (dont EN et VBAT_OK) restent a revoir avec le professeur.

Les sauvegardes demandées restent locales dans ../../sauvegardes/ et sont exclues du push ; les sources KiCad et les bibliotheques necessaires sont versionnees.

## Correction des boitiers RF : 0603 obligatoire
C6, C7 et L1 utilisent tous des empreintes 0603 (1608 metrique), conformement a la demande. Les emplacements 0402 ont ete remplaces dans le schema et sur le PCB. C6 reste non monte, C7 reste a 1 pF et L1 a 12 nH ; ces valeurs d'adaptation restent provisoires. R4 conserve son empreinte 0603 et reste non monte.

Le placement et le routage RF ont ete repris pour les empreintes plus grandes ; controle final : 0 violation DRC, 0 connexion manquante, 0 probleme de parite schema/PCB. Le changement de boitier modifie les parasites RF : valider l'adaptation avec des composants RF 0603 appropries sur le prototype, avec l'empilage reel du fabricant.
