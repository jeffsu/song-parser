export class SongParser {
  function initialize() {
    this.strategies = [
      new BaseStrategy()
    ];
  }

  function parse(text) {
    foreach (var s in this.strategies) {
      var song = s.parse(text);
      if (song) {
        foreach (var stanza in song) {
          console.log(stanza);   
        }
      }
    }
    return null; 
  }
}

class BaseStrategy {
  function parse(text) {
    var lines = text.split(/\n/);
    var currentStanza = null;
    var stanzas = [];

    foreach (var l in lines) {
      var title = this.getStanzaTitle(l);
      if (title) {
        currentStanza = this.newStanza(title[0], title[1]);
        stanzas.push(currentStanza);

      } else if (currentStanza) {
          if (Music.isBlankLine(l)) {
            continue;  
          }
          else {
            var lineType = Music.isChordLine(l) ? 'c' : 'l';
            currentStanza.lines.push([ lineType, l ]);
          }
      }
    }

    return stanzas.length ? stanzas : null;
  }

  function getStanzaTitle(line) {
    var m = line.match(/^(intro|verse|chorus|bridge|instrumental)\s+(\d+)?/i);
    if (m) {
      return [ m[1], m[2] || 1 ];
    }
    else {
      return null;
    }
  }

  function newStanza(type, number) {
    number = number || 1; 
    return {
      type:   type,
      number: number,
      lines:  []
    };
  }
}

class Music {
  static function isBlankLine(line) {
    var m = line.match(/^\s*$/); 
    if (m) {
      return true; 
    }
    else  {
      return false; 
    }
  }

  static function isChordLine(line) {
    var elements = line.split(/\s+/);
    if (elements.length == 0) return false;

    foreach (var e in elements) {
      if (!this.isChord(e)) return false;
    }

    return true;
  }

  // TODO
  static function isChord(ele) {
    var m = ele.match(/[A|B|C|D|E|F|G]/); 
    if (m) {
      return true;
    }
    else {
      return false; 
    }
      
  }
}



