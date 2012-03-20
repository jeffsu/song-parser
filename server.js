require('mochiscript'); 

var fs = require('fs');
var http = require('http');
var url = require('url'); 
 
var SongParser = require('./song-parser'); 
var parser = new SongParser(); 

function start(route, handle) {
  function onRequest(request, response) {
    console.log("Starting server");

    var pathname = url.parse(request.url).pathname;
    console.log("Request for " + pathname + " received"); 
    var songtext = "";
    request.setEncoding("utf8"); 

    request.addListener("data", function(songtextchunk) {
      songtext += songtextchunk; 
    }); 

    request.addListener("end", function() {
      route(handle, pathname, response, songtext); 
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
