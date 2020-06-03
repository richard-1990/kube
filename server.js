const http = require("http");

const handleRequest = (request, response) => {
  console.log("Received request for URL: " + request.url);
  console.log(process.env);
  response.writeHead(200);
  response.end("my super cool api thingy");
};
var app = http.createServer(handleRequest);
app.listen(9000);
