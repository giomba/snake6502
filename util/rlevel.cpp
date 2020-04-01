#include <iostream>
using namespace std;

const int MAXLEN = 64;

void flush(char last, int count) {
    switch(last) {
        case 'x':
            cout << (char)91; break;
        default:
            cout << (char)32; break;
    }
    cout << (char)count;
}

int main(int argc, char** argv) {
    char line[MAXLEN];
    char c;

    while (true) {
        cin.getline(line, MAXLEN);
        if (line[0] == 'Z') break;
        cout << line << '\0';   /* the title */
        int count = 0;

        char last = '\0';
        char current = '\0';

        while(true) { //for (int i = 0; i < 25; ++i) {

            cin.getline(line, MAXLEN);
            if (line[0] == 'z') {
                flush(current, count);
                break;
            }

            for (int j = 0; j < 40; ++j) {
                current = line[j];
                if (last == 0) last = current;
                if (current != last || count == 255) {
                    flush(last, count);
                    last = current;
                    count = 1;
                } else {
                    ++count;
                }
            }
        }
    }
}
