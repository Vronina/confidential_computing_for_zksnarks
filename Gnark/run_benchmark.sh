#!/bin/bash

export PATH=$PATH:/usr/local/go/bin


for file in input_files_sha/*; do
#    echo $file
    number=$(echo "$file" | sed -E 's|.*/input_(.*)\.txt|\1|')
    echo $number
    input_size=$[2**${number[0]}]
    echo $input_size
    sed -i '197d' sha_main_setup.go
	sed -i "197i \\\t hashes, preimages, err := Parse_file(\""$file"\")" sha_main_setup.go
	sed -i '25d' sha_main_setup.go
	sed -i "25i const PREIMAGE_SIZE = $input_size" sha_main_setup.go
	parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "go run sha_main_setup.go" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
	file_name_with_ending=`echo $file| cut -d'/' -f2-`
	file_name="${file_name_with_ending%%.*}"
	mv benchmark_times.txt benchmark_times_setup_$file_name.txt
	mv process_top.txt cpu_usage_setup_$file_name.txt
	mv cpu_top.txt single_cpu_setup_$file_name.txt
	mv memory_top.txt memory_top_setup_$file_name.txt


    sed -i '227d' sha_main_prove.go
	sed -i "227i \\\t hashes, preimages, err := Parse_file(\""$file"\")" sha_main_prove.go
	sed -i '25d' sha_main_prove.go
	sed -i "25i const PREIMAGE_SIZE = $input_size" sha_main_prove.go
	parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "go run sha_main_prove.go" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
	file_name_with_ending=`echo $file| cut -d'/' -f2-`
	file_name="${file_name_with_ending%%.*}"
	mv benchmark_times.txt benchmark_times_prove_$file_name.txt
	mv process_top.txt cpu_usage_prove_$file_name.txt
	mv cpu_top.txt single_cpu_top_prove_$file_name.txt
	mv memory_top.txt memory_top_prove_$file_name.txt
done
