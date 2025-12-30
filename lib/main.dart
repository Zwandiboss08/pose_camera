import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_styling_camera_flutter/presentation/binding/pose_binding.dart';
import 'package:pose_styling_camera_flutter/presentation/screen/pose_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pose Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),

      // Connect the Binding here
      initialBinding: PoseBinding(),

      // Point to the View (Screen)
      home: const PoseView(),
    );
  }
}
