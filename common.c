#include "common.h"

void* memcpy(void* dst, const void* src, size_t n) {
	uint8_t* d = (uint8_t*)dst;
	const uint8_t* s = (const uint8_t*)src;
	while(n--) *d++ = *s++;
	return dst;
}

void* memset(void* buf, char c, size_t n) {
	uint8_t* p = (uint8_t*)buf;
	while(n--) *p++ = c;
	return buf;
}

// NOTE: Not safe 
char* strcpy(char* dst, const char* src) {
	char* d = dst;
	while (*src) *d++ = *src++;
	*d = '\0';
	return dst;
}


/*
 * s1 == s2   0
 * s1 > s2    positive value
 * s1 < s2    negative value
*/
int   strcmp(const char* s1, const char* s2) {
	while (*s1 && *s2) {
		if (*s1 != *s2)
			break;
		s1++;
		s2++;
	}	
	return *(unsigned char*)s1 - *(unsigned char*)s2;
}

void putchar(char ch);

void printf(const char* fmt, ...) {
	va_list vargs;
	va_start(vargs, fmt);

	while (*fmt) {
		if (*fmt == '%') {
			fmt++;
			switch (*fmt) {
				case '\0':
					putchar('%');
					goto end;
				case '%':
					putchar('%');
					break;
				case 's': { // Print a NULL-terminated string.
					const char* s = va_arg(vargs, const char*);
					while (*s) {
						putchar(*s);
						s++;
					}
					break;
				}
				case 'd': {
					int value = va_arg(vargs, int);
					unsigned magnitude = value;
					if (value < 0) {
						putchar('-');
						magnitude = -magnitude;
					}
					unsigned divisor = 1;
					while (magnitude / divisor > 9) {
						divisor *= 10;
					}
					while(divisor > 0) {
						putchar('0' + magnitude / divisor);
						magnitude %= divisor;
						divisor /= 10;
					}
					break;
				}
				case 'l': {
					fmt++;
					if (*fmt == '\0') {
						putchar('l');
						goto end;
					} else if (*fmt == 'l') {
						fmt++;
						if (*fmt == 'u') {
						unsigned long long value = va_arg(vargs, unsigned long long);
						unsigned high = (unsigned)(value >> 32);
						unsigned low = (unsigned)value;
						if (high == 0) {
						 	// Print just the low part
							unsigned magnitude = low;
							unsigned divisor = 1;
							while (magnitude / divisor > 9) {
							  divisor *= 10;
						 	}
							while(divisor > 0) {
								putchar('0' + magnitude / divisor);
								magnitude %= divisor;
								divisor /= 10;
							}
						} else {
							// Simple version print in hex
							putchar('0');
							putchar('x');
							for (int i = 7; i >= 0; i--) {
								unsigned nibble = (high >> (i*4)) & 0xf;
								putchar("0123456789abcdef"[nibble]);
							}
							for (int i = 7; i >= 0; i--) {
								unsigned nibble = (low >> (i*4)) & 0xf;
								putchar("0123456789abcdef"[nibble]);
							}
						}
						break;
						} else if (*fmt == '\0') {
							putchar('l');
							putchar('l');
							goto end;
						} else {
							putchar('l');
							putchar('l');
							putchar(*fmt);
							break;
						}
					} else {
						putchar(*fmt);
					}
					break;
				}
				case 'x': {
					unsigned value = va_arg(vargs, unsigned);
					for (int i = 7; i >= 0; i--) {
						unsigned nibble = (value >> (i*4)) & 0xf;
						putchar("0123456789abcdef"[nibble]);
					}
				}
			}
		} else {
			putchar(*fmt);
		}
		fmt++;
	}
end:
	va_end(vargs);
}
