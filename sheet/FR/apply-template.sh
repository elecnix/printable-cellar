#!/bin/bash

rm -f content.xml
unzip printable-cellar-legal-fr.odg content.xml

function replace() {
  sed -i "s/\$nom/$1/;s/\$cepage/$2/;s/\$pays/$3/;s/\$millesime/$4/;s/\$boire/$5/;s/\$prix/$6/;s/\$temperature/$7/;s/\$accords/$8/;s/\$alcool/$9/;s/\$paid/${10}/;s/\$degustation/${11}/" content.xml
}
replace "Cono sur Reserva" "Pinot noir" "Chili" "2012" "2020" "15,95" "15-16" "asdf" "12,5" "100" "Vin arborant une couleur rouge violacé plutôt profond. Nez assez puissant qui s'ouvre sur des parfums de violette, de fruits noirs et d'épices. Ce rouge possède une agréable fraîcheur et est muni de tannins fermes. Il offre une bouche souple qui s'estompe dans une finale assez persistante."
replace "Cono sur Reserva" "Pinot noir" "Chili" "2012" "2020" "15,95" "15-16" "asdf" "12,5" "100" "Délicieux"
replace "Cono sur Reserva" "Pinot noir" "Chili" "2012" "2020" "15,95" "15-16" "asdf" "12,5" "100" "Délicieux"

replace "Lindeman's Bin 50" "Shiraz" "Australie Méridionale" "2012" "2016" "13,20" "16-18" "asdf" "12,5" "100", "Délicieux Délicieux Délicieux Délicieux Délicieux Délicieux"
replace "Lindeman's Bin 50" "Shiraz" "Australie Méridionale" "2012" "2016" "13,20" "16-18" "asdf" "12,5" "100", "Délicieux"

replace "Lindeman's Bin 99" "Pinot noir" "Australie Méridionale" "2012" "2014" "13,95" "16-17" "asdf" "12,5" "100", "Délicieux"
replace "Lindeman's Bin 99" "Pinot noir" "Australie Méridionale" "2012" "2014" "13,95" "16-17" "asdf" "12,5" "100", "Délicieux Délicieux Délicieux Délicieux Délicieux Délicieux"

replace "Domaine de Gournier Cuvée prestige" "?" "France, Pays d'Oc" "2012" "2017" "15,25" "15-17" "asdf" "12,5" "100", "Délicieux"
replace "Domaine de Gournier Cuvée prestige" "?" "France, Pays d'Oc" "2012" "2017" "15,25" "15-17" "asdf" "12,5" "100", "Délicieux Délicieux Délicieux Délicieux Délicieux Délicieux"

cp printable-cellar-legal-fr.odg feuille1.odg
zip -r feuille1.odg content.xml

