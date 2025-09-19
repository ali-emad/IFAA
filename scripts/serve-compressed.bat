@echo off
echo Starting local server with gzip compression support...
echo Server will be available at http://localhost:3002
echo.

cd build\web

REM Start a simple HTTP server with gzip support
python -m http.server 3002 --bind 127.0.0.1

echo Server stopped.