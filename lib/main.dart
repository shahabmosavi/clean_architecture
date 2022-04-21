import 'package:get/get.dart';

import 'Features/NumberTrivia/Presentation/Pages/number_trivia_page.dart';
import 'injection_container.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.green.shade600, primary: Colors.green.shade800),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
