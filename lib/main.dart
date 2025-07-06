import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/firebase_initializer.dart';
import 'core/service_locator.dart';
import 'presentation/cubits/auth_cubit.dart';
import 'presentation/cubits/auth_state.dart';
import 'presentation/screens/auth_screen.dart';
import 'presentation/screens/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with custom wrapper
  await FirebaseInitializer.initialize();
  
  ServiceLocator.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: ServiceLocator.blocProviders,
      child: MaterialApp(
        title: 'Notes App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const NotesScreen();
            } else {
              return const AuthScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
