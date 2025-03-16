#!/bin/bash

# Set the target directory
target_dir="$1"

# Check if the directory exists
if [ ! -d "$target_dir" ]; then
  echo "Error: Directory '$target_dir' not found."
  exit 1
fi

# Loop through files in the directory
for file in "$target_dir"/*; do
  # Check if it's a file (not a directory)
  if [ -f "$file" ]; then
    # Extract filename without extension
    filename=$(basename "$file")
    filename_no_ext="${filename%.*}"
    
    # Print the filename without extension
    echo "$filename_no_ext"
  fi
done