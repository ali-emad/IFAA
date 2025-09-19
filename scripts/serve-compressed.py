import http.server
import socketserver
import gzip
import os
from pathlib import Path

class GzipHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Add CORS headers
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        super().end_headers()

    def guess_type(self, path):
        # Ensure proper MIME types
        mimetype = super().guess_type(path)
        if mimetype is None:
            # Handle common extensions
            if path.endswith('.js'):
                mimetype = 'application/javascript'
            elif path.endswith('.json'):
                mimetype = 'application/json'
            elif path.endswith('.wasm'):
                mimetype = 'application/wasm'
            else:
                mimetype = 'text/plain'
        return mimetype

    def do_GET(self):
        # Get the file path
        file_path = self.translate_path(self.path)
        
        # Check if the file exists
        if os.path.exists(file_path) and not os.path.isdir(file_path):
            # Check if a gzipped version exists
            gzipped_path = file_path + '.gz'
            if os.path.exists(gzipped_path):
                # Serve the gzipped version
                self.send_response(200)
                self.send_header('Content-Encoding', 'gzip')
                self.send_header('Content-Type', self.guess_type(file_path))
                self.send_header('Cache-Control', 'public, max-age=31536000')  # 1 year for static assets
                self.end_headers()
                
                with open(gzipped_path, 'rb') as f:
                    self.wfile.write(f.read())
                return
        
        # Serve uncompressed file if no gzip version exists
        super().do_GET()

# Run the server
if __name__ == "__main__":
    PORT = 3002  # Changed from 3001 to 3002 to avoid port conflicts
    
    # Change to the build/web directory
    os.chdir(Path(__file__).parent.parent / "build" / "web")
    
    with socketserver.TCPServer(("", PORT), GzipHTTPRequestHandler) as httpd:
        print(f"Serving at http://localhost:{PORT}")
        print("Server includes gzip compression support for faster loading")
        print("Press Ctrl+C to stop the server")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")