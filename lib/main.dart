import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'pages/welcome_pg.dart';


List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }

  runApp(MyApp());}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.define(),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      routes: {
        RaiseConcernDirect.routeName: (context) => RaiseConcernDirect(),
        TakePictureScreen.routeName: (context) => TakePictureScreen(camera: cameras[0]),
        ProfilePage.routeName: (context) => ProfilePage(title: 'John Doe'), //Change later
        SusMapping.routeName: (context) => SusMapping(title: 'Title'),     //Change Later
        DonateDustbin.routeName: (context) => DonateDustbin(),
        ProductsPage.routeName: (context) => ProductsPage(),
        ComingSoon.routeName: (context) => ComingSoon(),
        PreviewReport.routeName: (context) => PreviewReport()
      },
    );
  }
}