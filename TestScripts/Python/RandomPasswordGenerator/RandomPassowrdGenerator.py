import random

# Class containing all printable ASCII characters
class PrintableCharacters:
	# Declaring the keys to be used in the dictionary
	__specialCharacterKey = "SpecialCharacters"		# Key for special characters
	__numericCharacterKey = "NumericCharcters"		# Key for numeric characters
	__uppercaseCharacterKey = "UppercaseCharacters"	# Key for uppercase characters
	__lowercaseCharacterKey = "LowercaseCharacters"	# Key for lowercase characters

	# Creating the dictionary that will be holding the different category of ASCII characters
	__allPrintableCharacters = {
		__specialCharacterKey : [1],
		__numericCharacterKey : [1],
		__uppercaseCharacterKey : [1],
		__lowercaseCharacterKey : [1]
	}

	def __init__ (self):
		uppercaseStart = ord ('A')
		lowercaseOffset = ord ('a') - ord ('A')

		# Define the start and end of the sets of special characters ASCII codes
		specilaCharacterSets = {
			"firstSet" : [33, 47],
			"secondSet" : [58, 64],
			"thirdSet" : [123, 126]
		}

		listOfNumericCharacters = []	# List of numeric characters to be updated in the dictionary
		listOfUppercaseCharacters = []	# List of uppercase characters to be updated in the dictionary
		listOfLowercaseCharacters = []	# List of lowercase characters to be updated in the dictionary
		listOfSpecialCharacters = []	# List of special characters to be updated in the dictionary

		# INTIATE THE LIST OF NUMERIC CHARACTERS
		# Create a list of numeric characters
		for i in range (10):
			listOfNumericCharacters.append (str (i))

		# Update the value for numeric characters in the dictionary
		self.__allPrintableCharacters.update ({self.__numericCharacterKey : listOfNumericCharacters})

		# INITIATE THE LIST OF UPPERCASE AND LOWERCASE CHARACTERS
		# Create a list of uppercase characters
		for i in range (uppercaseStart, uppercaseStart + 26):
			listOfUppercaseCharacters.append (chr (i))
			listOfLowercaseCharacters.append (chr (i + lowercaseOffset))

		# Update the value for uppercase and lowercase in the dictionary
		self.__allPrintableCharacters.update ({self.__uppercaseCharacterKey : listOfUppercaseCharacters})
		self.__allPrintableCharacters.update ({self.__lowercaseCharacterKey : listOfLowercaseCharacters})

		# INITIATE THE LIST OF SPECIAL CHARACTERS
		# Append the first set of special characters
		for i in range (specilaCharacterSets["firstSet"][0], 1 + specilaCharacterSets["firstSet"][1]):
			listOfSpecialCharacters.append (chr (i))
		# Append the second set of special characters
		for i in range (specilaCharacterSets["secondSet"][0], 1 + specilaCharacterSets["secondSet"][1]):
			listOfSpecialCharacters.append (chr (i))
		# Append the third set of special characters
		for i in range (specilaCharacterSets["thirdSet"][0], 1 + specilaCharacterSets["thirdSet"][1]):
			listOfSpecialCharacters.append (chr (i))

		# Update the value for numeric characters in the dictionary
		self.__allPrintableCharacters.update ({self.__specialCharacterKey : listOfSpecialCharacters})

	# Return a randomly selected special character from the list of special characters
	def getRandomSpecialCharacter (self):
		return random.choice (self.__allPrintableCharacters[self.__specialCharacterKey])

	# Return a randomly selected numeric character from the list of numeric characters
	def getRandomNumericCharacter (self):
		return random.choice (self.__allPrintableCharacters[self.__numericCharacterKey])

	# Return a randomly selected uppercase character from the list of upperacase characters
	def getRandomUppercaseCharacter (self):
		return random.choice (self.__allPrintableCharacters[self.__uppercaseCharacterKey])

	# Return a randomly selected lowercase character from the list of lowercase characters
	def getRandomLowercaseCharacter (self):
		return random.choice (self.__allPrintableCharacters[self.__lowercaseCharacterKey])

# PASSWORD GENERATOR CLASS
class PasswordGenerator:
	# Having default values to avoid error
	minimumLength = 8				# Minimum allowed length of the password
	maximumLength = 12				# Maximum allowed length of the password
	passwordLength = minimumLength	# Password length, will be set to a randomly generated integer

	minimumUppercase = 1	# Minimum number of uppercase characters
	minimumLowercase = 1	# Minimum number of lowercase characters
	minimumNumeric = 1		# Minimum number of digits or numeric characters
	minimumSpecial = 1		# Minimum number of special characters

	# CONSTRUCTOR FOR PASSWORD GENERATOR CLASS
	def __init__ (self, minLength, maxLength, minNumOfUppercase, minNumOfLowercase, minNumOfNumeric, minNumOfSpecial):
		self.minimumLength = minLength
		self.maximumLength = maxLength

		self.minimumLowercase = minNumOfLowercase
		self.minimumUppercase = minNumOfUppercase
		self.minimumNumeric = minNumOfNumeric
		self.minimumSpecial = minNumOfSpecial

	# Setter for Minimum Password Length if needed to change later
	def setMinimumLength (self, minLength):
		self.minimumLength = minLength

	# Setter for Maximum Password Length if needed to change later
	def setMaximumLength (self, maxLength):
		self.maximumLength = maxLength

	# Setter for Minimum Number of Lowercase Characters if needed to change later
	def setMinimumLowercaseCharacters (self, minNumOfLowercase):
		self.minimumLowercase = minNumOfLowercase

	# Setter for Minimum Number of Uppercase Characters if needed to change later
	def setMinimumUppercaseCharacters (self, minNumOfUppercase):
		self.minimumUppercase = minNumOfUppercase

	# Setter for Minimum Number of Numeric Characters if needed to change later
	def setMinimumNumericCharacters (self, minNumOfNumeric):
		self.minimumNumeric = minNumOfNumeric

	# Setter for Minimum Number of Special Characters if needed to change later
	def setMinimumSpecialCharacters (self, minNumOfSpecial):
		self.minimumSpecial = minNumOfSpecial

	# Returns the length of password
	def getPasswordLength (self):
		return self.passwordLength

	# Generates a random password based on the values passed into the class
	def generate (self):
		passwordCharacterList = [] # Store the randomly selected characters in a list
		self.passwordLength = random.randint (self.minimumLength, self.maximumLength) # Random integer within the range of minimum and maximum length
		remainingLength = self.passwordLength - (self.minimumUppercase + self.minimumLowercase + self.minimumNumeric + self.minimumSpecial) # Find the remaining length after requirements are met
		pc = PrintableCharacters () # Instance of Printable Character class

		# Function calls based on random integer from 1 to 4
		functionDictionary = {
			1	:	pc.getRandomUppercaseCharacter (),	# Gets a random Uppercase character
			2	:	pc.getRandomLowercaseCharacter (),	# Gets a random Lowercase character
			3	:	pc.getRandomNumericCharacter (),	# Gets a random Numeric character
			4	:	pc.getRandomSpecialCharacter ()		# Gets a random Special character
		}

		# SATISFYING PASSWORD REQUIREMENTS
		# Add the required minimum number of Uppercase characters
		for i in range (self.minimumUppercase):
			passwordCharacterList.append (pc.getRandomUppercaseCharacter ())

		# Add the required minimum number of Lowercase characters
		for i in range (self.minimumLowercase):
			passwordCharacterList.append (pc.getRandomLowercaseCharacter ())

		# Add the required minimum number of Numeric characters
		for i in range (self.minimumNumeric):
			passwordCharacterList.append (pc.getRandomNumericCharacter ())

		# Add the required minimum number of Special characters
		for i in range (self.minimumSpecial):
			passwordCharacterList.append (pc.getRandomSpecialCharacter ())

		# SELECT RANDOM PRINTABLE CHARACTERS TO MAKE THE PASSWORD THE SELECTED LENGTH
		for i in range (remainingLength):
			passwordCharacterList.append (functionDictionary[random.randint (1, 4)]) # Call a function from the dictionary based on a random index

		random.shuffle (passwordCharacterList) # Shuffle the list of password characters

		return "".join (passwordCharacterList) # Return the generated password as a string

# MAIN FUNCTION
def main ():
	minimumPasswordLength = 8		# Minimum password length
	maximumPassowrdLength = 12		# Maximum password length

	minimumUppercaseRequirement = 1	# Minimum number of uppercase characters
	minimumLowercaseRequirement = 1	# Minimum number of lowercase characters
	minimumNumericRequirement = 1	# Minimum number of digits or numeric characters
	minimumSpecialRequirement = 1	# Minimum number of special characters

	# Creating an instance of the PasswordGenerator class
	passGen = PasswordGenerator (minimumPasswordLength, maximumPassowrdLength, minimumUppercaseRequirement, minimumLowercaseRequirement, minimumNumericRequirement, minimumSpecialRequirement)
	randomPassword = passGen.generate () # Calling the method to generate a new password

	print ("Password length is", passGen.getPasswordLength (), "characters") # Get the length of generated password
	print (randomPassword) # Show the password

# MAIN BLOCK
if __name__ == "__main__":
	main () # Calling the main function