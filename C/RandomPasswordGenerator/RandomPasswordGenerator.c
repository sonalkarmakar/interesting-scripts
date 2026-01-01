#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MIN_LENGTH 8
#define MAX_LENGTH 12

#define MIN_NUMBER_OF_LOWERCASE 1
#define MIN_NUMBER_OF_UPPERCASE 1
#define MIN_NUMBER_OF_SPECIALCHAR 1
#define MIN_NUMBER_OF_NUMERIC 1

// Shuffles the string to make the order random
void shuffleString (char generatedString[], int stringSize)
{
	int i, j = stringSize - 1; char temp;

	for (i = stringSize - 1; i > 0; i--)
	{
		j = rand () % (i + 1); // Random index from 0 to i

		if (i == j)
			j--;

		// Swap generatedString[i] and generatedString[j]
		temp = generatedString[i];
		generatedString[i] = generatedString[j];
		generatedString[j] = temp;
	}
}

// Generate a random integer within the given range
int randIntRange (int min, int max)
{
	return min + rand () % (max - min + 1);
}

// Pick a random character from the second string and append to the first string
void appendRandomCharacter (char targetString[], const char sourceString[])
{
	int sourceStringLength = strlen (sourceString); // Get the length of the source string from which characters are picked
	int randomIndex = randIntRange (0, sourceStringLength-1); // Pick a random integer to be the random index of the source string

	strcat (targetString, (char []){sourceString[randomIndex], '\0'}); // Append randomly selected character to the target string
}

void main ()
{
	srand (time (0)); // Seed the random number generator

	int i, j;

	// Define all the printable ASCII characters as strings
	const char specialCharacters[] = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~";
	const char numericCharacters[] = "0123456789";
	const char uppercaseCharacters[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	const char lowercaseCharacters[] = "abcdefghijklmnopqrstuvwxyz";

	// Pick a random length of password and initiate the password string
	int passwordLength = randIntRange (MIN_LENGTH, MAX_LENGTH); printf ("Password Length: %d\n", passwordLength);
	char password[passwordLength+1]; password[0] = '\0';

	int remainingLength = passwordLength - (MIN_NUMBER_OF_LOWERCASE + MIN_NUMBER_OF_UPPERCASE + MIN_NUMBER_OF_SPECIALCHAR + MIN_NUMBER_OF_NUMERIC);

	// Append the required number of special characters to the password string
	for (i = 0; i < MIN_NUMBER_OF_SPECIALCHAR; i++)
		appendRandomCharacter (password, specialCharacters);

	// Append the required number of uppercase characters to the password string
	for (i = 0; i < MIN_NUMBER_OF_UPPERCASE; i++)
		appendRandomCharacter (password, uppercaseCharacters);

	// Append the required number of lowercase characters to the password string
	for (i = 0; i < MIN_NUMBER_OF_LOWERCASE; i++)
		appendRandomCharacter (password, lowercaseCharacters);

	// Append the required number of numeric characters to the password string
	for (i = 0; i < MIN_NUMBER_OF_NUMERIC; i++)
		appendRandomCharacter (password, numericCharacters);

	// Append random printable characters for the remaining length of the password
	for (i = 0; i < remainingLength; i++)
	{
		j = randIntRange (1, 4);

		switch (j)
		{
			case 1:
				appendRandomCharacter (password, specialCharacters);
				break;

			case 2:
				appendRandomCharacter (password, specialCharacters);
				break;

			case 3:
				appendRandomCharacter (password, specialCharacters);
				break;

			case 4:
				appendRandomCharacter (password, specialCharacters);
				break;
		}
	}

	shuffleString (password, passwordLength); // Shuffle the password string

	printf ("Randomly generated password: %s", password);
	printf ("\n");
}