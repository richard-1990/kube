const http = require("http");

const handleRequest = (request, response) => {
  console.log("Received request for URL: " + request.url);
  console.log(process.env);
  response.writeHead(200);
  response.end("Hello World, from kubernetes, docker and  ME");
};
var app = http.createServer(handleRequest);
app.listen(9000);
