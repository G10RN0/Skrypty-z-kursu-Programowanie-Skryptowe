import requests
import time

with open("lab 12/sqli-fuzz.txt", "r") as f:
    PAYLOAD = [line.strip() for line in f.readlines() if line.strip()]

POST = {
    "http://localhost:3000/rest/user/login" : ["email", "password"]
}

HEADERS = {

}

def scan_sql_injection(payoload, post_endpoints, headers):
    for payload in PAYLOAD:
        for endpoint, params in POST.items():
            data = ["temp"]*len(params)
            for i in range(len(params), 0, -1):
                try:
                    data[i-1] = payload
                    post_data = {params[j]: data[j] for j in range(len(params))}

                    start_time = time.time()
                    if HEADERS == {}:
                        response = requests.post(endpoint, json=post_data)
                    else:
                        response = requests.post(endpoint, json=post_data, headers=HEADERS)
                    end_time = time.time()
                    elapsed_time = end_time - start_time

                    if elapsed_time > 5:
                        print(f"Potential SQL Injection found at {endpoint} with payload: {payload}, injected parameter in: {params[i-1]} (Response time: {elapsed_time:.2f} seconds)")

                    if response.status_code == 500 or response.status_code == 200:
                        print(f"Potential SQL Injection found at {endpoint} with payload: {payload}, injected parameter in: {params[i-1]}")
                except requests.exceptions.Timeout as e:
                    print(f"Timeout occurred at {endpoint} with payload: {payload}, injected parameter in: {params[i-1]}") 
                except Exception as e:
                    print(f"Error occurred at {endpoint} with payload: {payload}, injected parameter in: {params[i-1]} - {str(e)}")

if __name__ == "__main__":
    scan_sql_injection(PAYLOAD, POST, HEADERS)