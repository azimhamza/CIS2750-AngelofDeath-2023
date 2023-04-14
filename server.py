import io
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
import molsql
import json

# Define our own handler class that extends BaseHTTPRequestHandler
class MyHandler(BaseHTTPRequestHandler):
    def __init__(self, molsql_instance, *args, **kwargs):
        self.molsql_instance = molsql.Database()
        super().__init__(*args, **kwargs)

    # Handle GET requests
    def do_GET(self):
        if self.path == "/":
            message = "MolSQL API is running."
            # Send a 200 OK response and set the Content-type header to text/plain
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            # Set the length of the response body
            self.send_header("Content-length", len(message))
            self.end_headers()
            # Write the message to the response body
            self.wfile.write(bytes(message, "utf-8"))
        
        # Handle requests for the molecule list
        elif self.path == "/molecule_list":
            molecule_list = self.molsql_instance.get_all_molecules()
            molecule_list_json = json.dumps(molecule_list)

            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.send_header("Content-length", len(molecule_list_json))
            self.end_headers()
            self.wfile.write(bytes(molecule_list_json, "utf-8"))

        # Handle requests for the element list
        elif self.path == "/element_list":
            element_list = self.molsql_instance.get_all_elements()
            element_list_json = json.dumps(element_list)

            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.send_header("Content-length", len(element_list_json))
            self.end_headers()
            self.wfile.write(bytes(element_list_json, "utf-8"))




    # Handle POST requests
    def do_POST(self):
        if self.path == "/molecule":
            content_length = int(self.headers.get("Content-length"))
            post_data = self.rfile.read(content_length)
            post_data_json = json.loads(post_data.decode('utf-8'))

            molecule_name = post_data_json['molecule_name']
            file_content = post_data_json['file_content']

            text_io = io.StringIO(file_content)
            self.molsql_instance.add_molecule(molecule_name, text_io)

            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            success_message = f"Molecule {molecule_name} added to the database"
            self.send_header("Content-length", len(success_message))
            self.end_headers()

            self.wfile.write(bytes(success_message, "utf-8"))

        elif self.path == "/add_element":
            content_length = int(self.headers.get("Content-length"))
            post_data = self.rfile.read(content_length)
            post_data_json = json.loads(post_data.decode('utf-8'))

            name = post_data_json['name']
            symbol = post_data_json['symbol']
            colorVal1 = post_data_json['colorVal1']
            colorVal2 = post_data_json['colorVal2']
            colorVal3 = post_data_json['colorVal3']
            radius = post_data_json['radius']

            self.molsql_instance.add_element(name, symbol, colorVal1, colorVal2, colorVal3, radius)

            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            success_message = f"Element {name} added to the database"
            self.send_header("Content-length", len(success_message))
            self.end_headers()
            self.wfile.write(bytes(success_message, "utf-8"))
            

        elif self.path == '/remove_element':
            content_length = int(self.headers.get("Content-length"))
            post_data = self.rfile.read(content_length)
            post_data_json = json.loads(post_data.decode('utf-8'))

            symbol = post_data_json['symbol']

            self.molsql_instance.remove_element(symbol)

            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            success_message = f"Element {symbol} removed from the database"
            self.send_header("Content-length", len(success_message))
            self.end_headers()
            self.wfile.write(bytes(success_message, "utf-8"))

        elif self.path == '/load_molecule':
            content_length = int(self.headers.get("Content-length"))
            post_data = self.rfile.read(content_length)
            post_data_json = json.loads(post_data.decode('utf-8'))

            molecule_name = post_data_json['molecule_name']

            svg_content = self.molsql_instance.load_molecule(molecule_name)

            self.send_response(200)
            self.send_header("Content-type", "image/svg+xml")
            self.send_header("Content-length", len(svg_content))
            self.end_headers()
            self.wfile.write(bytes(svg_content, "utf-8"))
        ## count atoms and bonds

        elif self.path == '/count_atom-bonds':
            content_length = int(self.headers.get("Content-length"))
            post_data = self.rfile.read(content_length)
            post_data_json = json.loads(post_data.decode('utf-8'))

            molecule_name = post_data_json['molecule_name']

            atom_bonds = self.molsql_instance.count_atom_bonds(molecule_name)

            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.send_header("Content-length", len(atom_bonds))
            self.end_headers()
            self.wfile.write(bytes(atom_bonds, "utf-8"))

        elif self.path == '/count_elements':
            content_length = int(self.headers.get("Content-length"))
            post_data = self.rfile.read(content_length)
            post_data_json = json.loads(post_data.decode('utf-8'))

            molecule_name = post_data_json['molecule_name']

            elements = self.molsql_instance.count_elements(molecule_name)

            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.send_header("Content-length", len(elements))
            self.end_headers()
            self.wfile.write(bytes(elements, "utf-8"))

       

        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(bytes("404: not found", "utf-8"))

# Instantiate the molsql object
molsql_instance = molsql.Database()

# Define the HTTP server to listen on the specified port and use our handler
httpd = HTTPServer(('localhost', int(sys.argv[1])), lambda *args, **kwargs: MyHandler(molsql_instance, *args, **kwargs))

# Print the server address to let user know where to connect
print(f"Server running at http://localhost:{sys.argv[1]}")
# Start the server and keep it running indefinitely
httpd.serve_forever()


