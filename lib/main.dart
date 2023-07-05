import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paperflow_ui/bindings/initial_bindings.dart';
import 'package:paperflow_ui/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paperflow UI',
      initialRoute: '/',
      initialBinding: InitialBinding(),
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
      ],
    );
  }
}
