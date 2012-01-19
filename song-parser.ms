export class SongParser {
  function initialize() {
    this.strategies = [
      new BaseStrategy()
    ];
  }

  function parse(text) {
    foreach (var s in this.strategies) {
      var verses = s.parse(text);
      if (verses) return verses;
    }
    return null;
  }
}

class BaseStrategy {
  function parse(text) {
    var lines = text.split(/\n/);
    var currentVerse = null;
    var verses = [];

    foreach (var l in lines) {
      var title = this.getVerseTitle(l);
      if (title) {
        currentVerse = this.newVerse(title[0], title[1]);
        verses.push(currentVerse);

      } else if (currentVerse) {
        var lineType = Music.isChordLine(l) ? 'c' : 'l';
        currentVerse.lines.push([ lineType, l ]);
      }
    }

    return verses.length ? verses : null;
  }

  function getVerseTitle(line) {
    var m = line.match(/^(verse|chorus)\s+(\d+)?/i);
    if (m) {
      return [ m[1], m[2] || 1 ];
    }
    else {
      return null;
    }
  }

  function newVerse(type, number) {
    number = number || 1; 
    return {
      type:   type,
      number: number,
      lines:  []
    };
  }
}

class Music {
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



