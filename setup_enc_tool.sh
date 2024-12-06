#!/bin/bash

# ============================
# Script: Install ENC_tool
# Author: Trung Huynh - Beast Hunter
# Version: 1.0
# ============================

# ============================
# Section 1: Environment Setup
# ============================

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================"
echo -e "Starting ENC_tool Installation..."
echo -e "============================${NC}"

# Step 1: Update the package list and install python3-venv
echo -e "${YELLOW}Step 1: Updating package list and installing python3-venv...${NC}"
sudo apt update -y && sudo apt install python3-venv -y
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to install python3-venv. Please check your system.${NC}"
    exit 1
fi

# Step 2: Create a virtual environment
echo -e "${YELLOW}Step 2: Creating a Python virtual environment...${NC}"
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to create a virtual environment.${NC}"
    exit 1
fi

# Step 3: Activate the virtual environment
echo -e "${YELLOW}Step 3: Activating the virtual environment...${NC}"
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to activate the virtual environment.${NC}"
    exit 1
fi

# Step 4: Install required Python libraries
echo -e "${YELLOW}Step 4: Installing required Python libraries...${NC}"
pip install pycryptodome prettytable
echo "Installing colorama..."
pip install colorama

echo "colorama installation complete!"
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to install required Python libraries.${NC}"
    deactivate
    exit 1
fi

# ============================
# Section 2: Copy ENC_tool Code
# ============================

echo -e "${GREEN}Copying ENC_tool code to the current directory...${NC}"
cat <<EOF > ENC_tool.py
import base64
import binascii
from Crypto.Cipher import AES, DES
from Crypto.Util.Padding import pad, unpad
import codecs
from prettytable import PrettyTable
from colorama import Fore, Back, Style, init
def print_title():
    title = f"""
    ============================
         ███████╗███╗   ██╗ ██████╗       
         ██╔════╝████╗  ██║██╔════╝       
         █████╗  ██╔██╗ ██║██║       
         ██╔══╝  ██║╚██╗██║██║         
         ███████╗██║ ╚████║╚██████╔╝      
         ╚══════╝╚═╝  ╚═══╝ ╚═════╝       
    ============================ 
     {Fore.CYAN + Style.BRIGHT}Encode/Encrypt Version 1.0 by Beast Hunter{Style.RESET_ALL}
    """
    print(title)
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

init(autoreset=True)

def main_menu():
    # Create menu board
    menu_table = PrettyTable()
    menu_table.field_names = [f"{Fore.GREEN}Option", f"{Fore.CYAN}Description"]
    menu_table.align["Option"] = "l"  
    menu_table.align["Description"] = "l"  
    menu_table.max_width["Description"] = 70  
    menu_table.max_width["Option"] = 6  

    # Add rows to the menu table
    menu_table.add_row([f"{Fore.YELLOW}1", f"{Fore.WHITE}Base64 Encode/Decode"])
    menu_table.add_row([f"{Fore.YELLOW}2", f"{Fore.WHITE}Hex Encode/Decode"])
    menu_table.add_row([f"{Fore.YELLOW}3", f"{Fore.WHITE}Morse Code Encode/Decode"])
    menu_table.add_row([f"{Fore.YELLOW}4", f"{Fore.WHITE}Caesar Cipher Encode/Decode"])
    menu_table.add_row([f"{Fore.YELLOW}5", f"{Fore.WHITE}Vigenère Cipher Encode/Decode"])
    menu_table.add_row([f"{Fore.YELLOW}6", f"{Fore.WHITE}ROT13 Encode/Decode"])
    menu_table.add_row([f"{Fore.YELLOW}7", f"{Fore.WHITE}ROT47 Encode/Decode"])
    menu_table.add_row([f"{Fore.YELLOW}8", f"{Fore.WHITE}XOR Cipher Encode/Decode"])
    menu_table.add_row([f"{Fore.YELLOW}9", f"{Fore.WHITE}AES Encode/Decode"])
    menu_table.add_row([f"{Fore.YELLOW}10", f"{Fore.WHITE}DES Encode/Decode"])
    menu_table.add_row([f"{Fore.RED}0", f"{Fore.WHITE}Exit"])

    # Print boards with colors and effects
    print("\n")
    print(Fore.MAGENTA + "=" * 40)
    print(Fore.YELLOW + "          ENCODE/ENCRYPT TOOL")
    print(Fore.MAGENTA + "=" * 40)
    print(menu_table)
    print(Fore.MAGENTA + "=" * 40)

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
# Final notification after installation
echo -e "${GREEN}[✔] ENC_tool Installation Completed Successfully!${NC}"
echo -e "${YELLOW}To run the tool, use the following commands:${NC}"
echo -e "${RED}--------------------------------------------${NC}"
echo -e "${BOLD}${GREEN}source venv/bin/activate${NC}"
echo -e "${BOLD}${GREEN}python ENC_tool.py${NC}"
echo -e "${RED}--------------------------------------------${NC}"
echo -e "${YELLOW}Deactivating the virtual environment...${NC}"
echo ""
echo -e "${YELLOW}You are ready to go! Enjoy using ENC_tool.${NC}"


# Deactivate the virtual environment
echo "Deactivating the virtual environment..."
deactivate
