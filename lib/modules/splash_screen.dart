import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';
import 'auth/view/login.view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<String?> isLoggedIn() async {
    const secureStorage = FlutterSecureStorage();
    final accessToken = await secureStorage.read(key: 'access_token');
    return accessToken;
  }

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    final data = await isLoggedIn();
    await Future.delayed(const Duration(milliseconds: 2000));
    if (data != null) {
      Get.off(const HomePage());
    } else {
      Get.off(const LoginView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: !kIsWeb
            ? Lottie.asset(
                'assets/pdf.json',
                frameRate: FrameRate(60),
                filterQuality: FilterQuality.high,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
              )
            : Container(),
      ),
    );
  }
}
