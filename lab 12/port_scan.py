import socket
import sys
from concurrent.futures import ThreadPoolExecutor

def scan_port(ip, port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(1)  # Set a timeout for the connection attempt
            result = s.connect_ex((ip, port))
            if result == 0:
                try:
                    service = socket.getservbyport(port, 'tcp')
                    print(f"Port {port} is open. Service: {service}")
                except OSError:
                    print(f"Port {port} is open. Service: Unknown")

if __name__ == "__main__":
    ip = input("podaj adres IP: ")
    port_range = input("podaj zakres portów do skanowania (np. 1-1000, lub 80,443): ")
    if '-' in port_range:
        start_port, end_port = map(int, port_range.split('-'))
        ports_to_scan = range(start_port, end_port + 1)            
    elif ',' in port_range:
        ports_to_scan = map(int, port_range.split(','))
    else:
        print("Nieprawidłowy format zakresu portów. Proszę użyć 'początek-koniec' lub 'port1,port2,...'")
        exit(-1)
        
    try:
        with ThreadPoolExecutor(max_workers=20) as executor:
            for port in ports_to_scan:
                executor.submit(scan_port, ip, port)
    except KeyboardInterrupt:
        print("\nSkanowanie przerwane przez użytkownika.")
        sys.exit(0)