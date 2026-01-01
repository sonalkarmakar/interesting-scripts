import java.math.BigInteger;

public class NumberToWords
{
	// List of words for each Digit
	static String[] digits = {"", "one ", "two ", "three ", "four ", "five ", "six ", "seven ", "eight ", "nine "};
	// Multiples of 10 in words
	static String[] multiplesOfTen = {"", "", "twenty ", "thirty ", "forty ", "fifty ", "sixty ", "seventy ", "eighty ", "ninety "};
	// Less than 20, greater than 9
	static String[] underTwentyOverNine = {"ten ", "eleven ", "twelve ", "thirteen ", "fourteen ", "fifteen ", "sixteen ", "seventeen ", "eighteen ", "nineteen "};

	// Period names for groups of 3 digits
	static String[] periodGroups = {"", "", "thousand, ", "million, ", "billion, ", "trillion, "};

	// Converts a group of up to 3 digits into words
	static String threeDigitGroup (int numberGroup)
	{
		if (numberGroup == 0)
			return "";

		String word = "";

		int onesDigit = numberGroup % 10;
		int tensDigit = (numberGroup / 10) % 10;
		int hundredsDigit = numberGroup / 100;

		String hundredWord = (numberGroup >= 100) ? "hundred and " : "";

		if (tensDigit == 1)
			// special case for 10–19
			word = digits[hundredsDigit] + hundredWord + underTwentyOverNine[onesDigit];
		else
			word = digits[hundredsDigit] + hundredWord + multiplesOfTen[tensDigit] + digits[onesDigit];

		return word;
	}

	public static void main(String[] args)
	{
		// Set the number to convert here
		BigInteger bigNumber = new BigInteger("1000000");

		if (bigNumber.equals(BigInteger.ZERO))
		{
			System.out.println("zero");
			return;
		}

		String outputWords = "";
		int groupCount = 0;

		// Process until number is zero
		while (bigNumber.compareTo(BigInteger.ZERO) > 0)
		{
			int groupValue = bigNumber.mod(BigInteger.valueOf(1000)).intValue();
			groupCount++;

			if (groupValue != 0)
			{
				String groupWords = threeDigitGroup(groupValue) + periodGroups[groupCount];
				outputWords = groupWords + outputWords;
			}

			bigNumber = bigNumber.divide(BigInteger.valueOf(1000));
		}

		// Trim any trailing comma or space
		System.out.println(outputWords.trim().replaceAll(",$", ""));
	}
}
