import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/splash_login_screen.dart';

void main() {
  // Locale 데이터 초기화
  initializeDateFormatting('ko', null).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in, unit in dp)
    return ScreenUtilInit(
      designSize: const Size(1080, 2440),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('ko', ''), // Korean
          ],
          title: 'First Method',
          // Defining the theme with different fonts for different text styles
          theme: ThemeData(
            primarySwatch: Colors.blue,

            // Add more text styles as needed
          ),

          home: child,
        );
      },
      child: const SplashLoginScreen(),
    );
  }
}
