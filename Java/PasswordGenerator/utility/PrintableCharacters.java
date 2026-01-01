package PasswordGenerator.utility;

public class PrintableCharacters
{
	private static String uppercaseCharacters = "";	// Will contain the uppercase characters
	private static String specialCharacters = "";		// Will contain special characters


	public PrintableCharacters ()
	{
		int uppercaseStart = 65, uppercaseEnd = uppercaseStart + 25;

		int firstSetStart = 33, firstSetEnd = 47;	// First set of special characters
		int secondSetStart = 58, secondSetEnd = 64;	// Second set of special characters
		int thirdSetStart = 123, thirdSetEnd = 126;	// Third set of special characters

		// Initialize the lowercase character string
		PrintableCharacters.uppercaseCharacters = PrintableCharacters.uppercaseCharacters.concat (this.initStringsFromASCII (uppercaseStart, uppercaseEnd));

		// Initialize the three sets of special characters
		PrintableCharacters.specialCharacters = PrintableCharacters.specialCharacters.concat (this.initStringsFromASCII (firstSetStart, firstSetEnd));		// Initialize first set
		PrintableCharacters.specialCharacters = PrintableCharacters.specialCharacters.concat (this.initStringsFromASCII (secondSetStart, secondSetEnd));	// Initialize second set
		PrintableCharacters.specialCharacters = PrintableCharacters.specialCharacters.concat (this.initStringsFromASCII (thirdSetStart, thirdSetEnd));		// Initialize third set
	}

	// Creates a string based on the given range of ASCII numbers
	private String initStringsFromASCII (int indexStart, int indexEnd)
	{
		StringBuilder sb = new StringBuilder (); int i;

		for (i = indexStart; i <= indexEnd; i++)
			sb.append ((char)i);

		return sb.toString ();
	}

	// Returns an integer within the given range inclusive
	public int getRandomIntegerInRange (int min, int max)
	{
		return min + (int)(Math.random () * (max - min + 1));
	}

	// Returns a random numeric character by converting from ASCII value
	public char getRandomNumericCharacter ()
	{
		int numericStart = 48, numericEnd = numericStart + 9; // ASCII values of 0 and 9 respectively
		int randomIndex = this.getRandomIntegerInRange (numericStart, numericEnd);
		return (char)randomIndex;
	}

	// Returns a random special character from the string of special characters
	public char getRandomSpecialCharacter ()
	{
		int randomIndex = this.getRandomIntegerInRange (0, PrintableCharacters.specialCharacters.length () - 1);
		return PrintableCharacters.specialCharacters.charAt (randomIndex);
	}

	// Returns a random upper or lower case characters from the string of special characters
	public char getRandomAlphabetCharacter (boolean isUpperCase)
	{
		int randomIndex = this.getRandomIntegerInRange (0, 25);
		char c = PrintableCharacters.uppercaseCharacters.charAt (randomIndex);

		return (isUpperCase)? c : Character.toLowerCase (c);
	}
}