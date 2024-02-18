import 'package:collaboratask/database/AppDatabase.dart';
import 'package:collaboratask/screens/controllers/SplashController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

AppDatabase? database;
Future<AppDatabase> manageDatabase() async {
  return database = await $FloorAppDatabase.databaseBuilder(AppDatabase.DATABASE_PATH).build();
}

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  database?.cleanDatabase(true);
  await manageDatabase();
  database?.setDaoForDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collabora Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        useMaterial3: true,
      ),
      home: const SplashViewController(),
    );
  }
}


