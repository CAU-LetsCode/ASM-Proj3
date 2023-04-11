#include <stdio.h>
#include <unistd.h>

int is_palindrome(char * buf, int len);

int main() {
    char buf[1024];
    int count;
    write(1, "Please enter a string:\n", 23);
    count = read(0, buf, 1024);
    while (buf[0] != '\n') {
        count--;
        if (is_palindrome(buf, count)) {
            write(1, "It is a palindrome\n", 20);
        } else {
            write(1, "It is NOT a palindrome\n", 23);
        }
        write(1, "Please enter a string:\n", 23);
        count = read(0, buf, 1024);
    }
    return 0;

}

int is_palindrome(char *buf, int len) {
    int i, j;
    for (i = 0, j = len - 1; i < len/2; i++, j--)
        if (buf[i] != buf[j]) return 0;
    return 1;
}