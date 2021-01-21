<p align="center"><img src="oitool.png"></p>

<h1 align="center">OI Tool(v1.0)</h1>

<p align="center">A gedit plugin which can test OI codes.</p>

# Documentation

## Requirements

- Operating system: Linux
- Do **NOT** put files with extension `ya` or `yalog` in the same folder with your code.

## Installation

1. Open Gedit and enable the plugin "external tools".
   
   ![0.png](0.png)
2. Manage "external tools".
   
   ![1.png](1.png)
3. Insert the code from `oi.sh` and config the new tool as shown in the picture.
   
   ![2.png](2.png)

## Usage

1. Open your code. Let its name be `<name>.<ext>`.
2. Put your testcases in `<i>.in` and `<i>.ans`. (`<i>` is the ID of the testcases, ranging in [0,testcases])
3. Press `F5`.
4. You can see the results in the panel below.
   Judge results are: `AC`(Answer correct), `WA`(Wrong answer), `TLE`(Time limit exceeded) and `RE`(Runtime error).
   Your `stdout` and `stderr` are directed to `<name><i>.out` and `<name><i>.err` respectively.

## Configuration

### User configuration

The configuration file should be named `.ya` in your user folder. 

### Workspace configuration

The configuration file should be named `.ya` in the workspace folder. 

### Settings format

The configuration file should be like:

```sh
time_limit=5 # Time limit of your code. Unit: second
memory_limit=512 # Memory limit of your code. Unit: MB
compiler="g++ -lm -O2 -std=c++11" # Compiler of your code together with the arguments.
judger="diff" # Special judge of your code. 
              # Usage:
              # - Argument #1: output file.
              # - Argument #2: answer file.
              #   You can find the input file from the answer file's name.
              # - Return 0 if AC and non-zero if WA.
testcases=31 # Maximum ID of testcases
```

If there is no configuration file, then the default setting will be used.