# SmartPot — pot de fleur connecté LoRaWAN 868 MHz

Projet personnel de **Maxime — [MaxBarbe](https://github.com/MaxBarbe)**, développé dans le cadre du Master M2. SmartPot réunit une carte électronique autour du RAK3172, une alimentation BQ25570, une antenne imprimée étudiée dans CST et un pot modélisé en 3D.

**État au 12 octobre 2026 :** antenne finale fournie dans CST, conception mécanique disponible, PCB quatre couches routé en version préliminaire. La nouvelle antenne CST doit encore remplacer l'ancienne antenne TI dans KiCad. Le projet n'est pas encore validé pour fabrication.

<table>
<tr>
<td align="center" width="50%"><img src="Mecanique/Pot_fleur/pot-fleur-vue2.png" alt="Vue latérale du pot SmartPot modélisé en 3D" width="420"><br>Conception 3D du pot</td>
<td align="center" width="50%"><img src="CST/ant-868.PNG" alt="Antenne imprimée repliée conçue dans CST" width="420"><br>Antenne étudiée autour de 868 MHz</td>
</tr>
</table>

## Accès aux fichiers du projet

| Domaine | Fichier principal | Documentation |
|---|---|---|
| Électronique KiCad | [pot_fleur.kicad_pro](pot_fleur/pot_fleur.kicad_pro) | [Électronique et état du PCB](pot_fleur/README.md) |
| Schéma complet | [pot_fleur.kicad_sch](pot_fleur/pot_fleur.kicad_sch) | Feuilles RAK3172, SHT40 et BQ25570 |
| PCB quatre couches | [pot_fleur.kicad_pcb](pot_fleur/pot_fleur.kicad_pcb) | [Aperçu du routage](pot_fleur/docs/APERCU_routage_4couches.pdf) |
| Antenne finale CST | [TP1_M2_Smart_2-3.cst](CST/TP1_M2_Smart_2-3.cst) | [Paramètres et résultats](CST/README.md) |
| Pot 3D | [Pot_fleur.3mf](Mecanique/Pot_fleur/Pot_fleur.3mf) | [Conception mécanique](Mecanique/README.md) |
| Pot — aperçu maillage | [Pot_fleur.stl](Mecanique/Pot_fleur/Pot_fleur.stl) | Export dérivé du 3MF pour visualisation |

## Électronique

- **RAK3172** : module radio pour la communication LoRa/LoRaWAN visée à 868 MHz.
- **BQ25570** : récupération et gestion de l'énergie ; entrée du projet repérée P-MFC.
- **SHT40** : mesure de température et d'humidité ; interfaces I²C exposées pour les capteurs.
- **PCB préliminaire de 30 × 60 mm sur quatre couches**, avec connecteurs de broches placés sur les côtés.
- **Réseau d'adaptation RF en 0603 obligatoire** : C6, C7 et L1. Les valeurs restent à réévaluer pour l'antenne CST finale.

Les annonces concernant l'accéléromètre, le BME280 ou les LED de la carte EDU RAK ne décrivent pas automatiquement la carte SmartPot. Les documents de cette carte sont conservés uniquement comme références pédagogiques.

## Antenne : résultats fournis

![Courbe S11 simulée de l'antenne](CST/S11-868.PNG)

La capture indique un minimum de **S11 ≈ −17,9 dB à 869 MHz**. La capture de champ lointain à **868 MHz** indique une directivité de **1,805 dBi**, un rendement de rayonnement d'environ **87,9 %** et un rendement total d'environ **85,0 %**. Il s'agit de résultats de simulation fournis, et non de mesures sur un prototype. La directivité n'est pas le gain réalisé.

Le modèle CST utilise un substrat de **29,1 × 59,1 × 0,8 mm** et une zone supérieure de **10 mm**. Ses dimensions et ses masses diffèrent du PCB KiCad actuel : les résultats ne constituent pas encore une validation de la carte quatre couches. Voir [la fiche de simulation](CST/README.md).

## Structure du dépôt

```text
SmartPot_RAK3172/
├── README.md                   # Présentation du projet SmartPot
├── CREDITS.md                  # Origine pédagogique et références utilisées
├── pot_fleur/                  # Projet KiCad actif et bibliothèques locales
│   ├── footprints/             # Empreintes spécifiques au projet
│   ├── symbols/                # Symboles spécifiques
│   ├── 3dmodels/               # Modèles 3D des composants
│   └── docs/                   # Rapports ERC/DRC et aperçu du PCB
├── CST/                        # Antenne finale, variantes et captures
│   └── explorations/           # Anciennes propositions, non retenues comme référence
├── Mecanique/                  # Pot 3D, export STL et captures
│   └── Pot_fleur/
├── docs/                       # État du projet et galerie
└── references/EDU_RAK_2026/     # Ressources de la plateforme pédagogique d'origine
```

## Ouvrir et reprendre le projet

1. Cloner ce dépôt : `git clone https://github.com/MaxBarbe/SmartPot_RAK3172.git`.
2. Dans KiCad, ouvrir `pot_fleur/pot_fleur.kicad_pro` ; les bibliothèques locales utilisent `${KIPRJMOD}`.
3. Dans CST, ouvrir `CST/TP1_M2_Smart_2-3.cst`. Les variantes `-1` et `-2` sont conservées pour suivre les essais.
4. Pour la mécanique, ouvrir le fichier 3MF dans un logiciel compatible, ou le STL pour visualiser le maillage. Le fichier natif Shapr3D n'est pas fourni dans ce dépôt.

## État et prochaines validations

Le dernier rapport KiCad versionné indique **0 violation DRC, 0 connexion manquante et 0 problème de parité schéma/PCB** pour le PCB avec l'ancienne antenne TI. L'ERC conserve **6 avertissements et 0 erreur**. Ces contrôles ne valident ni les boucles d'alimentation ni l'adaptation de la nouvelle antenne.

La prochaine étape consiste à intégrer la géométrie CST finale, son alimentation et sa connexion de masse dans KiCad, puis à revoir le placement autour du BQ25570. L'empilage du fabricant et l'environnement du pot devront être pris en compte avant fabrication. Le protocole LoRaWAN complet et le fonctionnement du système ne sont pas encore démontrés dans les fichiers fournis.

- [État détaillé du projet](docs/ETAT_DU_PROJET.md)
- [Galerie : pot, antenne et simulation](docs/GALERIE.md)
- [Crédits et origine du projet](CREDITS.md)

Ce dépôt dérive de la plateforme [EDU_RAK_2026 de DorianDIANA](https://github.com/DorianDIANA/EDU_RAK_2026). Les ressources d'origine et l'historique sont conservés ; les développements SmartPot sont présentés séparément.
