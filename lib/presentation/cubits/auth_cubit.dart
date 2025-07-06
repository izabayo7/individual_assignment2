import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<User?> _authSubscription;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authRepository.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authRepository.createUserWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      emit(AuthError(message: 'Failed to sign out'));
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'The account already exists for that email';
      case 'weak-password':
        return 'The password provided is too weak';
      case 'invalid-email':
        return 'The email address is not valid';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return e.message ?? 'Authentication failed';
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
