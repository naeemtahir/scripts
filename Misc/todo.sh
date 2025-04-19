#!/bin/bash

####################################################################################
# Command-line Task Manager. Displays or edits task list file in following format: #
#                                                                                  #
# - [ ] ToDo Task 2                                                                #
# - [ ] ToDo Task 3                                                                #
# - [ ] ToDo Task 4                                                                #
#                                                                                  #
# ---                                                                              #
#                                                                                  #
# - [x] Completed Task 1                                                           #
####################################################################################

# https://misc.flogisoft.com/bash/tip_colors_and_formatting
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NO_COLOR='\e[0m'
LIGHT_CYAN='\e[96m'
WHITE='\e[97m'
BLINK='\e[5m'

TASK_FILE="$TODO"

display_header() {
    printf "${GREEN} _____ ___  ____   ___       ${NO_COLOR}\n"
    printf "${GREEN}|_   _/ _ \|  _ \ / _ \ ___  ${NO_COLOR}\n"
    printf "${GREEN}  | || | | | | | | | | / __| ${NO_COLOR}\n"
    printf "${GREEN}  | || |_| | |_| | |_| \__ \ ${NO_COLOR}\n"
    printf "${GREEN}  |_| \___/|____/ \___/|___/ ${NO_COLOR}\n"
    printf "\n"
}

display_footer() {
    printf "\n"
    printf "${LIGHT_CYAN}Pass -e or -g to edit TODOs${NO_COLOR}\n"
}

# Function to display incomplete tasks
display_incomplete_tasks() {
    display_header
    grep "^- \[ \]" "$TASK_FILE" || echo "No incomplete tasks found."
    display_footer
}

# Function to process completed tasks
process_completed_tasks() {
    # Read file content into array
    mapfile -t lines < "$TASK_FILE"

    # Arrays for different sections
    incomplete=()
    completed=()
    separator_found=false
    separator="---"

    # Process each line
    for line in "${lines[@]}"; do
        if [[ $line == $separator ]]; then
            separator_found=true
            continue
        fi

        if [[ $line =~ ^-\ \[x\] ]]; then
            completed+=("$line")
        # elif [[ $line =~ ^-\ \[ \] ]] && ! $separator_found; then
        elif [[ $line =~ ^-\ \[\ \] ]] && ! $separator_found; then
            incomplete+=("$line")
        fi
    done

    # Write new content back to file
    {
        for line in "${incomplete[@]}"; do
            echo "$line"
        done
        echo ""
        echo "$separator"
        echo ""
        for line in "${completed[@]}"; do
            echo "$line"
        done
    } > "$TASK_FILE"
}

if [ ! -f "$TASK_FILE" ]; then
    printf "${RED}File not found: ${TASK_FILE}${NO_COLOR}\n"
    exit 1
fi

# Check for argument
if [ "$1" == "-e" ] || [ "$1" == "-g" ]; then
    # Open file in editor
    if [[ "$OSTYPE" == "linux"* ]] && ([[ $(uname -a) =~ .*Microsoft.* ]] || [[ $(uname -a) =~ .*WSL2.* ]]); then
        vi "$TASK_FILE"
    elif [[ "$OSTYPE" == "linux"* ]]; then
        if [ "$1" == "-g" ]; then
            xdg-open "$TASK_FILE" &
        else
            vi "$TASK_FILE"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if [ "$1" == "-g" ]; then
            open "$TASK_FILE" &
        else
            vi "$TASK_FILE"
        fi
    else
        vi "$TASK_FILE"
    fi

    # Process completed tasks after editing
    process_completed_tasks
    # Display incomplete tasks
    display_incomplete_tasks
else
    # Display incomplete tasks
    display_incomplete_tasks
fi
