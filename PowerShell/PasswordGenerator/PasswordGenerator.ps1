# Generate a random password with a length between 8 and 16 characters
$length = Get-Random -Minimum 8 -Maximum 16

# Generate a random string with the specified length, excluding newline characters
$password = -join (33..126 | Where-Object { $_ -ne 10 } | Get-Random -Count $length | %{[char]$_})

# Check if the password contains at least one uppercase letter, lowercase letter,
# special character, and numeric digit, and if not, regenerate the password
while (-not ($password -match '[A-Z]') -or -not ($password -match '[a-z]') -or
	   -not ($password -match '[0-9]') -or -not ($password -match '[^A-Za-z0-9]'))
{
	$password = -join (33..126 | Where-Object { $_ -ne 10 } | Get-Random -Count $length | %{[char]$_})
}

# Print the generated password
$password
