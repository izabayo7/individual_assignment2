import 'package:flutter/material.dart';

class EditNoteDialog extends StatefulWidget {
  final String initialText;
  final Function(String text) onSubmit;

  const EditNoteDialog({
    super.key,
    required this.initialText,
    required this.onSubmit,
  });

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late final TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

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
      title: const Text('Edit Note'),
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
          child: const Text('Update'),
        ),
      ],
    );
  }
}
