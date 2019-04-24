import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

/*  Notice the declaration State<RandomWords>.
    This indicates that we’re using the generic State class specialized for use with RandomWords.
    Most of the app’s logic and state resides here—it maintains the state for the RandomWords widget.
    This class saves the generated word pairs, which grows infinitely as the user scrolls, and favorite word pairs,
    as the user adds or removes them from the list by toggling the heart icon.*/

class RandomWordsState extends State<RandomWords>{

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = Set<WordPair>();


  @override
  Widget build(BuildContext context) {
    //Stateless widgets are immutable, meaning that their properties can’t change—all values are final.
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );

  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(   // Add the lines from here...
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
       /* The itemBuilder callback is called once per suggested word pairing,
        and places each suggestion into a ListTile row. For even rows, the function adds a ListTile row for the word pairing. For odd rows,
        the function adds a Divider widget to visually separate the entries.
        Note that the divider may be difficult to see on smaller devices.*/
      itemBuilder: (context, i) {
        //Add a one-pixel-high divider widget before each row in the ListView.
        if(i.isOdd) return Divider();

       /* The expression i ~/ 2 divides i by 2 and returns an integer result.
          For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          This calculates the actual number of word pairings in the ListView, minus the divider widgets.*/
        final index = i ~/ 2;
        if(index >= _suggestions.length){
          //If you’ve reached the end of the available word pairings, then generate 10 more and add them to the suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(   // Add 20 lines from here...
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
