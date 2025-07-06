import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.text,
    required super.createdAt,
    required super.updatedAt,
    required super.userId,
  });

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      text: note.text,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      userId: note.userId,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'userId': userId,
    };
  }

  Note toEntity() {
    return Note(
      id: id,
      text: text,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: userId,
    );
  }
}
