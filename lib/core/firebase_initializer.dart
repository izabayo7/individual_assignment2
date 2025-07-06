import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseInitializer {
  static bool _initialized = false;
  
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
    } on FirebaseException catch (e) {
      if (e.code == 'duplicate-app') {
        _initialized = true;
        return;
      }
      rethrow;
    }
  }
}
