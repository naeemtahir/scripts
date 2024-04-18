#!/bin/bash

ENC_EXT="enc"
OUTPUT_DIR="."

usage() {
  cat <<HERE
Usage: fcrypt.sh <-e|-d> [-o <dir>] [-s] [-r] [-s] [-h]
  -e         Encrypt
  -d         Decrypt
  -r         Delete original file
  -s         Process subdirectories
  -o dir     Output directory (should exist)
  -h         Help
HERE
  exit 1
}

# Set options based on input arguments
while [[ $# -ge 1 ]]; do
  key="$1"

  case $key in
    -e)
    OPERATION="-e"
    ;;
    -d)
    OPERATION="-d"
    ;;
    -r)
    DELETE_ORIGINAL="true"
    ;;
    -s)
    PROCESS_SUBDIR="true"
    ;;
    -o)
    OUTPUT_DIR="$2"
    shift
    ;;
    -h)
    usage
    ;;
    *)
    # unknown option
    ;;
  esac

  shift
done

# Validate operation and output directory
if [ -z $OPERATION ] || [ -z $OUTPUT_DIR ] || [ ! -d $OUTPUT_DIR ]; then
  usage
fi

set -e

# Check output directory is not sub-directory of input directory,
# then mirror input directory structure into output directory
OUTPUT_DIR=$(realpath "$OUTPUT_DIR")
if [ "$OUTPUT_DIR" != "$PWD" ]; then
  if [[ "$OUTPUT_DIR" == *"$PWD"* ]]; then
    echo "Output dir $OUTPUT_DIR cannot be sub directory of input dir. Exiting..."
    exit 1
  fi

  # Mirror input directory structure into output directory
  if [ ! -z $PROCESS_SUBDIR ]; then
    find . -type d -exec mkdir -p "$OUTPUT_DIR"/{} \;
  fi
fi

read -r -s -p "Password: " password

# Construct encryption/decryption command
ENC_COMMAND="find . -maxdepth 1 -type f -not -name "*.$ENC_EXT" -a -exec openssl aes-256-cbc -e -pbkdf2 -a -A -in {} -out "$OUTPUT_DIR"/{}.$ENC_EXT -pass pass:\"$password\" \; -exec rm {} \;"
DEC_COMMAND="find . -maxdepth 1 -type f -name "*.$ENC_EXT" -exec openssl aes-256-cbc -d -pbkdf2 -a -A -in {} -out "$OUTPUT_DIR"/{}.d -pass pass:\"$password\" \; -exec rename 's/\.$ENC_EXT\.d$//' "$OUTPUT_DIR"/{}.d \; -exec rm {} \;"

if [ ! -z $PROCESS_SUBDIR ]; then
  ENC_COMMAND=$(echo "$ENC_COMMAND" | sed 's/-maxdepth 1 //g')
  DEC_COMMAND=$(echo "$DEC_COMMAND" | sed 's/-maxdepth 1 //g')
fi

if [ -z $DELETE_ORIGINAL ]; then
  ENC_COMMAND=$(echo "$ENC_COMMAND" | sed 's/\-exec rm {} \\\;//g')
  DEC_COMMAND=$(echo "$DEC_COMMAND" | sed 's/\-exec rm {} \\\;//g')
fi

if [ $OPERATION == "-e" ]; then
  eval "$ENC_COMMAND"
else
  eval "$DEC_COMMAND"
fi
