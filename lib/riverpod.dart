import 'package:hive_flutter/adapters.dart';
import 'package:hive_riverpod/note_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final HiveDbProvider = Provider<HiveDB>((ref) {
  return HiveDB();
});

final BoxNoteProvider = Provider((ref) {
  return ref.watch(HiveDbProvider).noteBox;
});

class HiveDB {
  late Box<Note> noteBox;
  void init() {
    noteBox = Hive.box('mynote');
    print("content = ${noteBox.values}");
  }

  Future putNote(Note note, int index) {
    return noteBox.putAt(index, note);
  }

  Future addNote(Note note) {
    return noteBox.add(note);
  }

  Future DelateNote(int index) {
    return noteBox.deleteAt(index);
  }

  Future ClearNote() {
    return noteBox.clear();
  }
}
