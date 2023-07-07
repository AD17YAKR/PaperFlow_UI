import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paperflow_ui/bindings/initial_bindings.dart';
import 'package:paperflow_ui/utils/colors.dart';
import 'package:paperflow_ui/views/login_page.dart';
import 'package:paperflow_ui/views/splash_screen.dart';

void main() {
  final runnableApp = _buildRunnableApp(
    isWeb: kIsWeb,
    webAppWidth: 600.0,
    app: const MyApp(),
  );

  runApp(runnableApp);
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Center(
    child: ClipRect(
      child: SizedBox(
        width: webAppWidth,
        child: app,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a GetXController for managing the theme
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paperflow UI',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        appBarTheme: const AppBarTheme(
          color: AppColors.primary,
          elevation: 10,
        ),
        textTheme:
            GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).copyWith(
          // Customize the text styles here
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          bodyLarge: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.textPrimary,
          ),
          // Add more customizations for other text styles as needed
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: AppColors.primaryDark,
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.primaryDark,
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme:
            GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).copyWith(
          // Customize the text styles here
          displayLarge: GoogleFonts.montserrat(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          bodyLarge: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: AppColors.textPrimary,
          ),
          // Add more customizations for other text styles as needed
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      initialBinding: InitialBinding(),
      getPages: [
        GetPage(
          name: '/',
          page: () => kIsWeb ? LoginPage() : SplashScreen(),
        )
      ],
    );
  }
}
