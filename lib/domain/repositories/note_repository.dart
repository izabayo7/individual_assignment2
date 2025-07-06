import '../entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> fetchNotes();
  Future<void> addNote(String text);
  Future<void> updateNote(String id, String text);
  Future<void> deleteNote(String id);
}
