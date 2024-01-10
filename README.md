CPP web backend

1. docker build --rm --no-cache -t bbox:latest .
2. docker run -dit -v '/Users/hans/Desktop/code/cpp/projects/cppbox/volume':'/usr/src/cppweb' -p 8080:8080 -e PORT=8080 -e MONGODB_URI="localhost:27017" bbox:latest sh
