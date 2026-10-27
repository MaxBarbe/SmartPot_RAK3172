# SmartPot V3 — reconstruction du PCB complet depuis ODB++

Ce dossier est distinct du modèle réduit. L’objectif est de reconstruire les quatre couches de cuivre avec leurs découpes réelles, les perçages et les connexions traversantes, puis de tenter un calcul CST dans les limites de l’édition installée.

## Source et géométrie

Archive : CST/SmartPot_V3_CST_ODB.zip, SHA-256 058da21323c9252999793997061988388d12fa4cb44b9573eb1fe389fc41e352.

Les 1 474 primitives des quatre couches sont lues, y compris les pistes, pastilles, zones remplies et polarités. Les formes connectées sont réunies géométriquement, sans remplacer les masses par des rectangles. Le contour est 30 × 60 mm. L’archive contient 228 perçages métallisés (vias et pastilles traversantes) et deux trous non métallisés.

Les coordonnées natives ODB++ sont conservées. Les contours circulaires sont reconstruits analytiquement lorsqu’ils sont reconnus ; les autres sont polygonisés et simplifiés avec une tolérance de 0,001 mm. Les éventuels résidus numériques de surface inférieure à 10^-8 mm² sont écartés. Les statistiques et hypothèses sont enregistrées dans geometrie_et_limites.json.

## Modèle physique et excitation

- Cuivres : 0–0,035 ; 0,162–0,197 ; 0,603–0,638 ; 0,765–0,800 mm.
- Diélectrique FR4 provisoire : εr 4,3, tan δ 0,02 à 868 MHz. Le FR4 est conservé sous l’antenne et dans les zones sans cuivre interne. Les volumes des cuivres internes et des fûts métallisés sont retirés du FR4.
- Cuivre : conductivité 5,8 × 10^7 S/m.
- Fûts traversants : diamètre de perçage issu de l’archive ; épaisseur de métallisation supposée de 0,025 mm, non fournie par le fabricant.
- R4 et R6 montés : ponts conducteurs idéaux de largeur 0,5 mm. C6/L1/J3 : non montés.
- Port discret 50 Ω à U1.12 : (57,925 ; −71,965 ; 0,765) vers la masse In1.Cu à Z = 0,638 mm.
- Solveur transitoire, 700–1 000 MHz, frontières ouvertes avec espace ajouté.

**Il s’agit du PCB nu complet, pas d’un modèle de tous les composants assemblés.** Les corps, blindages et circuits internes des composants, leurs parasites, le vernis, le pot et le boîtier ne sont pas inclus. Le module radio actif est remplacé par le port. L’empilage et les pertes doivent être remplacés par les données du fabricant avant validation.

## Statut

Lire etat_reconstruction.json pour le dernier état effectif. La présence des scripts ou des données géométriques ne confirme ni une reconstruction CST terminée, ni un calcul S11 terminé. Un fichier portant RECONSTRUCTION_INCOMPLETE est un état partiel, à ne pas simuler comme s’il représentait toute la carte.

La fin de construction et la réussite du solveur doivent être vérifiées dans le journal CST. Une courbe issue d’un maillage grossier ne suffit pas à valider la carte ni la première simulation de l’antenne.

## Reproduction

rebuild_full_odb.py nécessite Python 3 et Shapely. Il prépare full_geometry_jobs.json. build_full_cst.ps1 crée un nouveau projet via l’API COM de CST, construit les géométries et tente le solveur sans modifier les limites de licence. Il refuse d’écraser SmartPot_V3_PCB_COMPLET.cst.

## Résultat effectif du test

Les 2 283 étapes géométriques ont été exécutées. Le projet SmartPot_V3_PCB_COMPLET.cst est enregistré. Le solveur a refusé le modèle : 41 143 faces CAD pour 500 autorisées, et dépassement de la limite de 100 000 cellules. Aucun S11 de ce modèle complet n’a été calculé. Voir journal_test_CST.log. Les courbes du dossier V3_ODB_modele_reduit ne sont pas les résultats de cette carte complète.
