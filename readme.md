<p align="center"><img src="oitool.png"></p>

<h1 align="center">OI Tool</h1>

<p align="center">A gedit plugin which can test OI codes.</p>

# Features of OI Tool(v2.0)

- **Test your OI codes fast.**
- **Highly customizable**: almost all things of OI Tool can be customized.
- **Multiunctions**: support building, testing multiple testcases, and stress testing against another program.

# Requirements

- Operating system: Linux
- Do **NOT** put files with extension with prefix `ya` (such as `a.yaerr` and `f.yainfo`) in the same folder with your code.

# Installation

1. Enable the **plugin "external tools"** in "Preferences".

2. Click **"Manage External Tools"**.

3. Create **new tools** as follows. (Non-bold arguments are customizable.)
   -  Tools:
      | Name | Code |
      |---|---|
      | `OI Tool - Build and run testcases` | **From `oi.sh`** |
      | `OI Tool - Build` | **From `build.sh`** |
      | `OI Tool - Stress test` | **From `stress.sh`** |
   -  Settings:
      | Shortcut key | Save | Input | Output | Applicability |
      |---|---|---|---|--|
      | You define it | **Current Document** | **Nothing** | **Display in bottom pane** | Choose the languages you need |

# Configuration

### User configuration

The configuration file should be named `.ya` in your user folder. 

### Workspace configuration

The configuration file should be named `.ya` in the workspace folder. 

### File configuration

The configuration file should be named `<name>.ya` in the workspace folder. 

### Configuration format

The configuration file should be like:

```sh
key1 = value1
key2 = "value2" # String should be quoted in " "
...
keyn = valuen
# You can insert comments starting with "#" in the configuration file.
```

If there is no configuration file found, then the default setting will be used.

# OI Tool - Build and run testcases

## Usage

1. Open your source file `<name>.<ext>`. After building, the executable file will be named `<exe>`(`<exe>`=`<name>`).
2. Put your testcases in `<i>.in` and `<i>.ans`. (`<i>` is the ID of the testcases, ranging in [0,`<testcases>`])
3. Press the shortcut key you choose.
4. You can see the results in the panel below.
   Judge results are: `AC`(Answer correct), `WA`(Wrong answer), `TLE`(Time limit exceeded) and `RE`(Runtime error).
   Your `stdout` and `stderr` are redirected to `<exe><i>.out` and `<exe>.<i>.yaerr` respectively.

## Configuration

| Key | Type | Default Value | Description |
|:-:|:-:|:-:|:-:|
| `time_limit` | Integer | 5 | Time limit. Unit: second |
| `memory_limit` | Integer | 512 | Memory limit. Unit: MB |
| `compiler` | String | `g++ <file> -o <exe> -lm -O2 -std=c++11 &> <err>` | Compile command. `<file>`: source file. `<exe>`: executable file. `<err>`: compiler output file. |
| `judger` | String | `diff <out> <ans> -w -B -q &> /dev/null` | Judger of the output. `<in>`: input file. `<out>`: output file. `<ans>`: answer file. `<err>`: judger output file. |
| `input_file` | String | `<i>.in` | Input file. `<i>`: testcase ID. `<exe>`: executable file. |
| `output_file` | String | `<exe><i>.out` | Output file. `<i>`: testcase ID. `<exe>`: executable file. |
| `answer_file` | String | `<i>.ans` | Answer file. `<i>`: testcase ID. `<exe>`: executable file. |

# OI Tool - Build

It is similar to "OI Tool - Build and run testcases".

The only difference is that "OI Tool - Build" will only build the source file and it will not run testcases.

# OI Tool - Stress test

## Usage

1. Put your program's executable file `<program>`, standard program's executable file `<std>` and input generator's executable file `<gen>` in the workspace folder.
2. Press the shortcut key you choose.
3. The first generated data that caused a `WA` will be copied in `<program>.yain` and `<std>.yaout`.
   Your `stdout` and `stderr` are redirected to `<program>.yaout` and `<program>.yaerr` respectively.

## Configuration

| Key | Type | Default Value | Description |
|:-:|:-:|:-:|:-:|
| `program` | String | `a` | Your program's executable file. |
| `std` | String | `f` | Standard program's executable file. |
| `gen` | String | `g` | Input generator's executable file. |
| `judger` | String | `diff <out> <ans> -w -B -q &> /dev/null` | Judger of the output. `<in>`: input file. `<out>`: output file. `<ans>`: answer file. `<err>`: judger output file. |