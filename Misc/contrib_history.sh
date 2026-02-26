#!/bin/bash

set -e

GREEN='\e[32m'
NO_COLOR='\e[0m'

GITLAB_ROOT=$HOME/gitlab

CONTRIBUTORS=(
         "john.doe@myorg.com"
         "jane.smith@myorg.com"
         )

#TODO: Replace this with directory walker from the root of the repository
REPOSITORIES=("path/to/repo1"
              "path/to/repo2")

if [ "$#" -eq  2 ]; then
  since="$1"
  until="$2"

  printf "${GREEN}REFRESHING REPOSITORIES...${NO_COLOR}\n\n"
  for r in "${REPOSITORIES[@]}"; do
    repo="${GITLAB_ROOT}/${r}"
    cd "${repo}"
    printf "${GREEN}Refreshing %s${NO_COLOR}\n" "${repo}"
    git pull
  done

  printf "\n${GREEN}PRINTING CONTRIBUTION HISTORY IN csv FORMAT...${NO_COLOR}\n\n"
  
  output_file="/var/tmp/contrib_history_${since}_${until}.csv"

  printf "Author,Repository,Commits,Files,Lines+,Lines-" | tee "$output_file"
  for author in "${CONTRIBUTORS[@]}"; do
    printf "\n%s,,,,,\n" ${author} | tee -a "$output_file"

    for r in "${REPOSITORIES[@]}"; do
      repo="${GITLAB_ROOT}/${r}"
      cd "${repo}"
	    commit_count=$(git log --pretty=format:"%h %ad | %s%d [%an]" --date=short --all --author="${author}" --since "${since}" --until "${until}" | wc -l)
      if [ $commit_count -ne 0 ]; then
        file_count=$(git log --pretty="" --all --author="${author}" --since "${since}" --until "${until}" --name-only | sort | uniq | wc -l)
        
        printf ",%s,%d,%d," ${r} ${commit_count} ${file_count} | tee -a "$output_file"
        git rev-list --all --author="${author}" --since "${since}" --until "${until}" | git log --numstat --pretty="" --stdin | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("%d,%d\n", plus, minus)}' | tee -a "$output_file"
      fi
    done
  done

  open -a "Microsoft Excel.app" "$output_file"
else
  script_name=$(basename "$0")
  echo "Show contribution history."
  echo "  Usage: $script_name <start_date,dd-MMM-yyyy> <end_date,dd-MMM-yyyy>"
	exit 1
fi
