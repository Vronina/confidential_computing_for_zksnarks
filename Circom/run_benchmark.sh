#!/bin/bash
for file in input_files_sha/*; do
#    echo $file
    if [ -f "$file" ]; then 
        parts=(${file//_/ })
        echo ${parts[3]}
        number=(${parts[3]//./ })
        echo ${number[0]}]
	    input_size=$[2**${number[0]}]
        echo $input_size 
        sed -i '65d' bytes.circom
        sed -i "65i component main = Main($input_size);" bytes.circom
        
        
        parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "python3 run_compile.py $file" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
        file_name_with_ending=`echo $file| cut -d'/' -f2-`
        file_name="${file_name_with_ending%%.*}"
        mv time_consumption_benchmark_compile.txt time_consumption_benchmark_compile_$file_name.txt
        mv process_top.txt cpu_usage_compile_$file_name.txt
        mv cpu_top.txt single_cpu_compile_$file_name.txt
        mv memory_top.txt memory_top_compile_$file_name.txt

        parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "python3 run_witness.py $file" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
        file_name_with_ending=`echo $file| cut -d'/' -f2-`
        file_name="${file_name_with_ending%%.*}"
        mv time_consumption_benchmark_witness.txt time_consumption_benchmark_witness_$file_name.txt
        mv process_top.txt cpu_usage_witness_$file_name.txt
        mv cpu_top.txt single_cpu_witness_$file_name.txt
        mv memory_top.txt memory_top_witness_$file_name.txt

        parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "python3 run_setup.py $file" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
        file_name_with_ending=`echo $file| cut -d'/' -f2-`
        file_name="${file_name_with_ending%%.*}"
        mv time_consumption_benchmark_setup.txt time_consumption_benchmark_setup_$file_name.txt
        mv process_top.txt cpu_usage_setup_$file_name.txt
        mv cpu_top.txt single_cpu_setup_$file_name.txt
        mv memory_top.txt memory_top_setup_$file_name.txt

        parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "python3 run_export.py $file" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
        file_name_with_ending=`echo $file| cut -d'/' -f2-`
        file_name="${file_name_with_ending%%.*}"
        mv time_consumption_benchmark_export.txt time_consumption_benchmark_export_$file_name.txt
        mv process_top.txt cpu_usage_export_$file_name.txt
        mv cpu_top.txt single_cpu_export_$file_name.txt
        mv memory_top.txt memory_top_export_$file_name.txt

        parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "python3 run_prove.py $file" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
        file_name_with_ending=`echo $file| cut -d'/' -f2-`
        file_name="${file_name_with_ending%%.*}"
        mv time_consumption_benchmark_prove.txt time_consumption_benchmark_prove_$file_name.txt
        mv process_top.txt cpu_usage_prove_$file_name.txt
        mv cpu_top.txt single_cpu_prove_$file_name.txt
        mv memory_top.txt memory_top_prove_$file_name.txt

    fi


done
