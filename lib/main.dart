import 'package:flutter/material.dart';
import 'pages/welcome_pg.dart';
import './pages/raise_concern.dart';
// import './pages/raise_concern_camera.dart';
import './pages/take_picture.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }

  runApp(MyApp());
}

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
        TakePictureScreen.routeName: (context) => TakePictureScreen(camera: cameras[0])
      },
    );
  }
}