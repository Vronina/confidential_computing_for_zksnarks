#!/bin/bash
export PATH=$PATH:/usr/local/go/bin

for file in input_files_sha/*; do
#    echo $file
    number=$(echo "$file" | sed -E 's|.*/input_(.*)\.txt|\1|')
    echo $number
    input_size=$[2**${number[0]}]
    echo $input_size
    sed -i '205d' sha_main_plonk_setup.go
	sed -i "205i \\\t hashes, preimages, err := Parse_file(\""$file"\")" sha_main_plonk_setup.go
	sed -i '30d' sha_main_plonk_setup.go
	sed -i "30i const PREIMAGE_SIZE = $input_size" sha_main_plonk_setup.go
	parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "go run sha_main_plonk_setup.go" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
	file_name_with_ending=`echo $file| cut -d'/' -f2-`
	file_name="${file_name_with_ending%%.*}"
	#echo $file_name

	mv benchmark_times.txt benchmark_times_plonk_setup_$file_name.txt
	mv process_top.txt process_top_plonk_setup_$file_name.txt
	mv cpu_top.txt cpu_top_plonk_setup_$file_name.txt
	mv memory_top.txt memory_top_plonk_setup_$file_name.txt


    sed -i '234d' sha_main_plonk_prove.go
	sed -i "234i \\\t hashes, preimages, err := Parse_file(\""$file"\")" sha_main_plonk_prove.go
	sed -i '27d' sha_main_plonk_prove.go
	sed -i "27i const PREIMAGE_SIZE = $input_size" sha_main_plonk_prove.go
	parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "go run sha_main_plonk_prove.go" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
	file_name_with_ending=`echo $file| cut -d'/' -f2-`
	file_name="${file_name_with_ending%%.*}"

	mv benchmark_times.txt benchmark_times_plonk_prove_$file_name.txt
	mv process_top.txt process_top_plonk_prove_$file_name.txt
	mv cpu_top.txt cpu_top_plonk_prove_$file_name.txt
	mv memory_top.txt memory_top_plonk_prove_$file_name.txt
done