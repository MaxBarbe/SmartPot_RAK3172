# Électronique SmartPot — projet KiCad actif

Ouvrir [pot_fleur.kicad_pro](pot_fleur.kicad_pro). Le schéma racine [pot_fleur.kicad_sch](pot_fleur.kicad_sch) réunit les feuilles [RAK3172](untitled.kicad_sch), [capteur SHT40](capteur.kicad_sch) et [alimentation BQ25570](BQ25570.kicad_sch).

## PCB actuel

Carte préliminaire de 30 × 60 mm sur quatre couches, 48 empreintes présentes et 12 non montées, broches sur les côtés. C22 est volontairement non monté. R6/C6/L1 sont en 0603 ; ce boîtier est une contrainte du projet.

**L’antenne CST finale remplace maintenant l’ancienne antenne TI sur A1.** La géométrie a été légèrement ajustée pour conserver le PCB 30 × 60 mm, et un raccord RF physique a été ajouté. Voir [la fiche d’intégration](docs/INTEGRATION_ANTENNE_CST.md) et [l’aperçu](docs/APERCU_antenne_CST.pdf). Une resimulation est nécessaire ; les captures CST originales ne valident pas encore cette adaptation.

- [Rapport DRC du PCB actuel](docs/DRC_routage_4couches.txt) : 0 violation, 0 connexion manquante, 0 problème de parité.
- [Rapport ERC](docs/ERC_routage_4couches.txt) : 0 erreur et 6 avertissements.
- [Aperçu du routage avec antenne CST](docs/APERCU_antenne_CST.pdf).
- [Historique de l'antenne TI et réserves de conception](docs/ANTENNE_868MHz.md).

Les valeurs ROK1=4,12 MΩ, ROK2=7,87 MΩ et ROK3=1,02 MΩ donnent les seuils nominaux étudiés d'environ 3,52 / 3,82 V ; le réseau de surtension reste ROV1=7,15 MΩ et ROV2=8,66 MΩ. Ces valeurs ne remplacent pas une vérification des tolérances et du fonctionnement réel.

Les bibliothèques d'empreintes et de symboles locales sont déclarées dans `fp-lib-table` et `sym-lib-table`. Les chemins utilisent `${KIPRJMOD}` ; conserver les dossiers `footprints`, `symbols` et `3dmodels` avec le projet. Les ressources pédagogiques ont été déplacées dans [references/EDU_RAK_2026](../references/EDU_RAK_2026/README.md).

Les rapports sans erreur ne valident pas la performance RF ou l'alimentation. Le placement de CREF1, CBYP1, CIN2 et LBUCK1 doit être revu autour de U3. L'empilage quatre couches reste à confirmer avec le fabricant.

## Export mécanique et visualisation 3D

[Carte assemblée STEP](../Mecanique/PCB/SmartPot_assemble.step), [carte nue STEP](../Mecanique/PCB/SmartPot_carte_nue.step), [vues 3D et références des modèles](../Mecanique/PCB/README.md). Les modèles manquants de RAK3172, BQ25570, SHT40 et LBOOST1 ont été complétés sans modification du routage. Les modèles DNP sont exclus du STEP assemblé.
