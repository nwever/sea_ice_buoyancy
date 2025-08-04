mkdir -p postprocessed
for f in ../simulations/*/output/*pro
do
	sim=$(basename "$f" .pro)
	echo "Processing: ${sim} [${f}]"

	awk -F, -f extract_interfaces.awk ${f} > postprocessed/${sim}.txt
done

mkdir -p postprocessed_advanced_buoyancy_model
for f in ../simulations/*/output_advanced_buoyancy_model/*pro
do
	sim=$(basename "$f" .pro)
	echo "Processing: ${sim} [${f}]"

	awk -F, -f extract_interfaces.awk ${f} > postprocessed_advanced_buoyancy_model/${sim}.txt
done
