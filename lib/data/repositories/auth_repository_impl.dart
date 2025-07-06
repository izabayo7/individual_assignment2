import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl({required AuthDataSource authDataSource})
      : _authDataSource = authDataSource;

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    return await _authDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    return await _authDataSource.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  User? getCurrentUser() {
    return _authDataSource.getCurrentUser();
  }

  @override
  Stream<User?> get authStateChanges => _authDataSource.authStateChanges;
}
