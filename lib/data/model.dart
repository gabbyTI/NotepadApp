import 'package:moor_flutter/moor_flutter.dart';

part 'model.g.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1)();
  TextColumn get body => text().nullable()();
  DateTimeColumn get createDate => dateTime().nullable()();
}

@UseMoor(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  Stream<List<Note>> watchAllNotes() => select(notes).watch();
  Future insertNote(Note note) => into(notes).insert(note);
  Future updateNote(Note note) => update(notes).replace(note);
  Future updateNoteById(NotesCompanion note, Value<int> id) {
    return (update(notes)
          ..where((t) => t.id.equals((int.parse(id.toString())))))
        .replace(note);
  }

  Future deleteNote(Note note) => delete(notes).delete(note);

}
