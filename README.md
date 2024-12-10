# 🔐 ENC_tool - Encode/Encrypt Tool  

**Version**: 1.0  
**Author**: [Trung Huynh](https://www.linkedin.com/in/trung-huynh-chi-pc01/)  

![Python](https://img.shields.io/badge/Python-3.8%2B-blue)  
![License](https://img.shields.io/badge/License-MIT-green)  
![Contributions](https://img.shields.io/badge/Contributions-Welcome-orange)  

---

## 📖 Description  

**ENC_tool** is a versatile and user-friendly encoding/encryption tool designed to handle a wide range of encoding and encryption methods, making it an indispensable utility for developers, security researchers, and cryptography enthusiasts.  

### 🎯 **Key Features**  

- **Encoding/Decoding**: Supports Base64, Hex, and Morse Code.  
- **Classic Ciphers**: Caesar Cipher, Vigenère Cipher, ROT13, ROT47.  
- **XOR Cipher**: Customizable key-based XOR encryption.  
- **Modern Encryption**: AES and DES algorithms for advanced security needs.  
- **Interactive CLI**: Easy-to-use interface for seamless operation.  

---

## 🚀 Installation  

### 1️⃣ **System Requirements**  

- **Operating System**: Linux (Ubuntu 20.04+ recommended).  
- **Python**: Version 3.8 or higher.  
- **Required Libraries**: `pycryptodome`, `prettytable`.  

### 2️⃣ **How to Install**  

1. Clone the repository:  
    ```bash
    git clone https://github.com/huynhtrungcip/ENC_tool.git
    cd ENC_tool
    ```  

2. Run the setup script:  
    ```bash
    dos2unix setup_enc_tool.sh
    chmod +x setup_enc_tool.sh
    ./setup_enc_tool.sh
    ```  

3. Activate the virtual environment and run the tool:  
    ```bash
    source venv/bin/activate
    python ENC_tool.py
    ```  

---

## 📋 Usage Guide  

### 🛠 How to Use the Tool  

1. Launch the tool from the command line:  
    ```bash
    python ENC_tool.py
    ```  

2. The main menu will appear:  
    ```
    ========================================
    =======================================
         ███████╗███╗   ██╗ ██████╗ 
         ██╔════╝████╗  ██║██╔════╝  
         █████╗  ██╔██╗ ██║██║
         ██╔══╝  ██║╚██╗██║██║ 
         ███████╗██║ ╚████║╚██████╔╝      
         ╚══════╝╚═╝  ╚═══╝ ╚═════╝       
    =======================================
    # Encode/Encrypt Version 1.0 by Beast Hunter
    ========================================
    | Option | Description                 |
    |--------|-----------------------------|
    | 1      | Base64 Encode/Decode        |
    | 2      | Hex Encode/Decode           |
    | 3      | Morse Code Encode/Decode    |
    | 4      | Caesar Cipher Encode/Decode |
    | 5      | Vigenère Cipher Encode/Decode|
    | 6      | ROT13 Encode/Decode         |
    | 7      | ROT47 Encode/Decode         |
    | 8      | XOR Cipher Encode/Decode    |
    | 9      | AES Encode/Decode           |
    | 10     | DES Encode/Decode           |
    | 0      | Exit                        |
    ========================================
    ```  

3. Choose an option (e.g., `1` for Base64 encoding/decoding).  
4. Follow the on-screen instructions to input text and, if required, a key.  

---

### 🧩 Examples  

#### Base64 Encoding Example  
```bash
Enter your choice (0 to exit): 1
Enter the text: HelloWorld
Do you want to encode or decode? (e/d): e
Result: SGVsbG9Xb3JsZA==

```
#### AES Decryption Example
```bash
Enter your choice (0 to exit): 9
Enter the text: <encrypted_text>
Enter key for AES (16 characters max): my_secure_key
Do you want to encode or decode? (e/d): d
Result: Decrypted message here
```

### 🪵 View Logs
For detailed error messages, check the Python error stack when running the script.

### 🤝 Contributions
Contributions are welcome! Feel free to fork the repository, submit pull requests, or open issues for bugs or feature requests.

### 👤 Author
Developed with ❤️ [Trung Huynh](https://www.linkedin.com/in/trung-huynh-chi-pc01/)  

🔗 LinkedIn Profile [Trung Huynh](https://www.linkedin.com/in/trung-huynh-chi-pc01/)
📧 For inquiries, contact via LinkedIn or GitHub, email: huynhchitrungcip@gmail.com

## 📄 License

This repository is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.

---

### 🌟 Support the Project
If you find this tool useful, give it a ⭐ on GitHub!
