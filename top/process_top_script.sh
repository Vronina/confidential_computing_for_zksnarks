#!/bin/bash
#input=$1
touch process_top.txt
touch outputp.txt
i=1
while true; do
	exec -a processtop top -o %CPU -b -w 512 -n 1 | sponge outputp.txt
	sed -i "19i ---------------------------------"  outputp.txt
	sed -n "1,20p" outputp.txt | tee -a process_top.txt
#	(sed -n "1,20p" outputp.txt | sponge -a process_top.txt)
#	FILESIZE=$(stat -c%s "process_top.txt")
#	MAXSIZE=5000000
#	if (($FILESIZE > $MAXSIZE));then
#		mv process_top.txt process_top$1_$i.txt
#		touch process_top.txt
#		((i=i+1))
 #      fi
#	sleep 0.1
done
