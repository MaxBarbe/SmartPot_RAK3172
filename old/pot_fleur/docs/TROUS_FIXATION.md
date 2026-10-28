# Perçages de fixation — 13 octobre 2026

Les deux cercles F.Cu dessinés par Maxime avaient un rayon de 1,5 mm. Ils sont remplacés, sans déplacer leurs centres, par des empreintes officielles `MountingHole:MountingHole_3mm` : perçages non métallisés de diamètre 3 mm, hors nomenclature et placement d’assemblage.

| Repère | X KiCad (mm) | Y KiCad (mm) | Diamètre (mm) |
|---|---:|---:|---:|
| H1 — inférieur | 61,5 | 107 | 3 |
| H2 — supérieur | 65,5 | 65,224999 | 3 |

Les plans de cuivre sont recalculés. Le fichier `percages/pot_fleur-NPTH.drl` contient exactement deux perçages `T1C3.000`, à ces coordonnées. Les exports STEP assemblé, STEP nu, GLB de la carte et sa vue 3D de dessus sont actualisés. La capture Shapr3D du pot reste celle du 12 octobre, avant ces trous ; le pot et les anciens assemblages pot+carte n’ont pas été modifiés.

## Contrôle

Le rapport `DRC_trous_fixation.txt` indique 0 connexion manquante et 0 problème de parité schéma/PCB. Il reste **1 erreur de chevauchement des zones d’occupation entre H1 et J10** : la zone de réservation de tête de vis de l’empreinte officielle rencontre celle du bornier. Le perçage et ses dégagements cuivre ne produisent pas de violation, mais la tête de vis et son montage restent à vérifier. Les centres demandés sont conservés ; aucune règle n’est désactivée pour masquer ce point.

Les fichiers de perçage sont fournis pour contrôle, pas comme dossier de fabrication validé. Sauvegarde locale avant modification : `sauvegardes/avant_trous_20261013/`.
