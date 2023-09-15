const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
  // Set the content type to HTML
  res.setHeader('Content-Type', 'text/html');

  // Read the contents of index.html
  fs.readFile(path.join(__dirname, 'index.html'), 'utf8', (err, data) => {
    if (err) {
      // Handle error, e.g., send a 500 Internal Server Error
      res.statusCode = 500;
      res.end('Internal Server Error');
      return;
    }

    // Send the HTML content to the client
    res.statusCode = 200;
    res.end(data);
  });
});

const port = process.env.PORT || 3000; // Use port 3000 by default

server.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
