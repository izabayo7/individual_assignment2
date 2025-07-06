import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/note_model.dart';

class NoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final _uuid = const Uuid();

  NoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<NoteModel>> fetchNotes() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Simplified query without ordering to avoid index requirement
    final snapshot = await _firestore
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .get();

    final notes = snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList();
    
    // Sort locally to avoid Firestore index requirement
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    
    return notes;
  }

  Future<void> addNote(String text) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final now = DateTime.now();
    final noteModel = NoteModel(
      id: _uuid.v4(),
      text: text,
      createdAt: now,
      updatedAt: now,
      userId: user.uid,
    );

    await _firestore
        .collection('notes')
        .doc(noteModel.id)
        .set(noteModel.toFirestore());
  }

  Future<void> updateNote(String id, String text) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore.collection('notes').doc(id).update({
      'text': text,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> deleteNote(String id) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore.collection('notes').doc(id).delete();
  }
}
