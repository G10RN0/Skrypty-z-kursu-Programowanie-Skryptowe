from cryptography.fernet import Fernet

#Funkcja która generuje klucz szyfrujący
def generate_key():
    key = Fernet.generate_key()
    return key

#Funkcja która szyfruje plik i zapisuje go z rozszerzeniem .enc
def encrypt_file(file_path, key):
    try:
        #czytanie danych z pliku
        file = open(file_path, 'rb')
        file_data = file.read()
        file.close()
        
        #tworzenie obiektu Fernet z kluczem
        fernet = Fernet(key)
        #szyfrowanie danych z pliku
        encrypted_data = fernet.encrypt(file_data)
        
        #zapis zaszyfrowanych danych do nowego pliku z rozszerzeniem .enc
        with open(file_path + '.enc', 'wb') as encrypted_file:
            encrypted_file.write(encrypted_data)
    except FileNotFoundError:
        print("Nie znaleziono pliku. Sprawdź ścieżkę i spróbuj ponownie.")
        exit(-1)
    except Exception as e:
        print(f"Wystąpił błąd: {e}")
        exit(-1)

#Funkcja która odszyfrowuje plik z rozszerzeniem .enc i zapisuje go bez rozszerzenia
def decrypt_file(file_path, key):
    try:
        #czytanie zaszyfrowanych danych z pliku
        encrypted_file = open(file_path, 'rb')
        encrypted_data = encrypted_file.read()
        encrypted_file.close()
        
        #tworzenie obiektu Fernet z kluczem
        fernet = Fernet(key)
        #odszyfrowanie danych z pliku
        decrypted_data = fernet.decrypt(encrypted_data)
        
        #zapis odszyfrowanych danych do nowego pliku bez rozszerzenia .enc
        with open(file_path.replace('.enc', ''), 'wb') as decrypted_file:
            decrypted_file.write(decrypted_data)
    except FileNotFoundError:
        print("Nie znaleziono pliku. Sprawdź ścieżkę i spróbuj ponownie.")
        exit(-1)
    except Exception as e:
        print(f"Wystąpił błąd: {e}")
        exit(-1)

if __name__ == "__main__":
    #Incjalizaccja i wybór operacji
    choice = input("Czy chcesz (S)zyfrować czy (O)dszyfrować plik (S/O)? ").upper()
    file_path = input("Podaj ścieżkę do pliku: ")


    if choice == 'S':
        #Generowanie klucza, szyfrowanie pliku i wyświetlenie klucza
        key = generate_key()
        encrypt_file(file_path, key)
        print(f"Plik zaszyfrowany pomyślnie. Klucz: {key.decode()}")
    elif choice == 'O':
        #Podanie klucza, odszyfrowanie pliku
        key = input("Podaj klucz: ").encode()
        decrypt_file(file_path, key)
        print("Plik odszyfrowany pomyślnie.")
    else:
        print("Nieprawidłowy wybór. Wybierz S lub O.")