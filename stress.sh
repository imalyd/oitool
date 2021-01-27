#!/bin/bash

# Default configuration
time_limit=5 # Unit: second
memory_limit=512 # Unit: MB
program="a"
std="f"
gen="g"
judger="diff <out> <ans> -w -B -q &> /dev/null"

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

# Testcase counter
i=0

printf "JUDGE RESULTS\n────────────────────────\n"
while :
do
	# Run the tested programs
	input=$program.yain
	output=$program.yaout
	answer=$std.yaout

	# Set the time limit
	ulimit -t $[time_limit]
	
	# Set the memory limit
	ulimit -m $[memory_limit*1024]
	./$gen > $input 2> $gen.s.yaerr
	./$std < $input > $answer 2> $std.s.yaerr
	./$program < $input > $output 2> $program.s.yaerr
	
	# Check if the answer is correct
	judge_command=$(echo $judger|sed "s/<in>/$input/"|sed "s/<out>/$output/"|sed "s/<ans>/$answer/"|sed "s/<err>/$program.s.yainfo/")
	eval $judge_command
	
	# Output info
	if [ $? -ne 0 ]; then
		printf "Testcase #%08d: WA\n" $i
		if [ -e $program.s.yainfo ]; then
			printf "\n\n\n\n\n\n\n\n"
			printf "JUDGE INFO\n────────────────────────\n"
			cat $program.s.yainfo
		fi
		break
	fi
	
	# Increase testcase counter
	i=$[i+1]
done
