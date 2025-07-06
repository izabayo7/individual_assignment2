import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';
import 'edit_note_dialog.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Function(String id, String text) onEdit;
  final Function(String id) onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditNoteDialog(
        initialText: note.text,
        onSubmit: (text) => onEdit(note.id, text),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete(note.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    note.text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showEditDialog(context),
                      icon: const Icon(Icons.edit),
                      iconSize: 20,
                      color: Colors.blue,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      onPressed: () => _showDeleteConfirmation(context),
                      icon: const Icon(Icons.delete),
                      iconSize: 20,
                      color: Colors.red,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Updated: ${_formatDate(note.updatedAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
