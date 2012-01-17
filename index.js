require('mochiscript');

var fs = require('fs');
var SongParser = require('./song-parser');
var parser = new SongParser();

var files = fs.readdirSync("./samples");
for (var i=0; i<files.length; i++) {
  var file = files[i];
  if (file.match(/\.txt$/)) {
    var text = fs.readFileSync("./samples/" + file, 'utf8');
    console.log(parser.parse(text));
  }
}
