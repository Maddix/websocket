#include "stdlib.h"
#include "string.h"

// For each bit in byte append 1 or 0 to string and return
char* bitsToByte(char byte) {
	static char string[8];
	for (int i=7; i >= 0; --i) {
		char bit;
		if (byte & (1 << i)) bit = '1';
		else bit = '0';
		string[7-i] = bit;
	}
	string[8] = '\0';
	return string;
}

// For each byte in byteArray get a char for every bit
char* bitsToChars(char *byteArray) {
	int len = strlen(byteArray);
	char *charArray = calloc((len * 8) + 1, sizeof(char));

	for (int i=len - 1; i >= 0; i--) {
		strcat(charArray, bitsToByte(byteArray[i]));
	}
	return charArray;
}
