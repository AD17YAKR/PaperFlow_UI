import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bindings/initial_bindings.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/colors.dart';

void main() {
  // runApp(runnableApp);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      initialRoute: Routes.LOGIN_SCREEN,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
    );
  }
}
