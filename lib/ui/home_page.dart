import 'package:flutter/material.dart';
import 'package:note_keeper/data/model.dart';
import 'package:note_keeper/ui/note_details.dart';
import 'package:note_keeper/ui/widget/note_cell.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Notes'),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: _buildGridView(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add),
        onPressed: () => _navigateToNoteDetails(
            context: context,
            note: Note(id: null, title: '', body: '', createDate: null),
            title: 'Add Note'),
      ),
    );
  }
}

StreamBuilder<List<Note>> _buildGridView(BuildContext context) {
  final database = Provider.of<AppDatabase>(context);
  return StreamBuilder(
    stream: database.watchAllNotes(),
    builder: (context, AsyncSnapshot<List<Note>> snapshot) {
      final notes = snapshot.data ?? List();
      return _gridView(notes, context);
    },
  );
}

_gridView(List<Note> notes, BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: GridView.extent(
      // crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: notes
          .map(
            (note) => GestureDetector(
              child: GridTile(
                child: NoteCell(note: note),
              ),
              onTap: () => _navigateToNoteDetails(
                  context: context, title: 'Edit Note', note: note),
            ),
          )
          .toList(),
      maxCrossAxisExtent: 200,
    ),
  );
}

_navigateToNoteDetails({BuildContext context, String title, Note note}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return NoteDetail(
      title: title,
      note: note,
    );
  }));
}
