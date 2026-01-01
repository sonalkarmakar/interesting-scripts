using System;
using System.Text;

namespace RandomPasswordGenerator {
	class PrintableCharacters {
		private static string uppercaseCharacters = "";	// Will contain the uppercase characters
		private static string specialCharacters = "";		// Will contain special characters

		Random random = new Random ();	// Will be used to generate random integers

		public PrintableCharacters () {
			int uppercaseStart = 65, uppercaseEnd = uppercaseStart + 25;

			int firstSetStart = 33, firstSetEnd = 47;	// First set of special characters
			int secondSetStart = 58, secondSetEnd = 64;	// Second set of special characters
			int thirdSetStart = 123, thirdSetEnd = 126;	// Third set of special characters

			// Initialize the lowercase character string
			uppercaseCharacters = string.Concat (uppercaseCharacters, initStringsFromASCII (uppercaseStart, uppercaseEnd));

			// Initialize the three sets of special characters
			specialCharacters = string.Concat (specialCharacters, initStringsFromASCII (firstSetStart, firstSetEnd));	// Initialize first set
			specialCharacters = string.Concat (specialCharacters, initStringsFromASCII (secondSetStart, secondSetEnd));	// Initialize second set
			specialCharacters = string.Concat (specialCharacters, initStringsFromASCII (thirdSetStart, thirdSetEnd));	// Initialize third set
		}

		// Creates a string based on the given range of ASCII numbers
		private string initStringsFromASCII (int indexStart, int indexEnd) {
			StringBuilder sb = new StringBuilder (); int i;

			for (i = indexStart; i <= indexEnd; i++)
				sb.Append ((char)i);

			return sb.ToString ();
		}

		// Returns a random integer as a numeric character
		public char getRandomNumericCharacter () {
			int randomInteger = this.random.Next (48, 48 + 10); // ASCII value of '0' is 48
			return (char)randomInteger;
		}

		// Returns a random special character from the string of special characters
		public char getRandomSpecialCharacter () {
			int randomIndex = this.random.Next (0, specialCharacters.Length-1);
			return specialCharacters[randomIndex];
		}

		// Returns a random upper or lower case characters from the string of special characters
		public char getRandomAlphabetCharacter (bool isUpperCase) {
			int randomIndex = this.random.Next (0, 26);
			char c = uppercaseCharacters[randomIndex];

			return (isUpperCase)? c : Char.ToLower (c);
		}
	}

	// MAIN CLASS
	class RandomPasswordGenerator {
		// Generates the Random Password
		static void generateRandomPassword (int minLength, int maxLength, int numOfSpecialChars, int numOfNumericChars, int numOfUppercaseChars, int numOfLowercaseChars) {
			int i, j; // Loop counters

			Random random = new Random ();
			PrintableCharacters printChars = new PrintableCharacters ();

			int passwordLength = random.Next (minLength, maxLength);
			int remainingLength = passwordLength - (numOfSpecialChars + numOfNumericChars + numOfLowercaseChars + numOfUppercaseChars);

			StringBuilder password = new StringBuilder (passwordLength);

			// Append the required number of special characters
			for (i = 0; i < numOfSpecialChars; i++)
				password.Append (printChars.getRandomSpecialCharacter ());

			// Append the required number of numeric characters
			for (i = 0; i < numOfNumericChars; i++)
				password.Append (printChars.getRandomNumericCharacter ());

			// Append the required number of uppercase characters
			for (i = 0; i < numOfUppercaseChars; i++)
				password.Append (printChars.getRandomAlphabetCharacter (true));

			// Append the required number of lowercase characters
			for (i = 0; i < numOfLowercaseChars; i++)
				password.Append (printChars.getRandomAlphabetCharacter (false));

			// Append random characters to fulfill the randomly selected length
			for (i = 0; i < remainingLength; i++) {
				j = random.Next (1, 4);
				switch (j) {
					case 1: password.Append (printChars.getRandomSpecialCharacter ());
						break;

					case 2: password.Append (printChars.getRandomNumericCharacter ());
						break;

					case 3: password.Append (printChars.getRandomAlphabetCharacter (false));
						break;

					case 4: password.Append (printChars.getRandomAlphabetCharacter (true));
						break;
				}
			}

			Console.WriteLine ("Password Length: " + passwordLength);
			Console.WriteLine (stringShuffler (password, passwordLength, random));
		}

		// Shuffles a string passed as a String Builder
		private static string stringShuffler (StringBuilder inputString, int stringLength, Random r) {
			char c; int i, j;

			for (i = stringLength - 1; i > 0; i--) {
				j = r.Next (i + 1);

				if (j == i)
					j--;

				c = inputString[i];
				inputString[i] = inputString[j];
				inputString[j] = c;
			}

			return inputString.ToString ();
		}

		// MAIN FUNCTION
		static void Main () {
			int minimumLength = 8, maximumLength = 12;

			int	minNumOf_specialCharacters = 1,
				minNumOf_numericCharcters = 1,
				minNumOf_uppercaseCharacters = 1,
				minNumOf_lowercaseCharacters = 1;

			generateRandomPassword (minimumLength, maximumLength, minNumOf_specialCharacters, minNumOf_numericCharcters, minNumOf_uppercaseCharacters, minNumOf_lowercaseCharacters);
		}
	}
}