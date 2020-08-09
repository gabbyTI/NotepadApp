import 'package:flutter/material.dart';
import 'package:note_keeper/data/model.dart';
import 'package:provider/provider.dart';

class NoteCell extends StatefulWidget {
  final Note note;

  const NoteCell({Key key, this.note}) : super(key: key);

  @override
  _NoteCellState createState() => _NoteCellState();
}

class _NoteCellState extends State<NoteCell> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //POP-UP MENU
              Container(
                height: 25,
                alignment: Alignment.centerRight,
                child: FittedBox(
                  child: PopupMenuButton<Note>(
                    offset: Offset(15.0, 40.0),
                    onSelected: choiceAction,
                    itemBuilder: (context) => <PopupMenuEntry<Note>>[
                      PopupMenuItem<Note>(
                        child: PopupMenuItem(
                          value: widget.note,
                          child: Text('delete'),
                        )
                      ),
                    ] 
                      
                  ),
                ),
              ),
              //Short Description Area
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.note.body.isEmpty
                          ? Text(
                              'EMPTY',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.grey[400]),
                            )
                          : Text(
                              widget.note.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),
                ),
              ),
              //Title Area
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  widget.note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
              ),
              // Date Time Area
              Text(
                'Created: ' + widget.note.createDate.toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void choiceAction(note) {
    // debugPrint(choice.toString());
    final database = Provider.of<AppDatabase>(context);
    database.deleteNote(widget.note);
    _showAlertDialog('Status', 'Deleted Note sucessfully');
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog( 
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
