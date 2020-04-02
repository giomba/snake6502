#include <iostream>
using namespace std;

const int MAXLEN = 64;

void flush(char last, int count) {
    char tile;
    switch(last) {
        case 'x':
            tile = (char)91; break;
        case 'f':
            tile = (char)90; break;
        default:
            tile = (char)32; break;
    }
    cout << tile << (char)count;
}

int main(int argc, char** argv) {
    char line[MAXLEN];
    char c;

    while (true) {
        cin.getline(line, MAXLEN);
        if (line[0] == 'Z') break;
        // cout << line << '\0';   /* the title */
        int count = 0;

        char last = '\0';
        char current = '\0';

        while(true) {

            cin.getline(line, MAXLEN);
            if (line[0] == 'z') {
                flush(current, count);
                cout << '\0' << '\0';
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
    cout << '\0' << '\0';
}

