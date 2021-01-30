#!/bin/bash

# Default configuration
time_limit=5 # Unit: second
memory_limit=512 # Unit: MB
compiler="g++ <file> -o <exe> -lm -O2 -std=c++11 &> <err>"
judger="diff <out> <ans> -w -B -q &> /dev/null"
testcases=31
input_file="<i>.in"
output_file="<exe><i>.out"
answer_file="<i>.ans"

# Read user configuration
if [ -e ~/.ya ]; then
	. ~/.ya
fi

# Open workspace
dir=$GEDIT_CURRENT_DOCUMENT_DIR
cd $dir

# Read workspace configuration
if [ -e .ya ]; then
	. .ya
fi

# Get current file
file=$GEDIT_CURRENT_DOCUMENT_NAME
exefile=${file%.*}

# Read file configuration
if [ -e $exefile.ya ]; then
	. $exefile.ya
fi

# Compile
compile_command=$(echo $compiler|sed "s/<file>/$file/"|sed "s/<exe>/$exefile/"|sed "s/<err>/$exefile.yainfo/")
eval $compile_command

if [ $? -eq 0 ]; then
	# Output compile warnings
	printf "COMPILE WARNINGS\n────────────────────────\n"
	cat $exefile.yainfo
	printf "\n"
	
	# Output judge results
	printf "JUDGE RESULTS\n────────────────────────\n"
	printf "       #  STATUS    TIME\n"
	for((i=0;i<=testcases;++i))
	do
		input=$(echo $input_file|sed "s/<i>/$i/"|sed "s/<exe>/$exefile/")
		output=$(echo $output_file|sed "s/<i>/$i/"|sed "s/<exe>/$exefile/")
		answer=$(echo $answer_file|sed "s/<i>/$i/"|sed "s/<exe>/$exefile/")
		if [ -e $input ]; then
			
			# Let the time limit be a little larger to distinguish TLE from RE
			ulimit -t $[time_limit+1]
			
			# Set the memory limit
			ulimit -m $[memory_limit*1024]
			
			# Test the time and exit code of the program
			ts=$(date +%s%N)
			\time -o $exefile.$i.yalog -f "#%x#" ./$exefile < $input > $output 2> $exefile.$i.yaerr
			tt=$((($(date +%s%N) - $ts)/1000000))
			ret=$(cat $exefile.$i.yalog|awk -F# '{print $2}')
			
			# Check TLE
			if [ $tt -le $[time_limit*1000] ]; then
				
				# Check RE (i.e. exitcode is non-zero)
				if [ $ret -eq 0 ]; then
					
					# Check if the answer is correct
					judge_command=$(echo $judger|sed "s/<in>/$input/"|sed "s/<out>/$output/"|sed "s/<ans>/$answer/"|sed "s/<err>/$exefile.$i.yainfo/")
					eval $judge_command
					if [ $? -eq 0 ]; then
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
	
	# Output judge info
	if [ "$judger" ]; then
		printf "\n"
		printf "JUDGE INFO\n────────────────────────\n"
		for((i=0;i<=testcases;++i))
		do
			if [ -s $exefile.$i.yainfo ]; then
				printf "Testcase #$i:\n"
				cat $exefile.$i.yainfo
				printf "\n"
			fi
		done
	fi
else
	# Output compile errors
	printf "COMPILE ERROR!\n────────────────────────\n"
	cat $exefile.yainfo
fi
