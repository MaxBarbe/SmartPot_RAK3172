# Électronique SmartPot — projet KiCad actif

Ouvrir [pot_fleur.kicad_pro](pot_fleur.kicad_pro). Le schéma racine [pot_fleur.kicad_sch](pot_fleur.kicad_sch) réunit les feuilles [RAK3172](untitled.kicad_sch), [capteur SHT40](capteur.kicad_sch) et [alimentation BQ25570](BQ25570.kicad_sch).

## PCB actuel

Carte préliminaire de 30 × 60 mm sur quatre couches, 48 empreintes présentes et 11 non montées, broches sur les côtés. C22 est volontairement non monté. C6/C7/L1 sont en 0603 ; ce boîtier est une contrainte du projet.

**Le PCB contient encore l'ancienne antenne TI DN038, pas l'antenne CST finale du 12 octobre.** La conception CST choisie est [TP1_M2_Smart_2-3.cst](../CST/TP1_M2_Smart_2-3.cst). Il faut intégrer sa géométrie et son alimentation avant de considérer cette carte comme la nouvelle version RF.

- [Rapport DRC du PCB actuel](docs/DRC_routage_4couches.txt) : 0 violation, 0 connexion manquante, 0 problème de parité.
- [Rapport ERC](docs/ERC_routage_4couches.txt) : 0 erreur et 6 avertissements.
- [Aperçu du routage actuel](docs/APERCU_routage_4couches.pdf).
- [Historique de l'antenne TI et réserves de conception](docs/ANTENNE_868MHz.md).

Les valeurs ROK1=4,12 MΩ, ROK2=7,87 MΩ et ROK3=1,02 MΩ donnent les seuils nominaux étudiés d'environ 3,52 / 3,82 V ; le réseau de surtension reste ROV1=7,15 MΩ et ROV2=8,66 MΩ. Ces valeurs ne remplacent pas une vérification des tolérances et du fonctionnement réel.

Les bibliothèques d'empreintes et de symboles locales sont déclarées dans `fp-lib-table` et `sym-lib-table`. Les chemins utilisent `${KIPRJMOD}` ; conserver les dossiers `footprints`, `symbols` et `3dmodels` avec le projet. Les ressources pédagogiques ont été déplacées dans [references/EDU_RAK_2026](../references/EDU_RAK_2026/README.md).

Les rapports sans erreur ne valident pas la performance RF ou l'alimentation. Le placement de CREF1, CBYP1, CIN2 et LBUCK1 doit être revu autour de U3. L'empilage quatre couches reste à confirmer avec le fabricant.
