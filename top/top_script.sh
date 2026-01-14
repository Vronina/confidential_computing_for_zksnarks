#!/bin/bash
touch cpu_top.txt
touch output2.txt
while true; do
#        top -d 0.01 -b -w 512 -n 1 | tee -a output2.txt
#        sed -n '1,45p' output2.txt >> cpu_top.txt
#        rm output2.txt
	(top -b -w 512 -n 1 | sponge output2.txt )
	(sed -n "1,40p" output2.txt >> cpu_top.txt)
	#sed '/^KiB/,/^\top/{/^KiB/!{/^\top/!d}}' cpu_top.txt
#	sed -i '/^KiB/,/^top/ { /^KiB/!{/^top/!d} }' cpu_top.txt
#	wait
        sleep 0.1
done
