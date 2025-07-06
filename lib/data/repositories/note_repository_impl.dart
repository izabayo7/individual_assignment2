import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_data_source.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteDataSource _noteDataSource;

  NoteRepositoryImpl({required NoteDataSource noteDataSource})
      : _noteDataSource = noteDataSource;

  @override
  Future<List<Note>> fetchNotes() async {
    final noteModels = await _noteDataSource.fetchNotes();
    return noteModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addNote(String text) async {
    await _noteDataSource.addNote(text);
  }

  @override
  Future<void> updateNote(String id, String text) async {
    await _noteDataSource.updateNote(id, text);
  }

  @override
  Future<void> deleteNote(String id) async {
    await _noteDataSource.deleteNote(id);
  }
}
