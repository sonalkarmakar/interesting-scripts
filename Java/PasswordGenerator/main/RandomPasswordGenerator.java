package PasswordGenerator.main;

import PasswordGenerator.utility.PrintableCharacters;

public class RandomPasswordGenerator
{
	public static void generateRandomPassword (
		int minLength, int maxLength,
		int numOfSpecialChars, int numOfNumericChars,
		int numOfUppercaseChars, int numOfLowercaseChars
	)
	{
		int i, j; // Loop counters

		PrintableCharacters printChars = new PrintableCharacters ();

		int passwordLength = printChars.getRandomIntegerInRange (minLength, maxLength);
		int remainingLength = passwordLength - (numOfSpecialChars + numOfNumericChars + numOfLowercaseChars + numOfUppercaseChars);

		StringBuilder password = new StringBuilder (passwordLength);

		// Append the required number of special characters
		for (i = 0; i < numOfSpecialChars; i++)
			password.append (printChars.getRandomSpecialCharacter ());

		// Append the required number of numeric characters
		for (i = 0; i < numOfNumericChars; i++)
			password.append (printChars.getRandomNumericCharacter ());

		// Append the required number of uppercase characters
		for (i = 0; i < numOfUppercaseChars; i++)
			password.append (printChars.getRandomAlphabetCharacter (true));

		// Append the required number of lowercase characters
		for (i = 0; i < numOfLowercaseChars; i++)
			password.append (printChars.getRandomAlphabetCharacter (false));

		// Append random printable ASCII characters to make it as long as the picked length
		for (i = 0; i < remainingLength; i++)
		{
			j = printChars.getRandomIntegerInRange (1, 4);
			switch (j)
			{
				case 1: password.append (printChars.getRandomSpecialCharacter ());
					break;

				case 2: password.append (printChars.getRandomNumericCharacter ());
					break;

				case 3: password.append (printChars.getRandomAlphabetCharacter (false));
					break;

				case 4: password.append (printChars.getRandomAlphabetCharacter (true));
					break;
			}
		}

		System.out.println ("Password Length: " + passwordLength);
		System.out.println (stringShuffler (password, passwordLength, printChars));
	}

	public static String stringShuffler (StringBuilder inputString, int stringLength, PrintableCharacters pc)
	{
		char c; int i, j;

		for (i = stringLength - 1; i > 0; i--)
		{
			j = pc.getRandomIntegerInRange (0, i);

			if (j == i)
				j--;

			c = inputString.charAt (i);
			inputString.setCharAt (i, inputString.charAt (j));
			inputString.setCharAt (j, c);
		}

		return inputString.toString ();
	}

	public static void main (String args[])
	{
		int minimumLength = 8, maximumLength = 12;

		int	minNumOf_specialCharacters = 1,
			minNumOf_numericCharcters = 1,
			minNumOf_uppercaseCharacters = 1,
			minNumOf_lowercaseCharacters = 1;

		generateRandomPassword (
			minimumLength, maximumLength,
			minNumOf_specialCharacters, minNumOf_numericCharcters,
			minNumOf_uppercaseCharacters, minNumOf_lowercaseCharacters
		);
	}
}