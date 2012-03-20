export class SongParser {
  function initialize() {
    this.strategies = [
       new NoTitleStrategy()
    ];
  }

  function parse(text) {
      var s = new NoTitleStrategy; 
      var song = s.parse(text);
      if (song) {
        foreach (var stanza in song) {
          console.log(stanza);   
        }
        return song; 
      }
    return null;     
  }

}

class BaseStrategy {
  function parse(text) {
    console.log("Base Strategy");
    var lines = text.split(/\n/);
    var currentStanza = null;
    var stanzas = [];
    var firstVerse = true;  

    foreach (var l in lines) {
      l = l.trim();
      var title = this.getStanzaTitle(l);
      if (title) {
        currentStanza = this.newStanza(title[0], title[1]);
        stanzas.push(currentStanza); 
      }
      else if (currentStanza == null && firstVerse == true) {
        currentStanza = this.newStanza("Verse", "1"); 
        stanzas.push(currentStanza);
        firstVerse = false;   
      }
      else if (currentStanza) {
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

class NoTitleStrategy {
  function parse(text) {
    console.log("Synthesis Strategy");
    var lines = text.split(/\n/); 
    var stanzas = []; 
    var currentStanza = null; 
    var verseNum = 1; 
    var stanzaDone = true;   

    foreach (var l in lines) {
      l = l.trim()
      if(Music.isBlankLine(l)) {
        if (stanzaDone) { 
          continue;  
        }
        else {
          currentStanza = null;
          stanzaDone = true;    
        }
      }
      else {
        if (!currentStanza) {
          var stanzaType = this.getStanzaTitle(l);  
          if (!stanzaType) { 
            currentStanza = this.newStanza("Verse", verseNum);
            verseNum++; 
          }   
          else {     
            currentStanza = this.newStanza(stanzaType[0], stanzaType[1]);
            stanzaDone = false;
            stanzas.push(currentStanza); 
            continue;  
          }
          stanzas.push(currentStanza); 
        } 
        var lineType = Music.isChordLine(l) ? 'c' : 'l'; 
        currentStanza.lines.push([lineType, l ]); 
        stanzaDone = false;   
      }
    }        
  
    return stanzas.length ? stanzas : null
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
    // console.log(e + "h"); 
      if (!this.isChord(e)) return false;
    }

    return true;
  }

 
  static function isChord(ele) {
    var m = ele.match(/^[A-G][b\#]?(maj|min|dim|aug|m)?(2|4|5|6|7|9|11|13)?(\/[A-Z][b\#]?)?[\t\n]?$/); 
    if (m) {
      return true;
    }
    else {
      return false; 
    }
      
  }
}



