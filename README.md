
# How Many Lines of Code?

This script counts the total lines of code in a directory, breaking it down by file type, and provides a report of the results. It's optimized for performance with parallel processing and provides detailed statistics on disk usage and time taken.

---

## How to Install

### macOS and Linux

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

---

## How to Setup an Alias

To make the script easier to run, you can create a custom alias for it in your Zsh shell. You can name the alias anything you like, but we suggest `hml` or `howmanylines`.

1. Open your Zsh configuration file (`.zshrc`) in a text editor:

   ```bash
   nano ~/.zshrc
   ```

2. Add the following line to create an alias for the script:

   ```bash
   alias hml='/path/to/HowManyLines.sh'
   ```

3. Save and exit the file, then reload your Zsh configuration:

   ```bash
   source ~/.zshrc
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
       ...
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
