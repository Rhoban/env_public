echo "Generating strategy for Sigmaban"
./KickStrategy -j -x ../common/kicks/SigmabanKicks.xml > ../common/kickStrategy_v1.json
echo "Generating strategy for Sigmaban V2"
./KickStrategy -j -x ../common/kicks/SigmabanV2Kicks.xml > ../common/kickStrategy_v2.json
