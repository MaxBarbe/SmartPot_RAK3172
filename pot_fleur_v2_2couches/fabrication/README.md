# Exports SmartPot V2 — 14 octobre 2026

[J10 est prévu pour fils soudés directement](../README.md), sans bornier.

- [Archive ZIP des Gerbers et perçages](SmartPot_V2_Gerbers.zip).
- [Fichiers séparés](Gerbers/).
- [Ouvertures de vernis dessus](../docs/Masque_V2_dessus.svg) / [dessous](../docs/Masque_V2_dessous.svg).
- [Vue 3D](../docs/PCB_V2_3D.png) / [STEP assemblé](../3D/SmartPot_V2_assemble.step).

Les fichiers .gtl/.gbl sont le cuivre F.Cu/B.Cu ; .gts/.gbs sont les ouvertures du vernis ; .gtp/.gbp sont les ouvertures du pochoir de pâte ; .gto/.gbo sont la sérigraphie ; .gm1 est le contour ; les .drl séparent trous métallisés PTH et non métallisés NPTH. Les vues de dessous sont exportées dans le repère du PCB, sans miroir supplémentaire.

Les contrôles KiCad de cette version indiquent 0 violation DRC, 0 connexion manquante et 0 problème de parité ; ERC 0 erreur / 6 avertissements. Les exports ne constituent pas une validation RF ni une autorisation de fabrication : confirmer les pistes 0,15 mm, les vias 0,40/0,20 mm et le traitement des vias dans les pastilles CMS avec le fabricant, puis resimuler l’antenne et revoir l’alimentation.
