ln -sf ../tom/tom.urdf sigmaban.urdf
ln -sf LeipzTom.xml LocalisationTest.xml
php forBench.php LocalisationTest.xml > ForBench.xml 
./Benchmarker ForBench.xml Logs/alphaBanCentreDuTerrain/ Logs/alphaBanDrible/ Logs/alphaBanDeplacement/ 
