# Galerie SmartPot

**27 octobre 2026 — version actuelle : V4 routée, RF provisoire.** [Projet et contrôles](../pot_fleur_v4_nouvelle_antenne/README.md) : 0 violation DRC, 0 connexion manquante, 0 défaut de parité. Le S11 de la V4 avec son raccord physique n’a pas été calculé. Les essais CST X0 (−11,02 dB à 868 MHz) et X +0,40 mm (−3,75 dB à 868 MHz) concernent des modèles à port lumped distincts.

![V4 — vue 3D](../pot_fleur_v4_nouvelle_antenne/docs/V4_3D.png)

Les sections ci-dessous conservent l’historique des versions précédentes.


## Pot — vue intérieure

![Vue intérieure](../Mecanique/Pot_fleur/pot-fleur-vue.png)

## Pot — vue latérale

![Vue latérale](../Mecanique/Pot_fleur/pot-fleur-vue2.png)

## Antenne finale dans CST

![Antenne](../CST/ant-868.PNG)

![Carte](../CST/carte-868.PNG)

## Simulation S11

![S11](../CST/S11-868.PNG)

## Champ lointain à 868 MHz

![Farfield](../CST/farfield-868.PNG)

Les vues mécaniques et les simulations ont été fournies par Maxime. Voir [la fiche CST](../CST/README.md) pour l'interprétation des résultats et leurs limites.

## Antenne CST intégrée dans le PCB KiCad

![PCB après remplacement de l’antenne TI](../pot_fleur/docs/APERCU_antenne_CST.png)

Géométrie adaptée et raccord physique ajouté : [détails et resimulation](../pot_fleur/docs/INTEGRATION_ANTENNE_CST.md).

## PCB — rendu KiCad en perspective

![PCB assemblé en 3D](../Mecanique/PCB/SmartPot_3D_perspective.png)

## PCB — rendu KiCad de dessus

![PCB de dessus en 3D](../Mecanique/PCB/SmartPot_3D_dessus.png)

[Fichier STEP à importer dans le pot](../Mecanique/PCB/SmartPot_assemble.step). Le placement a été corrigé par Maxime dans Shapr3D ; voir la capture ci-dessous.

## Pot + PCB — assemblage corrigé dans Shapr3D

![Carte centrée sous le pot après correction par Maxime](../Mecanique/Assemblage/SmartPot_assemblage_corrige_dessous.png)

Capture native Shapr3D du 12 octobre 2026. Vue de dessous, composants vers l’extérieur. Cette capture atteste du placement visible ; les dégagements et les fixations ne sont pas validés par cette vue seule.

## Variante V2 — deux couches

![Carte V2 assemblée](../pot_fleur_v2_2couches/docs/PCB_V2_3D.png)

[Routage F.Cu/B.Cu](../pot_fleur_v2_2couches/docs/Routage_V2.svg) · [Projet, contrôles et contraintes](../pot_fleur_v2_2couches/README.md)

## V3 provisoire — corrections du retour de Dorian

![V3 et antenne sans vernis](../pot_fleur_v3_provisoire_4couches/docs/PCB_V3_3D.png)

[Projet et hypothèses RF](../pot_fleur_v3_provisoire_4couches/README.md) · [Plan GND In2](../pot_fleur_v3_provisoire_4couches/docs/Plan_GND_In2.svg)
