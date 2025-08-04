fullpath_snowpack=$(which snowpack)
if [[ -z "${fullpath_snowpack}" ]]; then
	echo "ERROR: cannot find snowpack binary. Make sure \$PATH is set correctly to contain a path to the snowpack binary." >&2
	exit 1
fi

> to_run.lst
for floe in 503 506 517
do
	for inp in IMB AVG
	do
		for test in dflt advanced_buoyancy
		do
			if [[ "${test}" == "dflt" ]]; then
				suffix=""
				mkdir -p snowpack_sim_${floe}/output/
			elif [[ "${test}" == "advanced_buoyancy" ]]; then
				suffix="advanced_buoyancy"
				echo "IMPORT_BEFORE = io_PS81-${inp}${floe}.ini" > snowpack_sim_${floe}/io_PS81-${inp}${floe}${suffix}.ini
				echo "IMPORT_AFTER  = ../io_test_advanced_buoyancy.ini" >> snowpack_sim_${floe}/io_PS81-${inp}${floe}${suffix}.ini
				mkdir -p snowpack_sim_${floe}/output_advanced_buoyancy_model/
			fi
			echo "pushd snowpack_sim_${floe}; ${fullpath_snowpack} -c io_PS81-${inp}${floe}${suffix}.ini -e NOW > ${inp}${floe}${suffix}.log 2>&1; popd" >> to_run.lst
		done
	done
done

