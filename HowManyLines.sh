#!/bin/zsh

# Function to print a colorful banner
print_banner() {
    echo "\033[1;35m"
    echo "====================================================="
    echo "               How Many Lines of Code?               "
    echo "====================================================="
    echo "\033[0m"
}

# Default excluded directories (e.g. node_modules)
EXCLUDED_DIRS="node_modules"

# Color codes for output
COLOR_RESET="\033[0m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_BLUE="\033[0;34m"
COLOR_MAGENTA="\033[0;35m"

# Argument flags
INCLUDE_HIDDEN=false
CUSTOM_EXCLUDES=()

# Detect OS type (Linux or macOS)
if [[ "$(uname)" == "Darwin" ]]; then
    OS_TYPE="macOS"
    STAT_CMD=("stat" "-f" "%z")  # macOS stat command
elif [[ "$(uname)" == "Linux" ]]; then
    OS_TYPE="Linux"
    STAT_CMD=("stat" "--format=%s")  # Linux (GNU) stat command
else
    echo "Unsupported OS. Exiting."
    exit 1
fi

# Handle command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --include-hidden)
            INCLUDE_HIDDEN=true
            shift
            ;;
        --exclude)
            CUSTOM_EXCLUDES+=("$2")
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Combine default excludes with custom excludes
EXCLUDE_PATTERN="(${EXCLUDED_DIRS}|$(IFS=\|; echo "${CUSTOM_EXCLUDES[*]}"))"

# Total counters
TOTAL_FILES=0
TOTAL_LINES=0
TOTAL_SIZE=0

# Function to count lines of code by file extension
count_lines_by_extension() {
    local extension="$1"
    local description="$2"

    echo "Processing $description files..."  # User feedback

    # Find files, excluding the specified directories
    if [[ "$INCLUDE_HIDDEN" == true ]]; then
        files=($(find . -type f \( -name "*.$extension" \) -not -path "*/$EXCLUDE_PATTERN/*"))
    else
        files=($(find . -type f \( -name "*.$extension" \) -not -path "*/$EXCLUDE_PATTERN/*" -not -path "*/.*"))
    fi

    if [[ ${#files[@]} -gt 0 ]]; then
        file_count=${#files[@]}
        total_lines=0
        size=0
        for file in "${files[@]}"; do
            file_lines=$(wc -l < "$file")
            file_size=$("${STAT_CMD[@]}" "$file")  # Corrected stat command
            total_lines=$((total_lines + file_lines))
            size=$((size + file_size))
        done

        TOTAL_FILES=$((TOTAL_FILES + file_count))
        TOTAL_LINES=$((TOTAL_LINES + total_lines))
        TOTAL_SIZE=$((TOTAL_SIZE + size))

        printf "%-15s %-10d %-10d %-10s\n" "$description" "$file_count" "$total_lines" "$(numfmt --to=iec $size)"
    fi
}

# Main function to calculate and display the results
analyze_code() {
    print_banner
    echo "Generating report on $OS_TYPE... Please wait."  # User feedback
    sleep 1  # Simulate delay for user feedback

    echo "Counting lines of code by language:"
    echo "\033[1;34m=====================================\033[0m"
    printf "%-15s %-10s %-10s %-10s\n" "Language" "Files" "Lines" "Size"
    echo "\033[1;34m=====================================\033[0m"

    # Count lines for common languages
    count_lines_by_extension "sh" "Shell"
    count_lines_by_extension "py" "Python"
    count_lines_by_extension "js" "JavaScript"
    count_lines_by_extension "ts" "TypeScript"
    count_lines_by_extension "html" "HTML"
    count_lines_by_extension "css" "CSS"
    count_lines_by_extension "rb" "Ruby"
    count_lines_by_extension "cpp" "C++"
    count_lines_by_extension "c" "C"
    count_lines_by_extension "java" "Java"
    count_lines_by_extension "go" "Go"

    echo "\033[1;34m=====================================\033[0m"
    echo "\033[1;32mTotal Files Analyzed: $TOTAL_FILES\033[0m"
    echo "\033[1;32mTotal Lines of Code: $TOTAL_LINES\033[0m"
    echo "\033[1;32mTotal Disk Usage: $(numfmt --to=iec $TOTAL_SIZE)\033[0m"
}

# Start the analysis
analyze_code
