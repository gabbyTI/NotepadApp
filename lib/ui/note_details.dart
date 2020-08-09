import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/data/model.dart';
import 'package:provider/provider.dart';

class NoteDetail extends StatefulWidget {
  final String title;
  final Note note;

  const NoteDetail({Key key, this.title, this.note}) : super(key: key);

  @override
  _NoteDetailState createState() => _NoteDetailState(note);
}

class _NoteDetailState extends State<NoteDetail> {
  Note note;
  final key = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var title;
  var description;
  var createDate;

  _NoteDetailState(this.note);

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.body;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: Form(
          key: key,
          child: ListView(
            children: <Widget>[
              // First Text field
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value.trim() == '') {
                      value = "This field can not be empty";
                    } else {
                      value = null;
                    }
                    return value;
                  },
                  autofocus: true,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              // Second Text Field
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  maxLines: 5,
                  controller: descriptionController,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              // Save Button
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (this.key.currentState.validate()) {
                            _save();
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () => _delete(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  updateTitle() {
    note.title = titleController.text.trim();
  }

  updateDescription() {
    note.body = descriptionController.text.trim();
  }

  _delete() {
    Navigator.pop(context);
    if (note.id == null) {
      _showAlertDialog('Status', 'Nothing to delete');
      return;
    }
    final database = Provider.of<AppDatabase>(context);
    database.deleteNote(note);
    _showAlertDialog('Status', 'Deleted Note sucessfully');
  }

  _save() {
    Navigator.pop(context);
    final database = Provider.of<AppDatabase>(context);
    if (note.id != null) {
      database.updateNote(note);
      _showAlertDialog('Status', 'Note updated sucessfully');
    } else {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      note.createDate = DateTime.parse(formattedDate);
      database.insertNote(note);
      _showAlertDialog('Status', 'Note created sucessfully');
    }
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
