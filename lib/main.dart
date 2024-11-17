import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/providers/AuthProvider.dart';
import 'package:proyecto/providers/TestProvider.dart';
import 'package:proyecto/providers/DocumentProvider.dart';
import 'package:proyecto/routes/landing.dart';
import 'package:proyecto/routes/load.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto/firebase_options.dart';
import 'package:proyecto/routes/login.dart';
import 'package:proyecto/routes/register.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TestProvider>(
          create: (_) => TestProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<DocumentProvider>(
          create: (_) => DocumentProvider()
        )
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fi p',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
            useMaterial3: true
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const LandingPage(),
            '/home': (context) => const Load(),
            '/login': (context) => const Login(),
            '/register': (context) => const Register(),
          },
        );
      }),
    )
  );
}