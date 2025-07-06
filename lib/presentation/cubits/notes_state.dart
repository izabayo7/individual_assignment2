import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;

  const NotesLoaded({required this.notes});

  @override
  List<Object?> get props => [notes];
}

class NotesError extends NotesState {
  final String message;

  const NotesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class NotesOperationLoading extends NotesState {
  final List<Note> notes;

  const NotesOperationLoading({required this.notes});

  @override
  List<Object?> get props => [notes];
}
