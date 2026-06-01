from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import serialization

#Funkcja która generuje parę kluczy (prywatny i publiczny) do podpisywania
def generate_key_pair():
    #Generowanie klucza prywatnego RSA o rozmiarze 2048 bitów
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048
    )
    #Uzyskanie klucza publicznego z klucza prywatnego
    public_key = private_key.public_key()
    
    return private_key, public_key

#Funkcja która podpisuje plik za pomocą klucza prywatnego
def sign_file(file_path: str, private_key) -> bytes:
    try:
        with open(file_path, 'rb') as f:
            file_data = f.read()
    except FileNotFoundError:
        print(f"Nie znaleziono pliku {file_path}. Sprawdź ścieżkę i spróbuj ponownie.")
        exit(-1)
    except Exception as e:
        print(f"Wystąpił błąd: {e}")
        exit(-1)
        
    #Podpisywanie danych z pliku za pomocą klucza prywatnego i odpowiedniego paddingu oraz funkcji skrótu
    #Używamy PSS (Probabilistic Signature Scheme) z MGF1 i SHA256 jako funkcji skrótu
    #mgf=padding.MGF1(hashes.SHA256()) - określa funkcję maskującą, która jest częścią schematu PSS
    #salt_length=padding.PSS.MAX_LENGTH - określa długość soli, która jest używana w schemacie PSS. MAX_LENGTH oznacza, że długość soli będzie maksymalna możliwa dla danego rozmiaru klucza.
    signature = private_key.sign(
        file_data,
        padding.PSS(
            mgf=padding.MGF1(hashes.SHA256()),
            salt_length=padding.PSS.MAX_LENGTH
        ),
        hashes.SHA256()#Używamy SHA256 jako funkcji skrótu do obliczenia skrótu danych, który jest następnie podpisywany.
    )
    
    #Zapis podpisu do pliku z rozszerzeniem .sig
    try:
        with open(file_path + '.sig', 'wb') as f:
            f.write(signature)
    except Exception as e:
        print(f"Wystąpił błąd podczas zapisu podpisu: {e}")
        exit(-1)

    print(f"Plik podpisany pomyślnie! Podpis zapisany do {file_path}.sig")
    return signature

#Funkcja która weryfikuje podpis pliku za pomocą klucza publicznego
def verify_file_signature(file_path: str, signature_path: str, public_key) -> bool:
    #Czytanie danych z pliku, który chcemy zweryfikować
    try:    
        with open(file_path, 'rb') as f:
            file_data = f.read()
    except FileNotFoundError:
        print(f"Nie znaleziono pliku {file_path}. Sprawdź ścieżkę i spróbuj ponownie.")
        return False
    except Exception as e:
        print(f"Wystąpił błąd: {e}")
        return False

    # Czytanie podpisu z pliku .sig
    try:
        with open(signature_path, 'rb') as f:
            signature = f.read()
    except FileNotFoundError:
        print(f"Nie znaleziono pliku podpisu {signature_path}. Sprawdź ścieżkę i spróbuj ponownie.")
        return False
    except Exception as e:
        print(f"Wystąpił błąd: {e}")
        return False

    #Weryfikacja podpisu za pomocą klucza publicznego.
    try:
        #public_key.verify() - metoda, która sprawdza, czy dany podpis jest prawidłowy dla określonych danych i klucza publicznego.
        #signature - podpis, który chcemy zweryfikować.
        #file_data - dane, które były podpisane. Weryfikacja polega na sprawdzeniu, czy podpis jest zgodny z tymi danymi.
        #padding.PSS(...) - określa schemat paddingu używany podczas podpisywania. W tym przypadku używamy PSS z MGF1 i SHA256.
        #hashes.SHA256() - określa funkcję skrótu używaną podczas podpisywania. W tym przypadku używamy SHA256.        
        public_key.verify(
            signature,
            file_data,
            padding.PSS(
                mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.MAX_LENGTH
            ),
            hashes.SHA256()
        )
        print(f"Weryfikacja zakończona pomyślnie: Plik {file_path} jest autentyczny i nie został zmieniony.")
        return True
    except Exception:
        print(f"Weryfikacja nie powiodła się: Plik {file_path} lub podpis został zmieniony!")
        return False

if __name__ == "__main__":
    #Inicjalizacja i wybór operacji
    choice = input("Czy chcesz (P)odpisać czy (W)eryfikować plik (P/W)? ").upper()
    target_file = input("Podaj ścieżkę do pliku, który chcesz podpisać: ")
    
    if choice == 'P':
        #Generowanie pary kluczy
        priv_key, pub_key = generate_key_pair()
        
        #podpisywanie pliku i weryfikacja podpisu
        sign_file(target_file, priv_key)
        verify_file_signature(target_file, target_file + ".sig", pub_key)
        
        #Wyświetlenie kluczy w formacie PEM
        #public_bytes(encoding=serialization.Encoding.PEM, format=serialization.PublicFormat.SubjectPublicKeyInfo) - metoda, która zwraca klucz publiczny w formacie PEM (Privacy-Enhanced Mail).
        #serialization.Encoding.PEM - określa format kodowania PEM, który jest popularnym formatem do przechowywania kluczy kryptograficznych.
        #serialization.PublicFormat.SubjectPublicKeyInfo - określa format, w jakim klucz publiczny będzie zapisany. SubjectPublicKeyInfo to standardowy format, który zawiera informacje o algorytmie i samej wartości klucza.
        print(f"Publiczny klucz do weryfikacji podpisu:\n{pub_key.public_bytes(encoding=serialization.Encoding.PEM, format=serialization.PublicFormat.SubjectPublicKeyInfo).decode()}")
        
        #private_bytes(encoding=serialization.Encoding.PEM, format=serialization.PrivateFormat.TraditionalOpenSSL, encryption_algorithm=serialization.NoEncryption()) - metoda, która zwraca klucz prywatny w formacie PEM.
        #serialization.PrivateFormat.TraditionalOpenSSL - określa format, w jakim klucz prywatny będzie zapisany. TraditionalOpenSSL to format, który jest zgodny z tradycyjnym formatem używanym przez OpenSSL.
        #serialization.NoEncryption() - określa, że klucz prywatny nie będzie szyfrowany.
        print(f"Klucz prywatny do podpisywania:\n{priv_key.private_bytes(encoding=serialization.Encoding.PEM, format=serialization.PrivateFormat.TraditionalOpenSSL, encryption_algorithm=serialization.NoEncryption()).decode()}")
    elif choice == 'W':
        pub_key = input("Podaj klucz publiczny do weryfikacji podpisu (PEM format): ")
        verify_file_signature(target_file, target_file + ".sig", pub_key)
    else:
        print("Nieprawidłowy wybór. Wybierz P lub W.")
        exit(-1)