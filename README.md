
# How Many Lines of Code?

This script counts the total lines of code in a directory, breaking it down by file type, and provides a report of the results. It's optimized for performance with parallel processing and provides detailed statistics on disk usage and time taken.

The script is written in Zsh, but it works on both Zsh and Bash. We recommend using Zsh if possible, but feel free to use Bash if that's your preference.

---

## How to Install

### macOS and Linux (Zsh)

1. Make sure you have Zsh installed:

   ```bash
   zsh --version
   ```

   If it's not installed, install it using your package manager:

   - **macOS**: Zsh is included by default. If not, you can install it using:

     ```bash
     brew install zsh
     ```

   - **Linux**: Install Zsh using:

     ```bash
     sudo apt install zsh  # For Debian/Ubuntu
     sudo yum install zsh  # For Fedora/RedHat
     ```

2. Download or clone this repository:

   ```bash
   git clone https://github.com/EastTexasElectronics/HowManyLines.git
   ```

3. Make the script executable:

   ```bash
   chmod +x HowManyLines.sh
   ```

4. Run the script in your terminal:

   ```bash
   ./HowManyLines.sh [OPTIONS]
   ```

### Bash Users

1. If you're using Bash, you can modify the script slightly to make it more compatible. Open the script (`HowManyLines.sh`) in a text editor and change the first line from:

   ```bash
   #!/bin/zsh
   ```

   to:

   ```bash
   #!/bin/bash
   ```

2. After making the change, follow the same installation steps as above, but run it with Bash:

   ```bash
   ./HowManyLines.sh [OPTIONS]
   ```

---

## How to Setup an Alias

To make the script easier to run, you can create a custom alias for it in your Zsh or Bash shell. You can name the alias anything you like, but we suggest `hml` or `howmanylines`.

1. Open your shell configuration file (`.zshrc` for Zsh or `.bashrc` for Bash) in a text editor:

   ```bash
   vim ~/.zshrc  # For Zsh
   vim ~/.bashrc  # For Bash
   ```

2. Add the following line to create an alias for the script:

   ```bash
   alias hml='/path/to/HowManyLines.sh'
   ```

3. Save and exit the file, then reload your shell configuration:

   ```bash
   source ~/.zshrc  # For Zsh
   source ~/.bashrc  # For Bash
   ```

Now, you can run the script by simply typing `hml` or `howmanylines` in your terminal.

---

## How to Use

To run the script, use the following command:

```bash
./HowManyLines.sh [OPTIONS]
```

### Example

```bash
./HowManyLines.sh -e build -ih --parallelism 4
```

This example excludes the `build` directory, includes hidden files, and uses 4 CPU cores for parallel processing.

---

## Options

- `-h, --help`: Show the help message and exit.
- `-e, --exclude <dir>`: Exclude specific directories or files.
- `-ih, --include-hidden`: Include hidden files and directories.
- `-ia, --include-all`: Include all files and directories (overrides default excludes like `node_modules`).
- `--parallelism <n>`: Set the number of CPU cores to use (default is 8).

**Note**: By default, the script uses 8 CPU cores, but if your system has fewer cores, it will still run efficiently. If you have more cores and want to leverage additional processing power, feel free to increase the number in the `--parallelism` option.

---

## Customizing the Script

1. **Editing Exclusions**: The script excludes directories like `node_modules` by default, but you can add additional exclusions via the `-e` or `--exclude` flag. For example:

   ```bash
   ./HowManyLines.sh -e vendor -ih
   ```

   This will exclude the `vendor` directory.

2. **Modifying File Extensions**: The script scans specific file types by default, but you can modify the `extensions` array to add or remove file types. To do this:

   - Open the script in a text editor.
   - Find the `extensions` array and add or remove file types as needed.

   Example:

   ```bash
   extensions=(
        "sh:Shell"
        "py:Python"
        "js:JavaScript"
        "ts:TypeScript"
        "html:HTML"
        "css:CSS"
        "rb:Ruby"
        "cpp:C++"
        "c:C"
        "java:Java"
        "go:Go"
        "php:PHP"
        "cs:C#"
        "swift:Swift"
        "kt:Kotlin"
        "rs:Rust"
        "scala:Scala"
        "sql:SQL"
        "pl:Perl"
        "r:R"
        "hs:Haskell"
        "erl:Erlang"
        "ex:Elixir"
        "dart:Dart"
        "xml:XML"
        "json:JSON"
        "yaml:YAML"
        "md:Markdown"
        "txt:Text"
        "doc:Word"
        "docx:Word"
        "xls:Excel"
        "xlsx:Excel"
        "ppt:PPT"
        "pptx:PPTX"
        "pdf:PDF"
        "bat:Batch"
        "ini:INI"
        "conf:Config"
        "toml:TOML"
        "yml:YAML"
        "vue:Vue.js"
        "jsx:JSX"
        "tsx:TSX"
        "tf:Terraform"
        "dockerfile:Docker"
        "gemspec:GemSpec"
        "scss:SCSS"
        "sass:Sass"
        "less:LESS"
        "erb:ERB"
   )
   ```

---

## Performance Tuning

- **Parallel Processing**: The script supports parallel processing, allowing you to set the number of CPU cores to use via the `--parallelism` option. The default is 8 cores, but you can adjust this based on your machine's capabilities.

  Example:

  ```bash
  ./HowManyLines.sh --parallelism 4
  ```

- **Excluding Unnecessary Files**: By default, the script excludes `node_modules` and other large directories that may not contain relevant code. You can customize these exclusions or include all directories with the `--include-all` flag.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Support the Developer

If you find this script useful and would like to support its development, consider buying me a coffee:

[Buy Me a Coffee](https://buymeacoffee.com/rmhavelaar)

---

## Star the Project

If you find this script useful, please consider starring the project on GitHub!

💖 [GitHub Repository](https://github.com/EastTexasElectronics/HowManyLines)
