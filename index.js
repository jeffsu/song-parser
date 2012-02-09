require('mochiscript');

var fs = require('fs');
var SongParser = require('./song-parser');
var parser = new SongParser();

var files = fs.readdirSync("./samples");
console.log("There are  " + files.length + " files");
for (var i=0; i<files.length; i++) {
  var file = files[i];
  if (file.match(/\.txt$/)) {
    console.log(file.name);
    var text = fs.readFileSync("./samples/" + file, 'utf8');
    console.log(parser.parse(text));
  }
}
