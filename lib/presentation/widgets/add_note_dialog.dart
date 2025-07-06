import 'package:flutter/material.dart';

class AddNoteDialog extends StatefulWidget {
  final Function(String text) onSubmit;

  const AddNoteDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_textController.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Note'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          autofocus: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
