import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/datasources/auth_data_source.dart';
import '../data/datasources/note_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/note_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/note_repository.dart';
import '../presentation/cubits/auth_cubit.dart';
import '../presentation/cubits/notes_cubit.dart';

class ServiceLocator {
  static late AuthRepository _authRepository;
  static late NoteRepository _noteRepository;
  
  static void setup() {
    // Data sources
    final authDataSource = AuthDataSource();
    final noteDataSource = NoteDataSource();
    
    // Repositories
    _authRepository = AuthRepositoryImpl(authDataSource: authDataSource);
    _noteRepository = NoteRepositoryImpl(noteDataSource: noteDataSource);
  }
  
  static List<BlocProvider> get blocProviders => [
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(authRepository: _authRepository),
    ),
    BlocProvider<NotesCubit>(
      create: (context) => NotesCubit(noteRepository: _noteRepository),
    ),
  ];
}
