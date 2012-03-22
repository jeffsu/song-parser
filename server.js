var fs = require('fs');
var http = require('http');
var url = require('url'); 
 

function start(route, handle) {
  function onRequest(request, response) {
    console.log("Starting server");

    var pathname = url.parse(request.url).pathname;
    console.log("Request for " + pathname + " received"); 
    var songtext = "";
    request.setEncoding("utf8"); 

    var first = true; 
    var counter = 0;  
    request.addListener("data", function(songtextchunk) {
      counter++; 
      console.log(songtextchunk + "\n"); 
      if (first) {
        songtextchunk = songtextchunk.replace("text=", "");
        first = false;  
      }
      songtextchunk = songtextchunk.split("+").join(" "); 
      songtextchunk = songtextchunk.split("%0D%0A").join("\n");
      songtext += songtextchunk 
    }); 

    request.addListener("end", function() {
      console.log("Counter: " + counter); 
      route(handle, pathname, response, songtext);
      first = true;  
    }); 

    fs.readFile('./parser.html', function (error, content) {
      if(error) {
        console.log("can't find file!");
        response.writeHead(500);
        response.end(); 
      }
      else {
        response.writeHead(200, { 'Content-type': 'text/html' } ); 
        response.end(content, 'utf-8'); 
      }
    }); 
  }
  
  http.createServer(onRequest).listen(8080);
  console.log("Server is running on port 8080");   
} 

exports.start = start;  
