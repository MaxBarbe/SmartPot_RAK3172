# Pot et carte KiCad assemblés

## Correction réalisée par Maxime dans Shapr3D

![Assemblage corrigé, vue de dessous](SmartPot_assemblage_corrige_dessous.png)

Capture native du projet « Pot_fleur » le 12 octobre 2026, après les corrections de Maxime. La carte apparaît centrée sous le pot, composants vers l’extérieur. Les exports GLB/3MF et le rapport ci-dessous correspondent à la proposition précédente : ils n’ont pas été réexportés depuis le projet Shapr3D corrigé et leurs cotes ne doivent pas être attribuées à la correction.

## Proposition d’assemblage précédente

- `SmartPot_pot_et_PCB.3mf` : assemblage à importer comme nouveau projet dans Shapr3D. Deux objets de maillage séparés : pot original et carte complète.
- `SmartPot_pot_et_PCB.glb` : même assemblage avec les couleurs du PCB et des composants, pour la visualisation.
- `verification_assemblage.json` : position et encombrement calculés.

La carte de 30 × 60 mm est centrée sur le rectangle sous le pot. Les composants sont orientés vers l’extérieur. Le dos du PCB est à 5,205 mm de la face rectangulaire : les broches traversantes conservent au minimum 1 mm de jeu par rapport à cette face. Le pot et le PCB sources restent inchangés.

**L’intégration mécanique n’est pas prête à fabriquer.** Les connecteurs dépassent les pieds existants d’environ 16 mm. Un socle plus haut et des fixations restent à concevoir. Aucun support ni fixation n’a été ajouté. L’absence d’intersection avec la face de montage est vérifiée par les enveloppes des modèles ; ce contrôle ne constitue pas une validation mécanique complète.

Le 3MF est un assemblage de maillages, pas un fichier CAD à solides paramétriques. L’export STEP original de la carte est conservé dans `../PCB/SmartPot_assemble.step`. Dans le projet Shapr3D existant « Pot_fleur », la carte STEP a été importée, mais son placement n’a pas pu être réalisé à cause des interruptions d’accès à l’application. Utiliser ce nouvel assemblage pour obtenir la position préparée.
