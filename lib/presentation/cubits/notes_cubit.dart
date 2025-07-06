import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/note_repository.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NoteRepository _noteRepository;

  NotesCubit({required NoteRepository noteRepository})
      : _noteRepository = noteRepository,
        super(NotesInitial());

  Future<void> fetchNotes() async {
    try {
      emit(NotesLoading());
      final notes = await _noteRepository.fetchNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: 'Failed to fetch notes: ${e.toString()}'));
    }
  }

  Future<void> addNote(String text) async {
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        emit(NotesOperationLoading(notes: currentState.notes));
      }
      
      await _noteRepository.addNote(text);
      await fetchNotes(); // Refresh the list
    } catch (e) {
      emit(NotesError(message: 'Failed to add note: ${e.toString()}'));
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        emit(NotesOperationLoading(notes: currentState.notes));
      }
      
      await _noteRepository.updateNote(id, text);
      await fetchNotes(); // Refresh the list
    } catch (e) {
      emit(NotesError(message: 'Failed to update note: ${e.toString()}'));
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        emit(NotesOperationLoading(notes: currentState.notes));
      }
      
      await _noteRepository.deleteNote(id);
      await fetchNotes(); // Refresh the list
    } catch (e) {
      emit(NotesError(message: 'Failed to delete note: ${e.toString()}'));
    }
  }
}
