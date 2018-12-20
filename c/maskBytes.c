#include "stdlib.h"
#include "string.h"

// //////////////////////////////////
// Apply a mask to every byte
// Note all parameters must be pointers or else your'll get garbage.
// WARNING!!! This produces bad data and thus requires more testing.
char* c_xorBytes(char *mask, char* byteArray) {
	int len = strlen(byteArray);
	char* messageArray = calloc(len + 1, sizeof(char));
	for (int i=0; i < len; i++) {
		char xor[2] = {*mask ^ byteArray[i], '\0'};
		strcat(messageArray, xor);
	}
	return messageArray;
}
