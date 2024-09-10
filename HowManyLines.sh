#!/bin/zsh

# Author: Robert Havelaar (https://RobertHavelaar.dev)
# GitHub: https://github.com/EastTexasElectronics/HowManyLines

print_banner() {
    echo "\033[1;35m"
    echo "====================================================="
    echo "               How Many Lines of Code?               "
    echo "        Created by: \033[1;36mhttps://RobertHavelaar.dev\033[1;35m          "
    echo "====================================================="
    echo "\033[0m"
}

# Default excluded directories
EXCLUDED_DIRS="node_modules" # Add your own exclusions here (e.g. CUSTOM_EXCLUDES=("node_modules" "vendor"))

# Color codes for output can be changed to your liking
COLOR_RESET="\033[0m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_BLUE="\033[0;34m"
COLOR_MAGENTA="\033[0;35m"

# Argument flags
INCLUDE_HIDDEN=false
CUSTOM_EXCLUDES=() # Do not add your exclusions here this is where the script will add your exclusions if you use the -e or --exclude flag

# Error handling
ERROR_LOG=$(mktemp)
trap "rm -f $ERROR_LOG" EXIT

# Start time for performance measurement
START_TIME=$(date +%s%N)

# Detect OS type (Linux or macOS)
if [[ "$(uname)" == "Darwin" ]]; then
    OS_TYPE="macOS"
    STAT_CMD=("stat" "-f" "%z") # macOS stat command
elif [[ "$(uname)" == "Linux" ]]; then
    OS_TYPE="Linux"
    STAT_CMD=("stat" "--format=%s") # Linux (GNU) stat command
else
    echo "Unsupported OS. Exiting. Bye :("
    exit 1
fi

# Function to display help menu
show_help() {
    echo "${COLOR_BOLD}HowManyLines - A script to count lines of code across multiple languages${COLOR_RESET}"
    echo ""
    echo "Usage: ./HowManyLines.sh [OPTIONS]"
    echo "Options:"
    echo "  -h, --help                Show this help message and exit"
    echo "  -e, --exclude <dir>       Exclude specific directories or files"
    echo "  -ih, --include-hidden     Include hidden files and directories"
    echo "  -ia, --include-all        Include all files and directories, overrides default excludes"
    echo ""
    echo "${COLOR_MAGENTA}💖 Don't forget to give the project a star on GitHub: ${COLOR_GREEN}https://github.com/EastTexasElectronics/HowManyLines 💖${COLOR_RESET}" # You can remove the final message if you desire by removing this line
}

# Handle command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
        show_help
        exit 0
        ;;
    -e | --exclude)
        CUSTOM_EXCLUDES+=("$2")
        shift 2
        ;;
    -ih | --include-hidden)
        INCLUDE_HIDDEN=true
        shift
        ;;
    -ia | --include-all)
        CUSTOM_EXCLUDES=() # Disable default excludes if --include-all is set
        shift
        ;;
    *)
        echo "${COLOR_RED}Unknown option: $1${COLOR_RESET}"
        exit 1
        ;;
    esac
done

# Combine default excludes with custom excludes
EXCLUDE_PATTERN="(${EXCLUDED_DIRS}|$(
    IFS=\|
    echo "${CUSTOM_EXCLUDES[*]}"
))"

# Temporary files for storing totals
TEMP_FILE_LINES=$(mktemp)
TEMP_FILE_SIZE=$(mktemp)
TEMP_FILE_FILES=$(mktemp)

# Initialize total counters to 0
echo "0" >$TEMP_FILE_LINES
echo "0" >$TEMP_FILE_SIZE
echo "0" >$TEMP_FILE_FILES

# Function to convert bytes to human-readable format (KB, MB, GB, TB)
convert_size() {
    local size=$1
    if [[ $size -ge 1099511627776 ]]; then
        echo "$((size / 1099511627776)) TB"
    elif [[ $size -ge 1073741824 ]]; then
        echo "$((size / 1073741824)) GB"
    elif [[ $size -ge 1048576 ]]; then
        echo "$((size / 1048576)) MB"
    elif [[ $size -ge 1024 ]]; then
        echo "$((size / 1024)) KB"
    else
        echo "$size B"
    fi
}

# Function to log errors
log_error() {
    local message=$1
    echo "${COLOR_RED}[ERROR] $message${COLOR_RESET}" >>$ERROR_LOG
}

# This is the core function that counts lines, files, and sizes for each file type
# You can modify the parallelization settings (e.g., -P 8 -n 10) to adjust performance
count_lines_by_extension() {
    local extension="$1"
    local description="$2"

    {
        if [[ "$INCLUDE_HIDDEN" == true ]]; then
            files=($(find . -type f \( -name "*.$extension" \) -not -path "*/$EXCLUDE_PATTERN/*" 2>>$ERROR_LOG))
        else
            files=($(find . -type f \( -name "*.$extension" \) -not -path "*/$EXCLUDE_PATTERN/*" -not -path "*/.*" 2>>$ERROR_LOG))
        fi

        if [[ ${#files[@]} -gt 0 ]]; then
            file_count=${#files[@]}
            total_lines=0
            size=0

            # Parallel processing for files with xargs using multiple CPU cores
            # Note: You can adjust the -P and -n values to optimize performance for your system
            # -P controls the number of parallel processes, and -n is the number of arguments per command
            total_lines=$(printf "%s\n" "${files[@]}" | xargs -P 8 -n 10 wc -l 2>>$ERROR_LOG | awk '{total += $1} END {print total}')
            size=$(printf "%s\n" "${files[@]}" | xargs -P 8 -n 10 "${STAT_CMD[@]}" 2>>$ERROR_LOG | awk '{total += $1} END {print total}')

            # Update global totals
            echo $(($(cat $TEMP_FILE_FILES) + file_count)) >$TEMP_FILE_FILES
            echo $(($(cat $TEMP_FILE_LINES) + total_lines)) >$TEMP_FILE_LINES
            echo $(($(cat $TEMP_FILE_SIZE) + size)) >$TEMP_FILE_SIZE

            # Print the result
            printf "%-15s %-10d %-10d %-10s\n" "$description" "$file_count" "$total_lines" "$(convert_size $size)"
        fi
    } 2>>$ERROR_LOG
}

# Main function to calculate and display the results
analyze_code() {
    print_banner
    echo "Generating report on $OS_TYPE... Please wait, I'm working on it."

    echo "\033[1;34m=====================================\033[0m"
    printf "%-15s %-10s %-10s %-10s\n" "Language" "Files" "Lines" "Size"
    echo "\033[1;34m=====================================\033[0m"

    # List of common file extensions by language, framework, ORM, and documents
    # Users can modify this list to add or remove file types as needed
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

    # Loop through all extensions
    for ext_pair in "${extensions[@]}"; do
        extension="${ext_pair%%:*}"
        description="${ext_pair##*:}"
        count_lines_by_extension "$extension" "$description"
    done

    # Wait for all background jobs to finish
    wait

    # Calculate final totals
    TOTAL_FILES=$(cat $TEMP_FILE_FILES)
    TOTAL_LINES=$(cat $TEMP_FILE_LINES)
    TOTAL_SIZE=$(cat $TEMP_FILE_SIZE)
    END_TIME=$(date +%s%N)
    ELAPSED_TIME=$({ time analyze_code_internal; } 2>&1 | grep real | awk '{print $2}')

    # Display the final results
    echo "\033[1;34m=====================================\033[0m"
    echo "\033[1;32mTotal Files Analyzed: $TOTAL_FILES\033[0m"
    echo "\033[1;32mTotal Lines of Code: $TOTAL_LINES\033[0m"
    echo "\033[1;32mTotal Disk Usage: $(convert_size $TOTAL_SIZE)\033[0m"
    echo "\033[1;32mTotal Time Taken: $ELAPSED_TIME milliseconds\033[0m"

    # Display errors summary if any
    if [[ -s $ERROR_LOG ]]; then
        echo "\033[1;31mErrors encountered during execution:\033[0m"
        cat $ERROR_LOG
    else
        echo "\033[1;32mNo errors encountered.\033[0m"
    fi

    # Clean up temp files
    rm $TEMP_FILE_LINES $TEMP_FILE_SIZE $TEMP_FILE_FILES $ERROR_LOG
    echo "\033[1;32mTemporary files have been cleaned up.\033[0m"

    # GitHub link at the end
    echo "${COLOR_MAGENTA}Don't forget to give the project a star on GitHub: ${COLOR_GREEN}https://github.com/EastTexasElectronics/HowManyLines 💖${COLOR_RESET}"
}

# Start the analysis
analyze_code
