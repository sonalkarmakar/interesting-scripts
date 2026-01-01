'''
This script converts numbers given as input into words based on the international number-system, that divides large numbers into groups of 3 digits.
For example, the number 123456789 will be converted to "one hundred and twenty three million, four hundred and fifty six thousand, seven hundred and eighty nine"
'''

# Input Number to be converted to words
input_number = 1000000#519211217553377
# The Input Number converted to words will be stored below
output_words = ""

# List of words to be used to build the output string. Empty strings are for representing 0 or when no words are required
# List of digits in words
digits = ["", "one ", "two ", "three ", "four ", "five ", "six ", "seven ", "eight ", "nine "]
# List of multiples of 10 in words, excluding 10
multiples_of_ten = ["", "", "twenty ", "thirty ", "forty ", "fifty ", "sixty ", "seventy ", "eighty ", "ninety "]
# List of numbers from 10 to 19 in words
under_twenty_over_nine = ["ten ", "eleven ", "twelve ", "thirteen ", "fourteen ", "fifteen ", "sixteen ", "seventeen ", "eighteen ", "nineteen "]
# Names of groups of 3 digits
period_groups = ["", "", "thousand, ", "million, ", "billion, ", "trillion, "]

# This function converts groups of 3 digits into words. Like 123 will be "one hundred and twenty three"
def three_digit_group (number_group):
	if number_group == 0:
		return ""

	# String for containing the group's words
	three_digit_word = ""

	ones_digit = number_group % 10			# Right-most digit
	tens_digit = (number_group // 10) % 10	# Middle digit
	hundreds_digit = number_group // 100	# Left-most digit

	# Separates the conditions for having a 0 as the left-most digit, like 023 and 123
	if number_group >= 100:
		hundred_word = "hundred and "	# When left-most digit isn't 0, i.e., 123
	else:
		hundred_word = ""				# When left-most digit is 0, i.e., 023

	# Checks for numbers from 10 to 19
	if tens_digit == 1:
		three_digit_word = digits[hundreds_digit] + hundred_word + under_twenty_over_nine[ones_digit]
	else:
		three_digit_word = digits[hundreds_digit] + hundred_word + multiples_of_ten[tens_digit] + digits[ones_digit]

	# Final output of the 3-digit group in words
	return three_digit_word

# Main Function starts here
number = input_number	# Copy the input number for modifying
group_count = 0			# Counts the number of 3-digit groups

# This section takes the right-most 3-digit group, converts that to words, and finally removes that group from the end of the number
# The steps are continued as long as 'number' is not reduced to 0 because of division
while number > 0:
	group_count = group_count + 1	# Increase the count of 3-digit groups by 1

	# [1]	(number % 1000) sends the right-most 3 digits to the three_digit_group () function
	# [2]	Get the name of the 3-digit group in words
	# [3]	Append the words of the previous 3-digit group at the end
	if number % 1000 == 0:	# If it's all 0s in a group, don't append anything (eg.: 1,000,000 -> One Million)
		output_words = three_digit_group (number % 1000) + output_words
	else:					# If there are numbers, convert them to words
		output_words = three_digit_group (number % 1000) + period_groups[group_count] + output_words

	number = number // 1000	# Remove the right-most 3 digits as they've been processed

# Final output of the given number in words
print (output_words.rstrip (" ,"))
