#!/bin/bash

# Set minimum and maximum password lengths
min_length=8
max_length=16

# Generate a random password length between min_length and max_length characters
range=$((max_length - min_length + 1))
length=$((RANDOM % range + min_length))

# Function to generate a random character
generate_char() {
	local char_pool="!\"#\$%&'()*+,-./:;<=>?@[\\]^_\`{|}~0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	echo -n "${char_pool:$((RANDOM % ${#char_pool})):1}"
}

# Generate a random password until it meets the criteria
while true; do
	password=""
	for ((i=0; i<length; i++)); do
		password+=$(generate_char)
	done

	# Check if the password contains at least one uppercase letter, lowercase letter,
	# special character, and numeric digit, and if not, regenerate the password
	if [[ $password =~ [A-Z] && $password =~ [a-z] && $password =~ [0-9] && $password =~ [^A-Za-z0-9] ]]; then
		break
	fi
done

# Print the generated password
echo $password
echo $length