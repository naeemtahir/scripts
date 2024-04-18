#!/bin/bash

declare -A topic=( 
  ["bash"]="https://github.com/naeemtahir/reference/blob/master/bash.md"
  ["code"]="https://code.visualstudio.com/shortcuts/keyboard-shortcuts-linux.pdf https://code.visualstudio.com/shortcuts/keyboard-shortcuts-macos.pdf https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf"
  ["flink"]="https://github.com/naeemtahir/reference/blob/master/flink.md"
  ["git"]="https://github.com/naeemtahir/reference/blob/master/git.md"
  ["gnome"]="https://help.gnome.org/users/gnome-help/stable/shell-keyboard-shortcuts"
  ["helm"]="https://github.com/naeemtahir/reference/blob/master/helm.md"
  ["intellij"]="https://resources.jetbrains.com/storage/products/intellij-idea/docs/IntelliJIDEA_ReferenceCard.pdf"  
  ["k8s"]="https://github.com/naeemtahir/reference/blob/master/k8s.md"
  ["redshift"]="https://github.com/naeemtahir/reference/blob/master/redshift.md"
  ["regex"]="https://github.com/naeemtahir/reference/blob/master/regex.md"
  ["rest"]="https://github.com/naeemtahir/reference/blob/master/rest.md"
  ["tmux"]="https://github.com/naeemtahir/reference/blob/master/tmux.md"
  ["vi"]="https://github.com/naeemtahir/reference/blob/master/vi.md"
)

OPEN=xdg-open
if [[ "$OSTYPE" == "darwin"* ]]; then
  OPEN=open
fi

usage() {
  script_name=`basename "$0"`
  
  sorted_topics=`echo "${!topic[@]}" | tr ' ' '\n' | sort | tr '\n' '|'`
  
  echo "Usage: $script_name [${sorted_topics[@]:0:-1}]"
  exit 1
}

if [ "$#" -eq 1 ]; then
  if [[ ${topic[$1]} ]]; then
    for f in ${topic[$1]}; do
      $OPEN "$f" > /dev/null 2>&1
    done
  else
    echo "Topic '$1' not found."
    usage
  fi
else
  usage
fi

