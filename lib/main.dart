import 'package:flutter/material.dart';
import 'pages/welcome_pg.dart';

void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 27.0),
          headline2: TextStyle(fontSize: 25.0),
          headline3: TextStyle(fontSize: 22.0),
          headline6: TextStyle(fontSize: 15.0),
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(
      ),
    );
  }
}