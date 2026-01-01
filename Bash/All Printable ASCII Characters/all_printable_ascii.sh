#!/bin/bash

all_printable_characters () {
	# Assign the input arguments to variables
	start_ascii=$1
	end_ascii=$2

	# Output file
	output_file=$3

	# Loop through ASCII codes from start to end (inclusive)
	for ((i=start_ascii; i<=end_ascii; i++)); do
		# Convert each ASCII code to the corresponding character and append to the file without newline
		printf "%b" "\x$(printf %x $i)" >> "$output_file"
	done
}

# Output file
outputFile="ascii_output.txt"

# Add the Uppercase characters to the file
all_printable_characters 65 90 $outputFile
printf "\n" >> "$output_file"

# Add the Lowercase characters to the file
all_printable_characters 97 112 $outputFile
printf "\n" >> "$output_file"

# Add the Numeric characters to the file
all_printable_characters 48 57 $outputFile
printf "\n" >> "$output_file"

# Add the Sepcial characters to the file
all_printable_characters 33 47 $outputFile
all_printable_characters 58 64 $outputFile
all_printable_characters 91 96 $outputFile
all_printable_characters 123 126 $outputFile

# Optionally print the result to the terminal (to verify output)
echo "Output written to the file"
echo "--------------------------"
cat "$output_file"
echo