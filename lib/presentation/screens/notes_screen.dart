import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/notes_cubit.dart';
import '../cubits/notes_state.dart';
import '../widgets/note_card.dart';
import '../widgets/add_note_dialog.dart';
import 'auth_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().fetchNotes();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteDialog(
        onSubmit: (text) {
          context.read<NotesCubit>().addNote(text);
          _showSnackBar('Note added successfully!');
        },
      ),
    );
  }

  void _signOut() {
    context.read<AuthCubit>().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: BlocConsumer<NotesCubit, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            _showSnackBar(state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NotesLoaded || state is NotesOperationLoading) {
            final notes = state is NotesLoaded 
                ? state.notes 
                : (state as NotesOperationLoading).notes;

            if (notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_add,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nothing here yet—tap ➕ to add a note.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<NotesCubit>().fetchNotes(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteCard(
                    note: note,
                    onEdit: (id, text) {
                      context.read<NotesCubit>().updateNote(id, text);
                      _showSnackBar('Note updated successfully!');
                    },
                    onDelete: (id) {
                      context.read<NotesCubit>().deleteNote(id);
                      _showSnackBar('Note deleted successfully!');
                    },
                  );
                },
              ),
            );
          }

          if (state is NotesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load notes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<NotesCubit>().fetchNotes(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
