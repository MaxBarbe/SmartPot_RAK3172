# Géométrie KiCad pour resimulation CST

Ces fichiers correspondent au remplacement de l'antenne TI par l'antenne CST finale, adaptée au PCB 30 × 60 mm. Ils sont fournis pour la **resimulation**, pas comme un dossier de fabrication validé.

- `gerbers/` : F.Cu, In1.Cu, In2.Cu, B.Cu, contour Edge.Cuts et perçages Excellon, exportés du PCB KiCad après remplissage des zones.
- [rectangles_resimulation.csv](rectangles_resimulation.csv) : les six rectangles ajustés, le raccord RF ajouté et le raccord de masse, pour reconstruire la zone d'antenne dans CST. Le repère est centré sur le PCB, X=X_KiCad−65, Y=80−Y_KiCad ; Z=0..0,035 mm pour le cuivre supérieur.
- [Fiche d'intégration et contrôles](../../pot_fleur/docs/INTEGRATION_ANTENNE_CST.md).

Pour importer les Gerber dans CST, affecter les couches et reconstruire le substrat et les vias avec l'empilage réel du fabricant. Le fichier KiCad ne fixe pas encore cet empilage. Le CSV ne contient ni les pistes hors empreinte d'antenne, ni les plans de masse, ni les composants : utiliser les Gerber pour une analyse du cuivre complet.

Les rectangles pad=1 constituent le radiateur et sa ligne d'alimentation ; pad=2 est son ancrage de masse. Leur liaison de court-circuit est intentionnelle dans une IFA. Le radiateur et l'alimentation sont le même conducteur connecté à une branche de masse ; ne pas supprimer cette branche pour obtenir un monopole.

Vérifier les matériaux, les pertes, le masque, l'alimentation et les composants R6/C6/L1 en 0603. Ajouter un port à l'entrée du raccord RF physique et un moniteur Farfield à 0,868 GHz, puis examiner S11, efficacité et convergence de maillage. La géométrie complète avec ce raccord physique n'a pas été simulée ici.
