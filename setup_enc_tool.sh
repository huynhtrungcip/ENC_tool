#!/bin/bash

# ============================
# Script: Install ENC_tool
# Author: Trung Huynh
# Version: 1.0
# ============================

# ============================
# Section 1: Environment Setup
# ============================

echo "============================"
echo "Starting ENC_tool Installation..."
echo "============================"

# Cài đặt dos2unix (nếu chưa cài đặt)
echo "Step 1: Installing dos2unix (if not installed)..."
sudo apt install dos2unix -y
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dos2unix. Please check your system."
    exit 1
fi

# Chuyển đổi tập lệnh sang định dạng Unix (LF line endings)
echo "Step 2: Converting script to Unix line endings..."
dos2unix setup_enc_tool.sh
if [ $? -ne 0 ]; then
    echo "Error: Failed to convert script to Unix line endings."
    exit 1
fi

# Step 3: Update the package list and install python3-venv
echo "Step 3: Updating package list and installing python3-venv..."
sudo apt update -y && sudo apt install python3-venv -y
if [ $? -ne 0 ]; then
    echo "Error: Failed to install python3-venv. Please check your system."
    exit 1
fi

# Step 4: Create a virtual environment
echo "Step 4: Creating a Python virtual environment..."
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo "Error: Failed to create a virtual environment."
    exit 1
fi

# Step 5: Activate the virtual environment
echo "Step 5: Activating the virtual environment..."
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "Error: Failed to activate the virtual environment."
    exit 1
fi

# ============================
# Section 2: Copy ENC_tool Code
# ============================

echo "Copying ENC_tool code to the current directory..."
cat <<EOF > ENC_tool.py
import base64
import binascii
from Crypto.Cipher import AES, DES
from Crypto.Util.Padding import pad, unpad
import codecs
from prettytable import PrettyTable

def print_title():
    title = """
    ============================
         ███████╗███╗   ██╗ ██████╗       
         ██╔════╝████╗  ██║██╔════╝       
         █████╗  ██╔██╗ ██║██║       
         ██╔══╝  ██║╚██╗██║██║         
         ███████╗██║ ╚████║╚██████╔╝      
         ╚══════╝╚═╝  ╚═══╝ ╚═════╝       
    ============================ 
    Encode/Encrypt Version 1.0 by Trung Huynh
    """
    print(title)
# ============================
# Section 1: Utility Functions
# ============================
# Base64 Encoding and Decoding
def encode_base64(text):
    return base64.b64encode(text.encode()).decode()

def decode_base64(text):
    try:
        return base64.b64decode(text).decode()
    except binascii.Error:
        return None

# Hex Encoding and Decoding
def encode_hex(text):
    return text.encode().hex()

def decode_hex(text):
    try:
        return bytes.fromhex(text).decode()
    except ValueError:
        return None

# Morse Code Encoding and Decoding
MORSE_CODE_DICT = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.', 'G': '--.', 'H': '....',
    'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.', 'O': '---', 'P': '.--.',
    'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
    'Y': '-.--', 'Z': '--..',
    '1': '.----', '2': '..---', '3': '...--', '4': '....-', '5': '.....', '6': '-....', '7': '--...',
    '8': '---..', '9': '----.', '0': '-----', ' ': '/'
}

def encode_morse(text):
    return ' '.join(MORSE_CODE_DICT.get(char.upper(), '') for char in text)

def decode_morse(text):
    reverse_dict = {v: k for k, v in MORSE_CODE_DICT.items()}
    return ''.join(reverse_dict.get(char, '') for char in text.split())

# ============================
# Section 2: Cipher Algorithms
# ============================
# Caesar Cipher
def encode_caesar(text, shift):
    return ''.join(
        chr((ord(char) + shift - 65) % 26 + 65) if char.isupper() else
        chr((ord(char) + shift - 97) % 26 + 97) if char.islower() else char
        for char in text
    )

def decode_caesar(text, shift):
    return encode_caesar(text, -shift)

# Vigenère Cipher
def encode_vigenere(text, key):
    key = key.lower()
    return ''.join(
        chr((ord(char) + ord(key[i % len(key)]) - 2 * 97) % 26 + 97)
        if char.islower() else char
        for i, char in enumerate(text)
    )

def decode_vigenere(text, key):
    key = key.lower()
    return ''.join(
        chr((ord(char) - ord(key[i % len(key)]) + 26) % 26 + 97)
        if char.islower() else char
        for i, char in enumerate(text)
    )

# ROT13 and ROT47
def encode_rot13(text):
    return codecs.encode(text, 'rot_13')

def decode_rot13(text):
    return encode_rot13(text)

def encode_rot47(text):
    return ''.join(
        chr(33 + ((ord(char) + 14) % 94)) if 33 <= ord(char) <= 126 else char
        for char in text
    )

def decode_rot47(text):
    return encode_rot47(text)

# XOR Cipher
def encode_xor(text, key):
    return ''.join(chr(ord(c) ^ ord(key[i % len(key)])) for i, c in enumerate(text))

def decode_xor(text, key):
    return encode_xor(text, key)

# AES and DES Encryption
def encode_aes(text, key):
    cipher = AES.new(key.ljust(16).encode(), AES.MODE_CBC)
    ct_bytes = cipher.encrypt(pad(text.encode(), AES.block_size))
    return base64.b64encode(cipher.iv + ct_bytes).decode()

def decode_aes(text, key):
    try:
        raw = base64.b64decode(text)
        iv = raw[:16]
        cipher = AES.new(key.ljust(16).encode(), AES.MODE_CBC, iv)
        return unpad(cipher.decrypt(raw[16:]), AES.block_size).decode('utf-8')
    except Exception as e:
        return f"AES decryption failed: {e}"

def encode_des(text, key):
    cipher = DES.new(key.ljust(8).encode(), DES.MODE_ECB)
    ct_bytes = cipher.encrypt(pad(text.encode(), DES.block_size))
    return base64.b64encode(ct_bytes).decode()

def decode_des(text, key):
    try:
        ct = base64.b64decode(text)
        cipher = DES.new(key.ljust(8).encode(), DES.MODE_ECB)
        return unpad(cipher.decrypt(ct), DES.block_size).decode('utf-8')
    except Exception as e:
        return f"DES decryption failed: {e}"

# ============================
# Section 3: Main Program
# ============================
def encode_text(text, method, key=None):
    if method == "base64":
        return encode_base64(text)
    elif method == "hex":
        return encode_hex(text)
    elif method == "morse":
        return encode_morse(text)
    elif method == "caesar":
        return encode_caesar(text, int(key))
    elif method == "vigenere":
        return encode_vigenere(text, key)
    elif method == "rot13":
        return encode_rot13(text)
    elif method == "rot47":
        return encode_rot47(text)
    elif method == "xor":
        return encode_xor(text, key)
    elif method == "aes":
        return encode_aes(text, key)
    elif method == "des":
        return encode_des(text, key)

def decode_text(text, method, key=None):
    if method == "base64":
        return decode_base64(text)
    elif method == "hex":
        return decode_hex(text)
    elif method == "morse":
        return decode_morse(text)
    elif method == "caesar":
        return decode_caesar(text, int(key))
    elif method == "vigenere":
        return decode_vigenere(text, key)
    elif method == "rot13":
        return decode_rot13(text)
    elif method == "rot47":
        return decode_rot47(text)
    elif method == "xor":
        return decode_xor(text, key)
    elif method == "aes":
        return decode_aes(text, key)
    elif method == "des":
        return decode_des(text, key)

def main_menu():
    menu_table = PrettyTable()
    menu_table.field_names = ["Option", "Description"]
    menu_table.align["Option"] = "l"
    menu_table.align["Description"] = "l"

    menu_table.add_row(["1", "Base64 Encode/Decode"])
    menu_table.add_row(["2", "Hex Encode/Decode"])
    menu_table.add_row(["3", "Morse Code Encode/Decode"])
    menu_table.add_row(["4", "Caesar Cipher Encode/Decode"])
    menu_table.add_row(["5", "Vigenère Cipher Encode/Decode"])
    menu_table.add_row(["6", "ROT13 Encode/Decode"])
    menu_table.add_row(["7", "ROT47 Encode/Decode"])
    menu_table.add_row(["8", "XOR Cipher Encode/Decode"])
    menu_table.add_row(["9", "AES Encode/Decode"])
    menu_table.add_row(["10", "DES Encode/Decode"])
    menu_table.add_row(["0", "Exit"])
    
    print("\n")
    print("=" * 40)
    print("          ENCODE/ENCRYPT TOOL")
    print("=" * 40)
    print(menu_table)
    print("=" * 40)

def main():
    while True:
        main_menu()
        try:
            choice = int(input("Enter your choice (0 to exit): "))
            if choice == 0:
                print("Thank you for using the tool. Goodbye!")
                break

            elif choice in range(1, 11):
                text = input("Enter the text: ")
                key = None
                method = ""

                if choice == 1:
                    method = "base64"
                elif choice == 2:
                    method = "hex"
                elif choice == 3:
                    method = "morse"
                elif choice == 4:
                    method = "caesar"
                    key = input("Enter shift value for Caesar Cipher: ")
                elif choice == 5:
                    method = "vigenere"
                    key = input("Enter key for Vigenère Cipher: ")
                elif choice == 6:
                    method = "rot13"
                elif choice == 7:
                    method = "rot47"
                elif choice == 8:
                    method = "xor"
                    key = input("Enter key for XOR Cipher: ")
                elif choice == 9:
                    method = "aes"
                    key = input("Enter key for AES (16 characters max): ")
                elif choice == 10:
                    method = "des"
                    key = input("Enter key for DES (8 characters max): ")

                action = input("Do you want to encode or decode? (e/d): ").lower()
                if action == "e":
                    result = encode_text(text, method, key)
                elif action == "d":
                    result = decode_text(text, method, key)
                else:
                    print("Invalid action. Please choose 'e' or 'd'.")
                    continue

                print(f"Result: {result}")
            else:
                print("Invalid choice. Please try again.")
        except Exception as e:
            print(f"Error: {e}. Please try again.")

if __name__ == "__main__":
    print_title()
    main()

EOF

if [ $? -ne 0 ]; then
    echo "Error: Failed to create ENC_tool.py."
    deactivate
    exit 1
fi

# ============================
# Section 3: Finishing Setup
# ============================

echo "ENC_tool Installation Completed Successfully!"
echo "To run the tool, use the following commands:"
echo "--------------------------------------------"
echo "source venv/bin/activate"
echo "python ENC_tool.py"
echo "--------------------------------------------"

# Deactivate virtual environment for safety
deactivate
