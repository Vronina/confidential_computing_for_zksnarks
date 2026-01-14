#!/bin/bash
#input=$1
touch memory_top.txt
touch outputm.txt
i=1
while true; do
#        exec -a processtop top -d 0.01 -b -w 512 -n 1 | tee -a output_process.txt
#        sed -n '1,25p' output_process.txt >> process_top.txt
#        rm output_process.txt
	exec -a memorytop top -b -o RES -d 0.01 -w 512 -n 1 | sponge outputm.txt 
	sed -i "19i ---------------------------------"  outputm.txt
        sed -n "1,20p" outputm.txt | tee -a memory_top.txt
#	echo $i
#	(sed -n "1,20p" outputm.txt | sponge -a memory_top.txt)
#	FILESIZE=$(stat -c%s "memory_top.txt")
#	MAXSIZE=10000000
#	if (($FILESIZE > $MAXSIZE));then
#		mv memory_top.txt memory_top_$1_$i.txt#
#		touch memory_top.txt
		((i=i+1))
#        fi
#	sleep 0.1
done
