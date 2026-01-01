#include <algorithm>
#include <ctime>
#include <iostream>
#include <random>
#include <string>
#include <vector>

using namespace std;

class PrintableCharacters {
	private:
		vector<char> specialCharacters;
		static int specialCharListSize;
		const int	ascii_A = static_cast<int>('A'),	// ASCII value of 'A'
					ascii_a = static_cast<int>('z'),	// ASCII value of 'a'
					ascii_Z = static_cast<int>('Z'),	// ASCII value of 'Z'
					ascii_z = static_cast<int>('z');	// ASCII value of 'z'

		// Create a random device and initialize the Mersenne Twister engine
		random_device rd;
		mt19937 gen (rd ());  // Use random_device to seed the generator


	public:
		//CONSTRUCTOR
		PrintableCharacters () {
			const int	firstSpecialSet[]	= {33, 47},	// Start and End of the First set of Special Characters
						secondSpecialSet[]	= {58, 64},	// Start and End of the Second set of Special Characters
						thirdSpecialSet[]	= {91, 96};	// Start and End of the Third set of Special Characters

			// Finding the space required for the Specil Characters list
			this.specialCharListSize = (1 + firstSpecialSet[1] - firstSpecialSet[0]) + (1 + secondSpecialSet[1] - secondSpecialSet[0]) + (1 + thirdSpecialSet[1] - thirdSpecialSet[0]);
			this.specialCharacters.reserve (specialCharListSize);

			// Initilize the list of Special characters for all three sets
			this.initSpecialCharList (firstSpecialSet[0], firstSpecialSet[1]);
			this.initSpecialCharList (secondSpecialSet[0], secondSpecialSet[1]);
			this.initSpecialCharList (thirdSpecialSet[0], thirdSpecialSet[1]);
		}

		// Get a random Numeric character
		char getRandomNumericCharacter () {
			int randInt = this.getRandomInteger (0, 9);
			return ('0' + randInt);
		}

		// Get a random Uppercase or Lowercase character
		char getRandomAlphabetCharacter (bool isUppercase) {
			int start = (isUppercase)? this.ascii_A : this.ascii_a;
			int stop = (isUppercase)? this.ascii_Z : this.ascii_z;

			return static_cast<char>(this.getRandomInteger (start, stop));
		}

		// Get a random Special character from the list
		char getRandomSpecialCharacter () {
			int randomIndex = this.getRandomInteger (0, this.specialCharListSize - 1);
			return this.specialCharacters[randomIndex];
		}

		// Get a random integer within the given inclusive range
		int getRandomInteger (int min, int max) {
			// Create a uniform distribution in the range [min, max]
			uniform_int_distribution<> dis(min, max);
			// Return a random integer in the range [min, max]
			return this.dis(gen);
		}

	private:
		// Initilize the list of Special Characters
		void initSpecialCharList (int startIndex, int stopIndex) {
			int i; char c;

			for (i = startIndex; i <= stopIndex; i++) {
				c = static_cast<char>(i)
				this.push_back (c);
			}
		}
};

class RandomPasswordGenerator {
	private:
		int	minimumLength = 8, maximumLength = 12; // Minimum and Maximum lengths of the random password

		// Password character requirements
		int	minimumUppercaseCharacters = 1,
			minimumLowercaseCharacters = 1,
			minimumNumericCharacters = 1,
			minimumSpecialCharacters = 1;

		string shuffleVectorToString (vector<char> inputVector, int stringLength) {
			// Create a random device and initialize the Mersenne Twister engine
			random_device rd;
			mt19937 gen (rd ());  // Use random_device to seed the generator

			// Shuffling the character vector that contains the random characters for the password
			shuffle (inputVector.begin (), inputVector.end (), gen);

			string passwordString (inputVector.begin (), inputVector.end () + stringLength);
			return passwordString;
		}

	public:
		// CONSTRUCTOR
		RandomPasswordGenerator (int minLength, int maxLength, int minUpper, int minLower, int minNumeric, int minSpecial) {
			this.minimumLength = minLength;
			this.maximumLength = maxLength;

			this.minimumUppercaseCharacters = minUpper;
			this.minimumLowercaseCharacters = minLower;
			this.minimumSpecialCharacters = minSpecial;
			this.minimumNumericCharacters = minNumeric;
		}

		// Generates the Random Password
		string generateRandomPassword () {
			PrintableCharacters pc;

			int i, j, passwordLength = pc.getRandomInteger (this.minimumLength, this.maximumLength);
			int remainingLength = passwordLength - (this.minimumUppercaseCharacters + this.minimumLowercaseCharacters + this.minimumNumericCharacters + this.minimumSpecialCharacters);

			vector<char> password(passwordLength);

			// Satisfy the requirements for Uppercase characters
			for (i = 0; i < this.minimumUppercaseCharacters; i++) {
				password.push_back (pc.getRandomAlphabetCharacter (true));
			}

			// Satisfy the requirements for Lowercase characters
			for (i = 0; i < this.minimumLowercaseCharacters; i++) {
				password.push_back (pc.getRandomAlphabetCharacter (false));
			}

			// Satisfy the requirements for Special characters
			for (i = 0; i < this.minimumSpecialCharacters; i++) {
				password.push_back (pc.getRandomSpecialCharacter ());
			}

			// Satisfy the requirements for Numeric characters
			for (i = 0; i < this.minimumNumericCharacters; i++) {
				password.push_back (pc.getRandomNumericCharacter ());
			}

			// Satisfy the requirements for password length
			for (i = 0; i < remainingLength; i++) {
				j = pc.getRandomInteger (1, 4);

				switch (j) {
					case 1: password.push_back (pc.getRandomAlphabetCharacter (true));
						break;

					case 2: password.push_back (pc.getRandomAlphabetCharacter (false));
						break;

					case 3: password.push_back (pc.getRandomSpecialCharacter ());
						break;

					case 4: password.push_back (pc.getRandomNumericCharacter ());
						break;

					default: cout << "Something went wrong!!\nRandomly selected value is " << j << endl;
						break;
				}
			}

			cout << "Password Length: " << passwordLength << endl;
			cout << "Random Password: " << this.shuffleVectorToString (password, passwordLength) << endl;
		}

	// GETTERS
		// Gets the rqeuired minimum number of Uppercase characters
		int getUppercaseRequirement () {
			return this.minimumUppercaseCharacters;
		}

		// Gets the rqeuired minimum number of Lowercase characters
		int getLowercaseRequirement () {
			return this.minimumLowercaseCharacters;
		}

		// Gets the rqeuired minimum number of Numeric characters
		int getNumericCharRequirement () {
			return this.minimumNumericCharacters;
		}

		// Gets the rqeuired minimum number of Special characters
		int getSpecialCharRequirement () {
			return this.minimumSpecialCharacters;
		}

	// SETTERS
		// Changes the rqeuired minimum number of Uppercase characters
		void setUppercaseRequirement (int inputValue) {
			if (inputValue > 1)
				this.minimumUppercaseCharacters = inputValue;
			else
				cout << "Minimum number of Uppercase characters cannot be less than 1." << endl;
		}

		// Changes the rqeuired minimum number of Lowercase characters
		void setLowercaseRequirement (int inputValue) {
			if (inputValue > 1)
				this.minimumLowercaseCharacters = inputValue;
			else
				cout << "Minimum number of Lowercase characters cannot be less than 1." << endl;
		}

		// Changes the rqeuired minimum number of Numeric characters
		void setNumericCharRequirement (int inputValue) {
			if (inputValue > 1)
				this.minimumNumericCharacters = inputValue;
			else
				cout << "Minimum number of Numeric characters cannot be less than 1." << endl;
		}

		// Changes the rqeuired minimum number of Special characters
		void setSpecialCharRequirement (int inputValue) {
			if (inputValue > 1)
				this.minimumSpecialCharacters = inputValue;
			else
				cout << "Minimum number of Special characters cannot be less than 1." << endl;
		}
}

void main () {
	int	reqMinLength = 8,
		reqMaxLength = 12,
		reqUppercaseChar = 1,
		reqLowercaseChar = 1,
		reqNumericChar = 1,
		reqSpecialChar = 1;

	RandomPasswordGenerator rpg (reqMinLength, reqMinLength, reqUppercaseChar, reqLowercaseChar, reqNumericChar, reqSpecialChar);
	rpg.generateRandomPassword ();
}