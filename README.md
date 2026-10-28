# SmartPot — pot de fleur connecté LoRaWAN 868 MHz

Projet de **Maxime — [MaxBarbe](https://github.com/MaxBarbe)**, développé dans le cadre du Master M2 : carte RAK3172, gestion d’énergie BQ25570, capteur SHT40, antenne imprimée et pot modélisé en 3D.

**Mise à jour du 28 octobre 2026.** La carte KiCad actuelle est la **V4 quatre couches**. Sa reconstruction CST avec excitation côté radio a produit un premier résultat M2 : **S11 = −8,97 dB à 868 MHz**. La convergence du maillage reste à démontrer. Une **V5 d’adaptation existe dans CST**, sans résultat publié à ce stade et sans modification de l’assemblage KiCad V4.

[Projet KiCad V4](pot_fleur_v4_nouvelle_antenne/pot_fleur.kicad_pro) · [PCB](pot_fleur_v4_nouvelle_antenne/pot_fleur.kicad_pcb) · [Simulation V4 M2](CST/V4_U112_868/README.md) · [Proposition V5](CST/V5_ADAPTATION_868/README.md) · [Anciennes versions](old/README.md)

## Carte V4 en 3D et intégration mécanique

<table>
<tr>
<td align="center" width="50%"><a href="pot_fleur_v4_nouvelle_antenne/README.md"><img src="pot_fleur_v4_nouvelle_antenne/docs/V4_3D.png" alt="Carte SmartPot V4, rendu natif KiCad en perspective" width="480"></a><br><strong>V4 — carte routée, nouvelle antenne</strong></td>
<td align="center" width="50%"><a href="Mecanique/README.md"><img src="Mecanique/Assemblage/SmartPot_assemblage_corrige_dessous.png" alt="Placement de la carte sous le pot, assemblage mécanique historique" width="480"></a><br><strong>Pot — étude d’intégration mécanique</strong><br>Cette capture d’assemblage précède la V4.</td>
</tr>
</table>

[Carte V4 STEP](pot_fleur_v4_nouvelle_antenne/3D/SmartPot_V4_RF_provisoire.step) · [Carte V4 GLB](pot_fleur_v4_nouvelle_antenne/3D/SmartPot_V4_RF_provisoire.glb) · [Pot 3MF](Mecanique/Pot_fleur/Pot_fleur.3mf) · [Pot STL](Mecanique/Pot_fleur/Pot_fleur.stl)

La carte mesure **30 × 60 × 0,8 mm**, avec connecteurs latéraux, deux trous de fixation et emplacements RF en **0603**. Le cuivre d’antenne reste sans vernis. Les modèles mécaniques sont disponibles pour vérifier l’encombrement ; ils ne remplacent pas les modèles électromagnétiques CST.

## Routage et contrôles KiCad

| Contrôle enregistré sur la V4 | Résultat |
|---|---:|
| Violations DRC | **0** |
| Connexions manquantes | **0** |
| Défauts de parité schéma / PCB | **0** |
| Segments / vias traversants | 415 / 204 |
| Empilage fabricant confirmé | **Non** |
| Validation RF / fabrication | **En cours** |

[Vue du routage](pot_fleur_v4_nouvelle_antenne/docs/V4_routee.svg) · [Rapport DRC](pot_fleur_v4_nouvelle_antenne/docs/DRC_V4_routee.json) · [Audit piste par piste](pot_fleur_v4_nouvelle_antenne/docs/Audit_pistes_V4.csv) · [Export ODB++ V4](pot_fleur_v4_nouvelle_antenne/CST_import/SmartPot_V4_RF_PROVISOIRE_ODB.zip)

La branche supérieure de l’antenne est conservée en position **X0**, sans le décalage de +0,40 mm de l’essai historique. La piste RF a une largeur de **0,229278 mm**, calculée pour un empilage provisoire : cuivre 35 µm, FR4 εr = 4,3, distance F.Cu/In1.Cu de 0,127 mm. Les 50 Ω du trajet réel restent à vérifier avec l’empilage fabricant et les discontinuités des composants. Un DRC sans erreur ne démontre ni l’adaptation ni le rendement de l’antenne.

## Simulation de la carte V4 — résultat provisoire M2

Le modèle est reconstruit depuis le cuivre routé V4, avec quatre couches, plans, vias et raccord physique vers l’antenne. Le **port 50 Ω est à U1.12 vers GND In1**. Le long port du premier modèle d’antenne n’est pas réutilisé à travers la piste physique.

| Grandeur à 868 MHz | V4 M2 |
|---|---:|
| S11 | **−8,96572 dB** |
| Impédance d’entrée au port | **23,755 + j1,301 Ω** |
| Minimum échantillonné | −9,02577 dB à 868,9 MHz |
| Rendement de rayonnement simulé | 43,69 % |
| Rendement total simulé | 38,14 % |
| Gain réalisé maximal simulé | −2,400 dBi |
| Maillage | 770 308 cellules |
| Bande calculée | 700–1 000 MHz |
| Critère d’énergie −50 dB | Atteint |
| Convergence spatiale | **Non démontrée** |

![Comparaison des simulations V4 M1 et M2, non convergées](CST/V4_U112_868/captures/S11_V4_maillages.png)

M1 donnait −0,02676 dB à 868 MHz avec 205 387 cellules. L’écart M1/M2 reste trop grand pour annoncer un résultat convergé. M3 est préparé à 959 112 cellules, mais aucun résultat M3 n’est publié. L’objectif **S11 ≤ −14 dB à 868 MHz n’est pas atteint** dans la V4 M2 ; aucune bande sous −10 dB n’est obtenue dans la plage simulée.

[Compte rendu et limites](CST/V4_U112_868/README.md) · [Projet M2 et résultats natifs](CST/V4_U112_868/modeles/SmartPot_V4_U112_TD_M2_2019.zip) · [Exports numériques et Touchstone](CST/V4_U112_868/resultats/) · [Comparaison de maillage](CST/V4_U112_868/audits/mesh_comparison.json)

## V5 CST — adaptation proposée, résultat non publié

La V5 est une **variante de simulation dérivée de la V4 M2**, pas une nouvelle carte KiCad validée. Elle conserve la géométrie et le port côté radio, et propose :

| Emplacement | V4 KiCad actuelle | Proposition V5 CST |
|---|---|---|
| R4 | 0 Ω monté | Liaison 0 Ω conservée |
| R6 | 0 Ω monté | Inductance série idéale **4,3 nH** |
| C6 | DNP | Condensateur shunt idéal **3,9 pF** |
| L1 / J3 | DNP | DNP |

L’objectif V5 est **S11 ≤ −16 dB à 868 MHz**. Le modèle publié a 807 240 cellules et deux éléments L/C idéaux ; son calcul a été lancé le 28 octobre à 14 h 08, heure de Paris. **Aucun résultat V5 n’est fourni dans le dernier commit récupéré : aucun gain d’adaptation n’est annoncé.** Les valeurs ne sont pas appliquées à la nomenclature KiCad V4 en l’absence de validation. Les parasites et pertes des composants réels devront être considérés.

[Documentation V5](CST/V5_ADAPTATION_868/README.md) · [Projet CST V5](CST/V5_ADAPTATION_868/modeles/SmartPot_V5_R6L4p3_C6C3p9_TD_M2_2019.zip) · [Audit de l’adaptation](CST/V5_ADAPTATION_868/audits/SmartPot_V5_R6L4p3_C6C3p9_TD_M2_2019_matching_audit.txt)

## Référence X0 et anciennes versions

Le point **−11,020993 dB à 868 MHz** concerne le modèle d’antenne X0 à port lumped, en fréquentiel avec cuivre PEC. Il a servi au choix de géométrie, mais ne constitue pas le résultat de la V4 alimentée depuis la radio. [Référence X0 et essai X +0,40 mm](CST/ANTENNE_868_3QUARTS/README.md).

Les cartes KiCad V1/V2/V3 et les anciens projets CST sont regroupés dans **[old/](old/README.md)**. Leurs courbes, rapports et fichiers restent disponibles pour comparaison. Les références pédagogiques sont conservées dans [references/EDU_RAK_2026](references/EDU_RAK_2026/README.md).

## Reprendre le projet

1. Récupérer le dépôt à jour : `git clone https://github.com/MaxBarbe/SmartPot_RAK3172.git`, ou `git pull --ff-only` sur une copie existante sans modifications locales.
2. Dans KiCad, ouvrir `pot_fleur_v4_nouvelle_antenne/pot_fleur.kicad_pro` ; les bibliothèques utilisent `${KIPRJMOD}`.
3. Sous Windows/CST 2019, extraire entièrement l’archive du modèle V4 M2 ou de la variante V5. Conserver le `.cst` avec son dossier compagnon, puis lire la documentation du modèle.
4. Poursuivre l’étude de convergence, confirmer l’empilage fabricant et obtenir la revue des enseignants avant fabrication. Les mesures au VNA et de rayonnement sur prototype compléteront la validation.

[État détaillé](docs/ETAT_DU_PROJET.md) · [Galerie](docs/GALERIE.md) · [Origine du projet](CREDITS.md)
