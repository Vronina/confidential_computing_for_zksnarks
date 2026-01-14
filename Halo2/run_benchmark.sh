#!/bin/bash
for file in ../input_files_sha/*; do
	echo $file
#	rm src/main.rs
#	cp main_setup.rs src/main.rs
	parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "INPUT_FILE=$file cargo bench --verbose 1> output.txt" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
	file_name_with_ending=`echo $file| cut -d'/' -f2-`
	file_name="${file_name_with_ending%%.*}"
	mv target/criterion/ criterion_setup_$file_name/
	mv output.txt output_setup_$file_name.txt
	mv process_top.txt process_top_setup_$file_name.txt
	mv cpu_top.txt cpu_top_setup_$file_name.txt
	mv memory_top.txt memory_top_setup_$file_name.txt

	rm src/main.rs
	cp main_prove.rs src/main.rs
	parallel -j2 --halt now,success=1 -j3 --halt now,success=1 -j4 --halt now,success=1 ::: "INPUT_FILE=$file cargo bench --verbose 1> output.txt" ./top_script.sh ./process_top_script.sh ./memory_top_script.sh
    file_name_with_ending=`echo $file| cut -d'/' -f2-`
    file_name="${file_name_with_ending%%.*}"
    mv target/criterion/ criterion_prove_$file_name/
    mv output.txt output_prove_$file_name.txt
    mv process_top.txt process_top_prove_$file_name.txt
    mv cpu_top.txt cpu_top_prove_$file_name.txt
    mv memory_top.txt memory_top_prove_$file_name.txt
done
