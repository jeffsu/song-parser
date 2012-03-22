require('mochiscript'); 
var SongParser = require('./song-parser');
var querystring = require('querystring');  
var parser = new SongParser(); 

function start(response, songtext) {
  console.log("Request handler 'Start' was called"); 
}

function parse(response, songtext) {
  console.log("Request handler 'Parse' was called");
  response.writeHead(200, {"Content-Type" : "text/html"});
  var stanzas = parser.parse(songtext);
  if (stanzas) { 
    for (var i=0; i<stanzas.length; i++) {
      response.write(stanzas[i].type + " " + stanzas[i].number + "<br /><br />");
      var lines = stanzas[i].lines; 
      for (var j=0; j<lines.length; j++) {
        response.write(lines[j][0] + ":&#160;&#160;&#160" + lines[j][1] + "<br />");
      }    
    }
  } 
  else {
    response.write("Not a song!"); 
  }
  response.end(); 
}

exports.parse = parse;
exports.start = start;
