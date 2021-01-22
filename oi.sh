#!/bin/bash

# Default configuration
time_limit=5 # Unit: second
memory_limit=512 # Unit: MB
compiler="g++ -lm -O2 -std=c++11"
judger="diff"
testcases=31

# Read user configuation
if [ -e ~/.ya ]; then
	. ~/.ya
fi

# Open workspace
dir=$GEDIT_CURRENT_DOCUMENT_DIR
cd $dir

# Read workspace configuation
if [ -e .ya ]; then
	. .ya
fi

# Get current file
cppfile=$GEDIT_CURRENT_DOCUMENT_NAME
exefile=${cppfile%.*}

# Read file configuation
if [ -e $exefile.ya ]; then
	. $exefile.ya
fi

# Compile
$compiler 2> $exefile.yalog $cppfile -o $exefile 

if test $? -eq 0; then
	# Output compile warnings
	printf "COMPILE WARNINGS\n────────────────────────\n"
	cat $exefile.yalog
	printf "\n\n\n\n\n\n\n\n"
	
	# Output judge results
	printf "JUDGE RESULTS\n────────────────────────\n"
	printf "       #  STATUS    TIME\n"
	for((i=0;i<=testcases;++i))
	do
		if [ -e $i.in ]; then
			# Let the time limit be a little larger to distinguish TLE from RE
			ulimit -t $[time_limit+1]
			
			# Set the memory limit
			ulimit -m $[memory_limit*1024]
			
			# Test the time and exit code of the program
			ts=$(date +%s%N)
			\time -o $exefile$i.yalog -f "#%x" $dir/$exefile < $i.in > $exefile$i.out 2> $exefile$i.err
			tt=$((($(date +%s%N) - $ts)/1000000))
			ret=$(cat $exefile$i.yalog|awk -F# '{print $2}')
			
			# Check TLE
			if test $tt -le $[time_limit*1000]; then
				# Check RE(exitcode is non-zero)
				if test $ret -eq 0; then
					# Check if the answer is correct
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
	# Output compile errors
	printf "COMPILE ERROR!\n────────────────────────\n"
	cat $exefile.yalog
fi
