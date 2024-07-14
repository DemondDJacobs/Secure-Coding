import socket
import ssl

# Define server address and port
server_address = ('localhost', 8877)

# Create a socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Wrap the socket with SSL
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile='server.crt', keyfile='server.key')
secure_sock = context.wrap_socket(sock, server_side=True)

# Bind and listen
secure_sock.bind(server_address)
secure_sock.listen(5)
print("Server is listening on port 8877...")

try:
    while True:
        # Accept a connection
        client_socket, client_address = secure_sock.accept()
        print(f"Connection from {client_address}")

        try:
            while True:
                # Receive data
                data = client_socket.recv(1024)
                if data:
                    print(f"Received: {data.decode('utf-8')}")
                    # Send data back to the client
                    client_socket.sendall(b"Hello, client!")
                else:
                    break
        finally:
            client_socket.close()
finally:
    secure_sock.close()
