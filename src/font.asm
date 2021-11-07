; Character ROM starts at $2000, but SID must reside at $1000 and is
; longer than $1000, then first characters are just ignored, and game
; uses only characters $80-$ff.
; Normally, character ROM is 2kB long ($800), but this binary data
; is exactly 1kB long ($400), because only the upper chars are defined.

   SEG fontSegment
; char 0x80, 128
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000

; char 0x81, 129
   BYTE #%00111000
   BYTE #%01101100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11111110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%00000000

; char 0x82, 130
   BYTE #%11111000
   BYTE #%11001100
   BYTE #%11001100
   BYTE #%11111000
   BYTE #%11001100
   BYTE #%11000110
   BYTE #%11111100
   BYTE #%00000000

; char 0x83, 131
   BYTE #%00111100
   BYTE #%01100110
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%01100110
   BYTE #%00111100
   BYTE #%00000000

; char 0x84, 132
   BYTE #%11111000
   BYTE #%11001100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11001100
   BYTE #%11111000
   BYTE #%00000000

; char 0x85, 133
   BYTE #%11111100
   BYTE #%11000110
   BYTE #%11000000
   BYTE #%11111000
   BYTE #%11000000
   BYTE #%11000110
   BYTE #%11111100
   BYTE #%00000000

; char 0x86, 134
   BYTE #%11111100
   BYTE #%11000110
   BYTE #%11000000
   BYTE #%11111000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%00000000

; char 0x87, 135
   BYTE #%00111100
   BYTE #%01100110
   BYTE #%11000000
   BYTE #%11011110
   BYTE #%11000110
   BYTE #%01100110
   BYTE #%00111100
   BYTE #%00000000

; char 0x88, 136
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11111110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%00000000

; char 0x89, 137
   BYTE #%01111110
   BYTE #%11011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%01111110
   BYTE #%00000000

; char 0x8a, 138
   BYTE #%01111110
   BYTE #%11001100
   BYTE #%00001100
   BYTE #%00001100
   BYTE #%00001100
   BYTE #%11011000
   BYTE #%01110000
   BYTE #%00000000

; char 0x8b, 139
   BYTE #%11000110
   BYTE #%11001100
   BYTE #%11011000
   BYTE #%11110000
   BYTE #%11011000
   BYTE #%11001100
   BYTE #%11000110
   BYTE #%00000000

; char 0x8c, 140
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%11000110
   BYTE #%11111100
   BYTE #%00000000

; char 0x8d, 141
   BYTE #%11000110
   BYTE #%11101110
   BYTE #%11111110
   BYTE #%11010110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%00000000

; char 0x8e, 142
   BYTE #%11011100
   BYTE #%11110110
   BYTE #%11100110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%00000000

; char 0x8f, 143
   BYTE #%00111000
   BYTE #%01101100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%01101100
   BYTE #%00111000
   BYTE #%00000000

; char 0x90, 144
   BYTE #%11111100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11111100
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%00000000

; char 0x91, 145
   BYTE #%00111000
   BYTE #%01101100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11001010
   BYTE #%01101100
   BYTE #%00110110
   BYTE #%00000000

; char 0x92, 146
   BYTE #%11111100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11111100
   BYTE #%11011000
   BYTE #%11001100
   BYTE #%11000110
   BYTE #%00000000

; char 0x93, 147
   BYTE #%01111100
   BYTE #%11000110
   BYTE #%11000000
   BYTE #%01111100
   BYTE #%00001110
   BYTE #%11000110
   BYTE #%01111100
   BYTE #%00000000

; char 0x94, 148
   BYTE #%01111110
   BYTE #%11011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00000000

; char 0x95, 149
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%01111100
   BYTE #%00000000

; char 0x96, 150
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%01101100
   BYTE #%00111000
   BYTE #%00010000
   BYTE #%00000000

; char 0x97, 151
   BYTE #%11000110
   BYTE #%11010110
   BYTE #%11010110
   BYTE #%11111110
   BYTE #%11101110
   BYTE #%11000110
   BYTE #%10000010
   BYTE #%00000000

; char 0x98, 152
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%01101100
   BYTE #%00111000
   BYTE #%01101100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%00000000

; char 0x99, 153
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%01101100
   BYTE #%00111000
   BYTE #%00110000
   BYTE #%01100000
   BYTE #%00000000

; char 0x9a, 154
   BYTE #%01111110
   BYTE #%11000110
   BYTE #%00001100
   BYTE #%00011000
   BYTE #%00110000
   BYTE #%01100110
   BYTE #%11111100
   BYTE #%00000000

; char 0x9b, 155
   BYTE #%00011100
   BYTE #%00110000
   BYTE #%00100000
   BYTE #%01100000
   BYTE #%00100000
   BYTE #%00110000
   BYTE #%00011100
   BYTE #%00000000

; char 0x9c, 156
   BYTE #%00111000
   BYTE #%00001100
   BYTE #%00000100
   BYTE #%00000110
   BYTE #%00000100
   BYTE #%00001100
   BYTE #%00111000
   BYTE #%00000000

; char 0x9d, 157
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00111000
   BYTE #%00111000
   BYTE #%00000000

; char 0x9e, 158
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0x9f, 159
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xa0, 160
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11111111

; char 0xa1, 161
   BYTE #%11000111
   BYTE #%10010011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00000001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%11111111

; char 0xa2, 162
   BYTE #%00000111
   BYTE #%00110011
   BYTE #%00110011
   BYTE #%00000111
   BYTE #%00110011
   BYTE #%00111001
   BYTE #%00000011
   BYTE #%11111111

; char 0xa3, 163
   BYTE #%11000011
   BYTE #%10011001
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%10011001
   BYTE #%11000011
   BYTE #%11111111

; char 0xa4, 164
   BYTE #%00000111
   BYTE #%00110011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00110011
   BYTE #%00000111
   BYTE #%11111111

; char 0xa5, 165
   BYTE #%00000011
   BYTE #%00111001
   BYTE #%00111111
   BYTE #%00000111
   BYTE #%00111111
   BYTE #%00111001
   BYTE #%00000011
   BYTE #%11111111

; char 0xa6, 166
   BYTE #%00000011
   BYTE #%00111001
   BYTE #%00111111
   BYTE #%00000111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%11111111

; char 0xa7, 167
   BYTE #%11000011
   BYTE #%10011001
   BYTE #%00111111
   BYTE #%00100001
   BYTE #%00111001
   BYTE #%10011001
   BYTE #%11000011
   BYTE #%11111111

; char 0xa8, 168
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00000001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%11111111

; char 0xa9, 169
   BYTE #%10000001
   BYTE #%00100111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%10000001
   BYTE #%11111111

; char 0xaa, 170
   BYTE #%10000001
   BYTE #%00110011
   BYTE #%11110011
   BYTE #%11110011
   BYTE #%11110011
   BYTE #%00100111
   BYTE #%10001111
   BYTE #%11111111

; char 0xab, 171
   BYTE #%00111001
   BYTE #%00110011
   BYTE #%00100111
   BYTE #%00001111
   BYTE #%00100111
   BYTE #%00110011
   BYTE #%00111001
   BYTE #%11111111

; char 0xac, 172
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%00111001
   BYTE #%00000011
   BYTE #%11111111

; char 0xad, 173
   BYTE #%00111001
   BYTE #%00010001
   BYTE #%00000001
   BYTE #%00101001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%11111111

; char 0xae, 174
   BYTE #%00100011
   BYTE #%00001001
   BYTE #%00011001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%11111111

; char 0xaf, 175
   BYTE #%11000111
   BYTE #%10010011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%10010011
   BYTE #%11000111
   BYTE #%11111111

; char 0xb0, 176
   BYTE #%00000011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00000011
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%11111111

; char 0xb1, 177
   BYTE #%11000111
   BYTE #%10010011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00110101
   BYTE #%10010011
   BYTE #%11001001
   BYTE #%11111111

; char 0xb2, 178
   BYTE #%00000011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00000011
   BYTE #%00100111
   BYTE #%00110011
   BYTE #%00111001
   BYTE #%11111111

; char 0xb3, 179
   BYTE #%10000011
   BYTE #%00111001
   BYTE #%00111111
   BYTE #%10000011
   BYTE #%11110001
   BYTE #%00111001
   BYTE #%10000011
   BYTE #%11111111

; char 0xb4, 180
   BYTE #%10000001
   BYTE #%00100111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%11111111

; char 0xb5, 181
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%10000011
   BYTE #%11111111

; char 0xb6, 182
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%10010011
   BYTE #%11000111
   BYTE #%11101111
   BYTE #%11111111

; char 0xb7, 183
   BYTE #%00111001
   BYTE #%00101001
   BYTE #%00101001
   BYTE #%00000001
   BYTE #%00010001
   BYTE #%00111001
   BYTE #%01111101
   BYTE #%11111111

; char 0xb8, 184
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%10010011
   BYTE #%11000111
   BYTE #%10010011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%11111111

; char 0xb9, 185
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%10010011
   BYTE #%11000111
   BYTE #%11001111
   BYTE #%10011111
   BYTE #%11111111

; char 0xba, 186
   BYTE #%10000001
   BYTE #%00111001
   BYTE #%11110011
   BYTE #%11100111
   BYTE #%11001111
   BYTE #%10011001
   BYTE #%00000011
   BYTE #%11111111

; char 0xbb, 187
; char 0x9b, 155
   BYTE #%11100011
   BYTE #%11001111
   BYTE #%11011111
   BYTE #%10011111
   BYTE #%11011111
   BYTE #%11001111
   BYTE #%11100011
   BYTE #%11111111

; char 0xbc, 188
   BYTE #%11000111
   BYTE #%11110011
   BYTE #%11111011
   BYTE #%11111001
   BYTE #%11111011
   BYTE #%11110011
   BYTE #%11000111
   BYTE #%11111111

; char 0xbd, 189
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%11000111
   BYTE #%11000111
   BYTE #%11111111

; char 0xbe, 190
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xbf, 191
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xc0, 192
   BYTE #%00111000
   BYTE #%01101100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%01101100
   BYTE #%00111000
   BYTE #%00000000

; char 0xc1, 193
   BYTE #%00011000
   BYTE #%01111000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00111100
   BYTE #%00000000

; char 0xc2, 194
   BYTE #%01111100
   BYTE #%11000110
   BYTE #%00000110
   BYTE #%00011000
   BYTE #%00110000
   BYTE #%01100110
   BYTE #%11111110
   BYTE #%00000000

; char 0xc3, 195
   BYTE #%01111100
   BYTE #%11000110
   BYTE #%00000110
   BYTE #%00111100
   BYTE #%00001100
   BYTE #%00000110
   BYTE #%11000110
   BYTE #%01111100

; char 0xc4, 196
   BYTE #%00011100
   BYTE #%00111100
   BYTE #%01101100
   BYTE #%11001100
   BYTE #%11001100
   BYTE #%11111110
   BYTE #%00001100
   BYTE #%00001100

; char 0xc5, 197
   BYTE #%11111100
   BYTE #%11000110
   BYTE #%11000000
   BYTE #%11111100
   BYTE #%00000110
   BYTE #%00000110
   BYTE #%11001100
   BYTE #%01111000

; char 0xc6, 198
   BYTE #%00111100
   BYTE #%01100110
   BYTE #%11000000
   BYTE #%11111100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%01101100
   BYTE #%00111000

; char 0xc7, 199
   BYTE #%01111110
   BYTE #%11000110
   BYTE #%00000110
   BYTE #%00001100
   BYTE #%00011000
   BYTE #%00110000
   BYTE #%01100000
   BYTE #%11000000

; char 0xc8, 200
   BYTE #%00111000
   BYTE #%01101100
   BYTE #%11000110
   BYTE #%01111100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%01111100
   BYTE #%00000000

; char 0xc9, 201
   BYTE #%00111000
   BYTE #%01101100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%01111110
   BYTE #%00000110
   BYTE #%11001100
   BYTE #%01111000

; char 0xca, 202
   BYTE #%00111000
   BYTE #%01101100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11111110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%00000000

; char 0xcb, 203
   BYTE #%11111000
   BYTE #%11001100
   BYTE #%11001100
   BYTE #%11111000
   BYTE #%11001100
   BYTE #%11000110
   BYTE #%11111100
   BYTE #%00000000

; char 0xcc, 204
   BYTE #%00111100
   BYTE #%01100110
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%01100110
   BYTE #%00111100
   BYTE #%00000000

; char 0xcd, 205
   BYTE #%11111000
   BYTE #%11001100
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11000110
   BYTE #%11001100
   BYTE #%11111000
   BYTE #%00000000

; char 0xce, 206
   BYTE #%11111100
   BYTE #%11000110
   BYTE #%11000000
   BYTE #%11111000
   BYTE #%11000000
   BYTE #%11000110
   BYTE #%11111100
   BYTE #%00000000

; char 0xcf, 207
   BYTE #%11111100
   BYTE #%11000110
   BYTE #%11000000
   BYTE #%11111000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%11000000
   BYTE #%00000000

; char 0xd0, 208
   BYTE #%11000111
   BYTE #%10010011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%10010011
   BYTE #%11000111
   BYTE #%11111111

; char 0xd1, 209
   BYTE #%11100111
   BYTE #%10000111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%11100111
   BYTE #%11000011
   BYTE #%11111111

; char 0xd2, 210
   BYTE #%10000011
   BYTE #%00111001
   BYTE #%11111001
   BYTE #%11100111
   BYTE #%11001111
   BYTE #%10011001
   BYTE #%00000001
   BYTE #%11111111

; char 0xd3, 211
   BYTE #%10000011
   BYTE #%00111001
   BYTE #%11111001
   BYTE #%11000011
   BYTE #%11110011
   BYTE #%11111001
   BYTE #%00111001
   BYTE #%10000011

; char 0xd4, 212
   BYTE #%11100011
   BYTE #%11000011
   BYTE #%10010011
   BYTE #%00110011
   BYTE #%00110011
   BYTE #%00000001
   BYTE #%11110011
   BYTE #%11110011

; char 0xd5, 213
   BYTE #%00000011
   BYTE #%00111001
   BYTE #%00111111
   BYTE #%00000011
   BYTE #%11111001
   BYTE #%11111001
   BYTE #%00110011
   BYTE #%10000111

; char 0xd6, 214
   BYTE #%11000011
   BYTE #%10011001
   BYTE #%00111111
   BYTE #%00000011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%10010011
   BYTE #%11000111

; char 0xd7, 215
   BYTE #%10000001
   BYTE #%00111001
   BYTE #%11111001
   BYTE #%11110011
   BYTE #%11100111
   BYTE #%11001111
   BYTE #%10011111
   BYTE #%00111111

; char 0xd8, 216
   BYTE #%11000111
   BYTE #%10010011
   BYTE #%00111001
   BYTE #%10000011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%10000011
   BYTE #%11111111

; char 0xd9, 217
   BYTE #%11000111
   BYTE #%10010011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%10000001
   BYTE #%11111001
   BYTE #%00110011
   BYTE #%10000111

; char 0xda, 218
   BYTE #%11000111
   BYTE #%10010011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00000001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%11111111

; char 0xdb, 219
   BYTE #%00000111
   BYTE #%00110011
   BYTE #%00110011
   BYTE #%00000111
   BYTE #%00110011
   BYTE #%00111001
   BYTE #%00000011
   BYTE #%11111111

; char 0xdc, 220
   BYTE #%11000011
   BYTE #%10011001
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%10011001
   BYTE #%11000011
   BYTE #%11111111

; char 0xdd, 221
   BYTE #%00000111
   BYTE #%00110011
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00111001
   BYTE #%00110011
   BYTE #%00000111
   BYTE #%11111111

; char 0xde, 222
   BYTE #%00000011
   BYTE #%00111001
   BYTE #%00111111
   BYTE #%00000111
   BYTE #%00111111
   BYTE #%00111001
   BYTE #%00000011
   BYTE #%11111111

; char 0xdf, 223
   BYTE #%00000011
   BYTE #%00111001
   BYTE #%00111111
   BYTE #%00000111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%00111111
   BYTE #%11111111

; char 0xe0, 224
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000

; char 0xe1, 225
   BYTE #%00000000
   BYTE #%00101000
   BYTE #%10101011
   BYTE #%10101011
   BYTE #%10101011
   BYTE #%10101011
   BYTE #%00101000
   BYTE #%00000000

; char 0xe2, 226
   BYTE #%00010101
   BYTE #%10010101
   BYTE #%10010101
   BYTE #%10010101
   BYTE #%10101000
   BYTE #%00100000
   BYTE #%00100000
   BYTE #%10000000

; char 0xe3, 227
   BYTE #%01010101
   BYTE #%11010101
   BYTE #%01011101
   BYTE #%01010101
   BYTE #%01110101
   BYTE #%01010111
   BYTE #%11010101
   BYTE #%01011101

; char 0xe4, 228
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xe5, 229
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xe6, 230
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xe7, 231
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xe8, 232
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xe9, 233
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xea, 234
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xeb, 235
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xec, 236
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xed, 237
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xee, 238
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xef, 239
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xf0, 240
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000111
   BYTE #%00001111
   BYTE #%00011100
   BYTE #%00011000
   BYTE #%00011000

; char 0xf1, 241
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%11100000
   BYTE #%11110000
   BYTE #%00111000
   BYTE #%00011000
   BYTE #%00011000

; char 0xf2, 242
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011100
   BYTE #%00001111
   BYTE #%00000111
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000

; char 0xf3, 243
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00111000
   BYTE #%11110000
   BYTE #%11100000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000

; char 0xf4, 244
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000

; char 0xf5, 245
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000

; char 0xf6, 246
   BYTE #%00000001
   BYTE #%00000011
   BYTE #%00000111
   BYTE #%00001111
   BYTE #%00011111
   BYTE #%00111111
   BYTE #%01111111
   BYTE #%11111111

; char 0xf7, 247
   BYTE #%10000000
   BYTE #%11000000
   BYTE #%11100000
   BYTE #%11110000
   BYTE #%11111000
   BYTE #%11111100
   BYTE #%11111110
   BYTE #%11111111

; char 0xf8, 248
   BYTE #%11111111
   BYTE #%01111111
   BYTE #%00111111
   BYTE #%00011111
   BYTE #%00001111
   BYTE #%00000111
   BYTE #%00000011
   BYTE #%00000001

; char 0xf9, 249
   BYTE #%11111111
   BYTE #%11111110
   BYTE #%11111100
   BYTE #%11111000
   BYTE #%11110000
   BYTE #%11100000
   BYTE #%11000000
   BYTE #%10000000

; char 0xfa, 250
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000

; char 0xfb, 251
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%00000000
   BYTE #%11111111
   BYTE #%11111111
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000

; char 0xfc, 252
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%11111000
   BYTE #%11111000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000

; char 0xfd, 253
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011111
   BYTE #%00011111
   BYTE #%00011000
   BYTE #%00011000
   BYTE #%00011000

; char 0xfe, 254
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111

; char 0xff, 255
   BYTE #%11111111
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%10000001
   BYTE #%11111111
