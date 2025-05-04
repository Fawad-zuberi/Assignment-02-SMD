import 'package:assignment2/BloC/Auth_Bloc.dart';
import 'package:assignment2/BloC/Comment_bloc/Comment_bloc.dart';
import 'package:assignment2/BloC/Event_Bloc/Event_bloc.dart';
import 'package:assignment2/BloC/Profile_Bloc/Profile_Bloc.dart';
import 'package:assignment2/firebase_options.dart';
import 'package:assignment2/screens/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuth.instance),
        ),
        BlocProvider<EventBloc>(
          create: (context) => EventBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<CommentBloc>(
          create: (context) => CommentBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventoPK',
      home: const HomePage(),
    );
  }
}
