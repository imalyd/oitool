#!/bin/bash
time_limit=5 # Unit: second
memory_limit=512 # Unit: MB
compiler="g++ -lm -O2 -std=c++11"
judger="diff"
testcases=31

dir=$GEDIT_CURRENT_DOCUMENT_DIR
cd $dir
if [ -e .ya ]; then
	. .ya
fi

cppfile=$GEDIT_CURRENT_DOCUMENT_NAME
exefile=${cppfile%.*}
$compiler 2> $exefile.yalog $cppfile -o $exefile 
if test $? -eq 0; then
	printf "COMPILE WARNINGS\n────────────────────────\n"
	cat $exefile.yalog
	printf "\n\n\n\n\n\n\n\n"
	printf "JUDGE RESULTS\n────────────────────────\n"
	printf "       #  STATUS    TIME\n"
	for((i=0;i<=testcases;++i))
	do
		if [ -e $i.in ]; then
			ulimit -t $[time_limit+1]
			ulimit -m 524288
			ts=$(date +%s%N)
			\time -o $exefile$i.yalog -f "#%x" $dir/$exefile < $i.in > $exefile$i.out 2> $exefile$i.err
			tt=$((($(date +%s%N) - $ts)/1000000))
			ret=$(cat $exefile$i.yalog|awk -F# '{print $2}')
			if test $tt -le $[time_limit*1000]; then
				if test $ret -eq 0; then
					$judger $exefile$i.out $i.ans -w -B -q &>/dev/null
					judge_ret=$?
					if test $judge_ret -eq 0; then
						printf "%8d      AC%6sms\n" $i $tt
					else
						printf "%8d      WA%6sms\n" $i $tt
					fi
				else
					printf "%8d      RE     N/A\n" $i
				fi
			else
				printf "%8d     TLE     N/A\n" $i
			fi
		fi
	done
else
	printf "COMPILE ERROR!\n────────────────────────\n"
	cat $exefile.yalog
fi
