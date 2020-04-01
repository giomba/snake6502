#include <iostream>
using namespace std;

int main() {
    int count = 0;

    while (cin.good()) {
        char c;
        cin.get(c);
        if (! cin.good()) break;

        if (count % 8 == 0) {
            cout << "; character " << count / 8 << endl;
        }
        cout << "   BYTE #%";
        for (int i = 7; i >= 0; --i) {
            cout << ((c >> i) & 1);
        }
        cout << endl;

        if (count % 8 == 7) {
            cout << endl;
        }

        count++;
    }

    return 0;
}
