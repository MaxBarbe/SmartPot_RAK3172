# Carte SmartPot 3D — import dans le pot

## Fichier à importer dans Shapr3D

**[SmartPot_assemble.step](SmartPot_assemble.step)** : carte de 30 × 60 mm, épaisseur 0,8 mm, composants montés, pistes, pads et zones de cuivre extérieures. Export STEP AP214 en millimètres, origine XY au centre du PCB. Le modèle est issu du fichier KiCad actuel avec l'antenne CST adaptée.

- [SmartPot_carte_nue.step](SmartPot_carte_nue.step) : version légère du substrat et de ses perçages, sans composants, pour dessiner un logement.
- [SmartPot_assemble.glb](SmartPot_assemble.glb) : modèle coloré portable pour une future visualisation interactive. Le format GLB stocke les coordonnées en mètres et utilise Y comme axe vertical.
- [Vue en perspective](SmartPot_3D_perspective.png) et [vue de dessus](SmartPot_3D_dessus.png) : rendus natifs KiCad, pas des illustrations générées.

![Carte en perspective](SmartPot_3D_perspective.png)

![Carte de dessus](SmartPot_3D_dessus.png)

## Intégration mécanique

1. Ouvrir ton projet de pot dans Shapr3D et importer `SmartPot_assemble.step`, sans modifier son échelle.
2. Vérifier que le substrat mesure bien 30 × 60 mm. Positionner et orienter ensuite la carte dans le pot ; l'origine XY a été centrée pour faciliter ces transformations.
3. Utiliser la carte nue pour préparer le logement, mais la carte assemblée pour vérifier les dégagements des broches, du bornier et des composants.
4. Enregistrer l'assemblage pot + PCB et produire les vues de l'ensemble. Le placement dans le pot n'a pas encore été décidé ou appliqué dans ces exports.

L'enveloppe des modèles assemblés est d'environ **30 × 60 × 23.0 mm**, en incluant le bornier et les broches qui dépassent sous le PCB. Ce volume est plus grand que les 0,8 mm du substrat. Prévoir les jeux de montage et comparer les modèles aux références physiques effectivement achetées.

## Modèles complétés et vérification

Les 35 composants physiques montés ont un modèle présent dans l'export. A1 est du cuivre de PCB, pas un composant à monter ; ses rectangles et son raccord sont exportés avec les pads. Les 12 empreintes DNP, dont C22, C6 et L1, ne reçoivent pas de corps 3D dans l'assemblage. Leurs pads restent visibles sur la carte.

- **RAK3172** : [STEP officiel RAKwireless](https://downloads.rakwireless.com/3D_File/WisDuo/3D_RAK3172.stp), [publication du fournisseur](https://forum.rakwireless.com/t/rak3172-3d-model-file/6238). Son origine fournisseur a été centrée sur U1 et son plan inférieur posé au-dessus du PCB. Le modèle local est conservé dans `pot_fleur/3dmodels/RAK3172.stp`.
- **BQ25570** : modèle KiCad `Texas_VQFN-RGR-20-1EP_3.5x3.5mm_Pitch0.5mm.step`, correspondant au boîtier RGR.
- **SHT40 et LBOOST1** : modèles locaux déjà fournis, avec correction de l'axe vertical. Le fichier de bobine porte un nom LPS4018-223MRC mais son en-tête fournisseur indique LPS4018-103MRC : il représente le boîtier de cette famille, pas une validation de l'inductance électrique.

[Audit des références et enveloppes 3D](verification_3D.json). Les modèles de U1/U3/U4/LBOOST1 ont été contrôlés pour être au-dessus du PCB et centrés sur leurs empreintes. Les corrections ne déplacent aucun pad ni aucune piste. [Contrôle KiCad après ajout des modèles](../../pot_fleur/docs/DRC_modeles_3D.txt) : 0 violation, 0 connexion manquante, 0 problème de parité schéma/PCB.

Les rendus servent à la présentation et à la vérification d'encombrement. La fabrication et les performances RF de la version adaptée restent à valider avec l'empilage réel et le pot.
