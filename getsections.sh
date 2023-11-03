#!/bin/bash

input_file="in1"
output_prefix="out"

# Initialize variables
section_number=0
inside_section=0
section=""

# Read the input file line by line
while IFS= read -r line; do
  if [[ $line == "-----BEGIN -----" ]]; then
    # Found the start marker
    inside_section=1
    section="-----BEGIN -----\n"
  elif [[ $line == "-----END-----" && $inside_section -eq 1 ]]; then
    # Found the end marker and we were inside a section
    inside_section=0
    section+="-----END-----\n"
    
    # Increment the section number
    section_number=$((section_number + 1))
    
    # Write the section to an output file
    output_file="${output_prefix}${section_number}"
    echo -e "$section" > "$output_file"
  elif [[ $inside_section -eq 1 ]]; then
    # Inside the section, append the line to the section
    section+="$line\n"
  fi
done < "$input_file"
