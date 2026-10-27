# V4 — export du raccord RF physique provisoire

Archive ODB++ de la carte routée, quatre couches, nouvelle branche 1 x 7 mm et raccord physique ajouté jusqu'à son extrémité inférieure. Ce cuivre diffère du modèle CST source qui utilisait un port dans le gap inférieur.

Importer l'archive comme nouvelle géométrie dans CST. Ne pas superposer l'ancien modèle. Vérifier les perçages métallisés, l'empilage et les réseaux. Empilage provisoire : cuivre 0,035 / FR4 0,127 / cuivre 0,035 / FR4 0,406 / cuivre 0,035 / FR4 0,127 / cuivre 0,035 mm, FR4 er=4,3, tan delta=0,02. Les propriétés réelles doivent être obtenues du fabricant.

Excitation à U1.12 (X=57,925, Y=-71,965 dans l'ODB natif) vers GND In1 sous cette pastille. Z doit être vérifié dans l'import. Représenter les 0 ohm R4/R6 par leurs modèles/liaisons physiques. C6/L1/J3 sont DNP. Ne pas remettre le port long au milieu de la nouvelle piste conductrice : cela changerait ou court-circuiterait l'excitation.

Le cuivre des autres composants ne fournit pas automatiquement leurs modèles électriques. Vérifier le maillage et la convergence, S11 autour de 868 MHz, rendement et gain. L'archive n'inclut aucun réglage de port/solveur et n'a pas été importée ni simulée dans CST ici. Aucun résultat RF de la V4 n'est validé.
