require('mochiscript'); 
var SongParser = require('./song-parser');
var querystring = require('querystring');  
var parser = new SongParser(); 

function start(response, songtext) {
  console.log("Request handler 'Start' was called"); 
}

function parse(response, songtext) {
  console.log("Request handler 'Parse' was called");
  response.writeHead(200, {"Content-Type" : "text/plain"});
  var song = parser.parse(songtext);
  if (song) {  
    for (var stanza in song) {
      response.write(stanza); 
    }
  } 
  else {
    response.write("Not a song!"); 
  }
  response.end(); 
}

exports.parse = parse;
exports.start = start;
