import subprocess
import re

def get_open_ports(ip):
    # Run nmap to scan for open ports
    result = subprocess.run(['nmap', '-p-', ip], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = result.stdout.decode()
    
    # Use regex to find open ports
    open_ports = re.findall(r'(\d+)/tcp\s+open', output)
    
    return open_ports

def get_most_active_port(ip):
    # Run netstat to find the most active port
    result = subprocess.run(['netstat', '-an'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = result.stdout.decode()
    
    # Use regex to find active ports and count occurrences
    ports = re.findall(rf'{ip}:(\d+)', output)
    port_count = {}
    
    for port in ports:
        if port in port_count:
            port_count[port] += 1
        else:
            port_count[port] = 1
    
    # Find the most active port
    most_active_port = max(port_count, key=port_count.get)
    
    return most_active_port

def main(ip):
    open_ports = get_open_ports(ip)
    most_active_port = get_most_active_port(ip)
    
    # Format the output
    formatted_ports = []
    for port in open_ports:
        if port == most_active_port:
            formatted_ports.append(f"[{port}]")
        else:
            formatted_ports.append(port)
    
    print("Open ports:", ', '.join(formatted_ports))

if __name__ == "__main__":
    # Replace '127.0.0.1' with the IP address of the client you want to scan
    client_ip = '127.0.0.1'
    main(client_ip)
