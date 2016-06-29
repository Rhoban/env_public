ln -sf ../mowgly/mowgly.urdf sigmaban.urdf
ln -sf LeipzMowgly.xml LocalisationTest.xml
php forBench.php LocalisationTest.xml > ForBench.xml 
./Benchmarker ForBench.xml Logs/leipz1/ Logs/leipz2/ Logs/leipz3/ Logs/leipz4/ Logs/leipz5/ Logs/leipz_from_side/
