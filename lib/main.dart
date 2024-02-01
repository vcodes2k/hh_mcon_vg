import 'package:flutter/material.dart';
import 'package:hh_mcon_vg/presentation/camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'hh_mcon_vg',
      home: CameraScreen(),
    );
  }
}
