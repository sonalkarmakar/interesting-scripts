using System;
using System.Text;
using System.Collections.Generic;

namespace NumberInWords {
	class NumberInWords {
		// Names of each Digit. 0 is considered as empty string
		static string[] digitNames = {"", "one ", "two ", "three ", "four ", "five ", "six ", "seven ", "eight ", "nine "};
		// Multiples of 10 in words. 10 is considered in a different list
		static string[] multiplesOfTen = {"", "", "twenty ", "thirty ", "forty ", "fifty ", "sixty ", "seventy ", "eighty ", "ninety "};
		// Numbers 10 to 19 have different names
		static string[] underTwentyOverNine = {"ten ", "eleven ", "twelve ", "thirteen ", "fourteen ", "fifteen ", "sixteen ", "seventeen ", "eighteen ", "nineteen "};
		// Names of the 3-digit period groups
		static string[] periodGroupNames = {"", "", "thousand, ", "million, ", "billion, ", "trillion, ", "quadrillion ", "quintillion "};

		// Converts the 3-digit period groups into words
		static StringBuilder threeDigitGroup (int groupNumeric) {
			StringBuilder groupName = new StringBuilder ("");	// Builds the output string

			if (groupNumeric == 0)	// If the group is 000, return an empty string
				return groupName;

			int	onesPlaceDigit = groupNumeric % 10,			// Right-most digit
				tensPlaceDigit = (groupNumeric % 100) / 10,	// Digit in the middle
				hundredsPlaceDigit = groupNumeric / 100;	// Left-most digit

			if (tensPlaceDigit == 1)	// Checks if the right-most 2 digits make a number in the 10-19 range
				// [Hundreds-place digit in words]+[If hundreds-place digit is 0, append an empty string, else append "hundred and "]+[Number in 10-19 in words]
				groupName.Append (digitNames[hundredsPlaceDigit]).Append ((groupNumeric > 100)? "hundred and " : "").Append (underTwentyOverNine[onesPlaceDigit]);
			else
				// [Hundreds-place digit in words]+[If hundreds-place digit is 0, append an empty string, else append "hundred and "]+[Multiple of ten in words]+[Ones-place digit in words]
				groupName.Append (digitNames[hundredsPlaceDigit]).Append ((groupNumeric > 100)? "hundred and " : "").Append (multiplesOfTen[tensPlaceDigit]).Append (digitNames[onesPlaceDigit]);

			return groupName;
		}

		// MAIN FUNCTION
		static void Main () {
			long inputNumber = 123456789;	// Input number to be converted to words
			LinkedList<StringBuilder> wordsList = new LinkedList<StringBuilder>();	// Stores the name of period groups in order
			StringBuilder outputBuilder = new StringBuilder (); // Builds the final output string from the list above
			int periodCounter = 0;	// Counts the number of period groups

			long numberCopy = inputNumber;	// Get a copy of the original number
			// Convert the group of right-most 3 digits into words, then eliminate the group from the number. Continue till all digits are eliminated
			while (numberCopy > 0) {
				periodCounter++;
				// [Right-most 3-digit group in words]+[Name of the period group]
				wordsList.AddFirst (threeDigitGroup ((int)(numberCopy % 1000)).Append (periodGroupNames[periodCounter]));
				numberCopy = numberCopy / 1000;	// Eliminate the right-most 3 digits from the copy
			}

			// Build the string of full number in words from the list
			foreach (StringBuilder sb in wordsList)
				outputBuilder.Append (sb);

			Console.WriteLine (outputBuilder.ToString ());	// Final Output
		}
	}
}