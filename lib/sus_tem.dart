import 'package:flutter/material.dart';
import 'package:oxon_app/pages/sustainable_mapping_pg.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'pages/welcome_pg.dart';

void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.define(),
      debugShowCheckedModeBanner: false,
      home: SusMapping(
        title: "Sustainable Mapping"
      ),
    );
  }
}