# SmartPot V3 — modèle CST réduit issu de l’archive ODB++

Ce dossier contient un nouveau projet natif CST Learning Edition, reconstruit sans MATLAB et sans modifier le projet KiCad ni le fichier CST commercial original.

**Ce modèle ne représente pas la carte V3 complète. Les résultats sont préliminaires.**

## Géométrie et réglages

Source : `SmartPot_V3_CST_ODB.zip`, fourni dans le dossier `pot_fleur_v3_provisoire_4couches/CST_import` du projet. Le script lit directement les données de connexion ODB++ (`steps/pcb/eda/data`) pour sélectionner les primitives des réseaux RF_FEED, RF_MATCH et Net-(A1-VIN), puis reconstruit leurs solides dans CST. Les coordonnées XY de l’archive sont conservées.

- Contour : 30 × 60 mm.
- Empilage cuivre/diélectrique : 0,035 / 0,127 / 0,035 / 0,406 / 0,035 / 0,127 / 0,035 mm.
- FR4 provisoire : εr = 4,3, tan δ = 0,02 à 868 MHz.
- Cuivre : conductivité 5,8 × 10⁷ S/m.
- Port discret 1 : 50 Ω, U1.12 (57,925 ; −71,965 ; 0,765 mm) vers In1.Cu (mêmes X/Y, Z = 0,638 mm).
- R4 et R6 : ponts conducteurs idéaux. C6, L1 et J3 restent non montés.
- Bande : 700 à 1 000 MHz. Frontières ouvertes avec espace ajouté ; moniteur farfield à 868 MHz.

## Simplifications qui limitent l’interprétation

Les quatre masses sont des rectangles pleins de X = 50 à 80 mm et Y = −110 à −60,5 mm, avec des dégagements RF supérieurs synthétiques de 0,25 mm. Elles ne reproduisent pas les contours et les découpes exactes des plans KiCad. Quatre poteaux conducteurs idéaux relient ces masses ; les autres vias, trous, pistes, composants et le vernis sont omis.

Les pastilles RF arrondies sont remplacées par leurs rectangles englobants. Les segments RF sont des prismes à bouts carrés avec recouvrement aux raccords. Les parasites des résistances 0603 et des composants ne sont pas inclus. Le pot, le boîtier et l’environnement sont absents.

Le maillage est contraint par la limite de 100 000 cellules de la Learning Edition. Une simulation terminée ne démontre ni la convergence du maillage ni l’exactitude de ce modèle réduit. Une validation de la carte nécessite le cuivre complet, les vias, les composants, l’empilage fabricant et une étude de convergence.

## Fichiers

- `SmartPot_V3_ODB_REDUIT.cst` : projet CST Learning Edition.
- `SmartPot_V3_ODB_REDUIT/` : données du projet et résultats CST associés ; conserver ce dossier avec le fichier `.cst`.
- `modele_et_limites.json` : empreinte SHA-256 de l’archive, indices et enregistrements ODB++ sélectionnés, hypothèses.
- `build_cst_from_odb.ps1` : reconstruction reproductible par l’API COM de CST. Refuse d’écraser un projet existant. Choisir un nouveau `OutputDirectory` pour une reconstruction.

Le statut final du calcul et les éventuels exports sont consignés dans le compte rendu de simulation lorsqu’ils sont disponibles.

## Calculs exécutés le 26 octobre 2026

Les deux calculs transitoires se sont terminés avec succès, avec critère d’énergie résiduelle à −40 dB. Le premier comporte 93 060 cellules et un avertissement d’arête partiellement remplie de métal. Le second comporte 92 684 cellules, avec davantage de résolution près de la carte et moins loin de celle-ci ; cet avertissement ne réapparaît pas. Ce second maillage conserve un avertissement de durée de calcul potentiellement longue.

À 868 MHz, le premier calcul donne S11 = −0,2958 dB et le second −0,06315 dB. Aucun échantillon ne passe sous −10 dB entre 700 et 1 000 MHz. L’écart maximal entre courbes atteint 0,2833 dB. La convergence spatiale n’est pas établie : ne pas utiliser ces valeurs comme mesure ou comme validation de la carte V3 réelle. L’absence d’adaptation dans ce modèle réduit ne suffit pas à conclure sur la carte complète.

Exports : `S11_maillage5.txt`, `S11_maillage6_3.txt` (exports CST en dB), `S11_preliminaire.csv`, `S11_preliminaire.s1p` (Touchstone du second calcul), `resultats_preliminaires.json` (bilan chiffré). Le second calcul et son journal restent accessibles dans le projet CST. Le premier est conservé en export texte pour comparaison.
