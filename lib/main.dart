import 'package:fitness_tracker/configs/get_it_configurator.dart';
import 'package:fitness_tracker/screens/add_day_screen.dart';
import 'package:fitness_tracker/screens/day_screen.dart';
import 'package:fitness_tracker/screens/exercicies_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/days',
      routes: {
        '/exercicies': (ctx) => ExerciciesScreen(),
        '/days': (ctx) => const DayScreen(),
        '/add-days': (ctx) => const AddDayPage(),
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 138, 230, 219),
          foregroundColor: Colors.black87,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 138, 230, 219),
        ),
      ),
    );
  }
}
