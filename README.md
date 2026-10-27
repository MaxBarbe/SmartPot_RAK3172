# SmartPot — pot de fleur connecté LoRaWAN 868 MHz

Projet personnel de **Maxime — [MaxBarbe](https://github.com/MaxBarbe)**, développé dans le cadre du Master M2. SmartPot réunit une carte électronique autour du RAK3172, une alimentation BQ25570, une antenne imprimée étudiée dans CST et un pot modélisé en 3D.

## Version actuelle : V4, quatre couches — 27 octobre 2026

La nouvelle antenne reprend la branche de **1 × 7 mm raccordée en haut**, en position **X0**. Son raccord à la radio est désormais une piste physique. Le routage et les masses sont présents sur la carte de 30 × 60 mm. **La V4 est une version de travail : ses performances RF restent à simuler avec ce raccord réel et l’empilage fabricant.**

[Ouvrir le projet KiCad V4](pot_fleur_v4_nouvelle_antenne/pot_fleur.kicad_pro) · [PCB](pot_fleur_v4_nouvelle_antenne/pot_fleur.kicad_pcb) · [Détails et limites](pot_fleur_v4_nouvelle_antenne/README.md) · [STEP](pot_fleur_v4_nouvelle_antenne/3D/SmartPot_V4_RF_provisoire.step) · [GLB](pot_fleur_v4_nouvelle_antenne/3D/SmartPot_V4_RF_provisoire.glb)

![Carte V4 — rendu natif KiCad 3D](pot_fleur_v4_nouvelle_antenne/docs/V4_3D.png)

| Contrôle KiCad V4 | Résultat |
|---|---:|
| Violations DRC | **0** |
| Connexions manquantes | **0** |
| Défauts de parité schéma / PCB | **0** |
| Segments / vias traversants | 415 / 204 |
| Validation RF du PCB V4 routé | **À réaliser** |

[Rapport DRC](pot_fleur_v4_nouvelle_antenne/docs/DRC_V4_routee.json) · [Audit des pistes](pot_fleur_v4_nouvelle_antenne/docs/Audit_pistes_V4.csv) · [Routage V4](pot_fleur_v4_nouvelle_antenne/docs/V4_routee.svg) · [ODB++ pour CST](pot_fleur_v4_nouvelle_antenne/CST_import/SmartPot_V4_RF_PROVISOIRE_ODB.zip)

## Résultats CST : modèles à distinguer

| Modèle | S11 à 868 MHz | Autre résultat | Limite principale |
|---|---:|---|---|
| Antenne initiale | Non extrait numériquement | Capture : −17,9 dB à 869 MHz | Géométrie, masses et excitation différentes de la carte actuelle |
| PCB complet V3, port long à l’antenne | −0,557 dB | Minimum −3,04 dB à 882,1 MHz | Maillage grossier et non convergé |
| Branche supérieure 1 × 7 mm, **X0** | **−11,021 dB** | Point fréquentiel unique | Cuivre PEC et convergence du maillage non démontrée |
| Essai temporel **X +0,40 mm** | **−3,749 dB** | Minimum −10,697 dB à 883,6 MHz | Maillage préliminaire ; cet essai n’est pas une optimisation validée |
| **PCB KiCad V4 routé, X0 avec raccord physique** | **Pas encore simulé** | Export CST disponible | Le port lumped du modèle source est remplacé par une alimentation physique à vérifier |

L’objectif de −14 dB à 868 MHz n’est pas atteint dans les nouveaux essais CST publiés. Les valeurs de X0 et X +0,40 mm ne permettent pas d’isoler l’effet du déplacement, car le solveur, le modèle de cuivre et le maillage diffèrent. Aucune de ces courbes ne doit être présentée comme le résultat de la V4 routée.

[Modèles, captures et exports natifs de la nouvelle antenne](CST/ANTENNE_868_3QUARTS/README.md) · [Essai PCB complet V3](CST/V3_ODB_carte_complete/CST2019/README.md)

![Essai CST temporel X +0,40 mm — distinct de la V4](CST/ANTENNE_868_3QUARTS/captures/S11_TD_X_PLUS0400_CST.png)

## Mécanique et vues du projet

<table>
<tr>
<td align="center" width="50%"><a href="Mecanique/README.md"><img src="Mecanique/Assemblage/SmartPot_assemblage_corrige_dessous.png" alt="Pot SmartPot avec carte KiCad centrée dessous après correction dans Shapr3D" width="420"></a><br><strong>Pot + PCB — assemblage corrigé</strong></td>
<td align="center" width="50%"><a href="pot_fleur_v4_nouvelle_antenne/README.md"><img src="pot_fleur_v4_nouvelle_antenne/docs/V4_3D.png" alt="Rendu natif KiCad de la V4 avec nouvelle antenne" width="420"></a><br><strong>KiCad — carte assemblée en 3D</strong></td>
</tr>
<tr>
<td align="center" width="50%"><a href="pot_fleur_v4_nouvelle_antenne/pot_fleur.kicad_pcb"><img src="pot_fleur_v4_nouvelle_antenne/docs/V4_routee.svg" alt="Routage et cuivre supérieur du PCB SmartPot avec antenne CST" width="240"></a><br><strong>KiCad — routage du PCB</strong></td>
<td align="center" width="50%"><a href="CST/README.md"><img src="CST/ant-868.PNG" alt="Antenne imprimée finale conçue dans CST" width="420"></a><br><strong>CST — antenne à 868 MHz</strong><br>Captures S11 et champ lointain ci-dessous</td>
</tr>
</table>

**Mise à jour du 13 octobre :** deux perçages de fixation non métallisés Ø 3 mm ajoutés aux emplacements de Maxime. Le contrôle de cette ancienne version signalait un chevauchement de la zone de tête de vis H1 avec le bornier J10 ; ce point a ensuite été traité en V2/V3 par les pastilles pour fils soudés ; voir les rapports propres à chaque version. [Coordonnées et rapport](pot_fleur/docs/TROUS_FIXATION.md).

**V2 du 14 octobre — deux couches :** routage complet sur F.Cu/B.Cu, 0 connexion manquante et 0 problème de parité. Le DRC indique 0 violation après adaptation de J10 pour fils soudés directement ; l’ERC compte 0 erreur et 6 avertissements. [Ouvrir la V2 et lire ses contraintes de fabrication/RF](pot_fleur_v2_2couches/README.md).

![V2 à deux couches — vue KiCad 3D](pot_fleur_v2_2couches/docs/PCB_V2_3D.png)

## Accès aux fichiers du projet

| Domaine | Fichier principal | Documentation |
|---|---|---|
| **V4 actuelle, quatre couches** | [Projet KiCad V4](pot_fleur_v4_nouvelle_antenne/pot_fleur.kicad_pro) | [Routage, contrôles et 3D](pot_fleur_v4_nouvelle_antenne/README.md) |
| Électronique KiCad | [pot_fleur.kicad_pro](pot_fleur/pot_fleur.kicad_pro) | [Électronique et état du PCB](pot_fleur/README.md) |
| Schéma complet | [pot_fleur.kicad_sch](pot_fleur/pot_fleur.kicad_sch) | Feuilles RAK3172, SHT40 et BQ25570 |
| PCB quatre couches | [pot_fleur.kicad_pcb](pot_fleur/pot_fleur.kicad_pcb) | [Aperçu avec antenne CST](pot_fleur/docs/APERCU_antenne_CST.pdf) |
| PCB V2 deux couches | [pot_fleur.kicad_pro](pot_fleur_v2_2couches/pot_fleur.kicad_pro) | [Routage, contrôles et STEP V2](pot_fleur_v2_2couches/README.md) |
| V3 provisoire quatre couches | [pot_fleur.kicad_pro](pot_fleur_v3_provisoire_4couches/pot_fleur.kicad_pro) | [Corrections, contrôles et 3D](pot_fleur_v3_provisoire_4couches/README.md) |
| Antenne CST initiale (historique) | [TP1_M2_Smart_2-3.cst](CST/TP1_M2_Smart_2-3.cst) | [Paramètres et résultats](CST/README.md) |
| Carte 3D pour Shapr3D | [SmartPot_assemble.step](Mecanique/PCB/SmartPot_assemble.step) | [Import et enveloppe mécanique](Mecanique/PCB/README.md) |
| Carte nue 3D | [SmartPot_carte_nue.step](Mecanique/PCB/SmartPot_carte_nue.step) | Substrat seul pour préparer le logement |
| Modèle 3D portable | [SmartPot_assemble.glb](Mecanique/PCB/SmartPot_assemble.glb) | Carte colorée pour une future visualisation |
| Pot 3D | [Pot_fleur.3mf](Mecanique/Pot_fleur/Pot_fleur.3mf) | [Conception mécanique](Mecanique/README.md) |
| Pot — aperçu maillage | [Pot_fleur.stl](Mecanique/Pot_fleur/Pot_fleur.stl) | Export dérivé du 3MF pour visualisation |

## Électronique

- **RAK3172** : module radio pour la communication LoRa/LoRaWAN visée à 868 MHz.
- **BQ25570** : récupération et gestion de l'énergie ; entrée du projet repérée P-MFC.
- **SHT40** : mesure de température et d'humidité ; interfaces I²C exposées pour les capteurs.
- **PCB préliminaire de 30 × 60 mm sur quatre couches**, avec connecteurs de broches placés sur les côtés.
- **Réseau d’adaptation RF en 0603 obligatoire** : R6 (0 Ω en série), C6 et L1 (shunts non montés au départ). Les valeurs restent à réévaluer pour l'antenne CST finale.

Les annonces concernant l'accéléromètre, le BME280 ou les LED de la carte EDU RAK ne décrivent pas automatiquement la carte SmartPot. Les documents de cette carte sont conservés uniquement comme références pédagogiques.

## Carte 3D et intégration dans le pot

Le [STEP de la carte assemblée](Mecanique/PCB/SmartPot_assemble.step) est disponible pour import dans Shapr3D. Il contient le PCB 30 × 60 × 0,8 mm, les 35 composants physiques montés et le cuivre extérieur. Les composants DNP sont exclus. L'enveloppe avec broches et bornier atteint environ 23 mm de hauteur totale ; utiliser l'assemblage complet pour vérifier les dégagements.

Maxime a corrigé le placement dans Shapr3D : la carte est centrée sous le pot, composants vers l’extérieur. La capture ci-dessous montre ce projet corrigé. Les fichiers d’assemblage GLB/3MF précédemment générés restent une proposition antérieure et ne reproduisent pas les dernières corrections Shapr3D. [Détails des exports de la carte](Mecanique/PCB/README.md).

![Assemblage corrigé dans Shapr3D, vue de dessous](Mecanique/Assemblage/SmartPot_assemblage_corrige_dessous.png)

## Antenne initiale : résultats historiques

![Courbe S11 simulée de l'antenne](CST/S11-868.PNG)

La capture indique un minimum de **S11 ≈ −17,9 dB à 869 MHz**. La capture de champ lointain à **868 MHz** indique une directivité de **1,805 dBi**, un rendement de rayonnement d'environ **87,9 %** et un rendement total d'environ **85,0 %**. Il s'agit de résultats de simulation fournis, et non de mesures sur un prototype. La directivité n'est pas le gain réalisé.

![Diagramme de rayonnement simulé à 868 MHz](CST/farfield-868.PNG)

[Voir aussi la carte dans CST](CST/carte-868.PNG).

Le modèle CST utilise un substrat de **29,1 × 59,1 × 0,8 mm** et une zone supérieure de **10 mm**. Ses dimensions et ses masses diffèrent du PCB KiCad actuel : les résultats ne constituent pas encore une validation de la carte quatre couches. Voir [la fiche de simulation](CST/README.md).

## Structure du dépôt

```text
SmartPot_RAK3172/
├── README.md                   # Présentation du projet SmartPot
├── CREDITS.md                  # Origine pédagogique et références utilisées
├── pot_fleur_v4_nouvelle_antenne/ # Version actuelle routée, RF provisoire
├── pot_fleur/                  # Version historique et bibliothèques locales
│   ├── footprints/             # Empreintes spécifiques au projet
│   ├── symbols/                # Symboles spécifiques
│   ├── 3dmodels/               # Modèles 3D des composants
│   └── docs/                   # Rapports ERC/DRC et aperçu du PCB
├── pot_fleur_v2_2couches/      # Variante KiCad 2 couches, contrôles et STEP
├── pot_fleur_v3_provisoire_4couches/ # Corrections du retour de Dorian, hypothèses RF
├── CST/                        # Antenne finale, variantes et captures
│   └── explorations/           # Anciennes propositions, non retenues comme référence
├── Mecanique/                  # Pot et carte 3D
│   ├── Pot_fleur/              # 3MF, STL et captures du pot
│   └── PCB/                    # STEP, GLB et rendus KiCad
├── docs/                       # État du projet et galerie
└── references/EDU_RAK_2026/     # Ressources de la plateforme pédagogique d'origine
```

## Ouvrir et reprendre le projet

1. Cloner ce dépôt : `git clone https://github.com/MaxBarbe/SmartPot_RAK3172.git`.
2. Dans KiCad, ouvrir `pot_fleur_v4_nouvelle_antenne/pot_fleur.kicad_pro` ; les bibliothèques locales utilisent `${KIPRJMOD}`.
3. Dans CST, choisir le modèle documenté dans `CST/ANTENNE_868_3QUARTS/README.md`. Pour resimuler la V4 routée, utiliser son export ODB++ et son guide ; les anciens projets CST restent des références distinctes.
4. Pour la mécanique, ouvrir le pot 3MF, ou son projet natif Shapr3D si tu le conserves localement, puis importer `Mecanique/PCB/SmartPot_assemble.step`. Le fichier natif du pot n’est pas fourni dans ce dépôt. Les instructions sont dans [la fiche 3D](Mecanique/PCB/README.md).

## État et prochaines validations

La version quatre couches conserve **1 erreur DRC mécanique H1/J10**. La **V2 deux couches indique 0 violation DRC**, avec J10 adapté pour des fils soudés directement. Les deux versions indiquent **0 connexion manquante et 0 problème de parité schéma/PCB**. Le rapport sans violation du 12 octobre est antérieur à l’ajout des trous de fixation. L'ERC conserve **6 avertissements et 0 erreur**. Ces contrôles ne valident ni les boucles d’alimentation ni l’adaptation RF. Voir [la fiche d’intégration](pot_fleur/docs/INTEGRATION_ANTENNE_CST.md).

La géométrie CST finale, son raccord RF physique et sa connexion de masse sont maintenant intégrés dans KiCad. La prochaine étape est de resimuler cette adaptation, puis de revoir le placement autour du BQ25570. L'empilage du fabricant et l'environnement du pot devront être pris en compte avant fabrication. Le protocole LoRaWAN complet et le fonctionnement du système ne sont pas encore démontrés dans les fichiers fournis.

- [État détaillé du projet](docs/ETAT_DU_PROJET.md)
- [Galerie : pot, antenne et simulation](docs/GALERIE.md)
- [Crédits et origine du projet](CREDITS.md)

Ce dépôt dérive de la plateforme [EDU_RAK_2026 de DorianDIANA](https://github.com/DorianDIANA/EDU_RAK_2026). Les ressources d'origine et l'historique sont conservés ; les développements SmartPot sont présentés séparément.
