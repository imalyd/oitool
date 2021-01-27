#!/bin/bash

# Default configuration
compiler="g++ <file> -o <exe> -lm -O2 -std=c++11 &> <err>"

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
else
	# Output compile errors
	printf "COMPILE ERROR!\n────────────────────────\n"
	cat $exefile.yainfo
fi
