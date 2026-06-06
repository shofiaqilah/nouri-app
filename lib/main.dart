import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'services/hive_service.dart';
import 'services/session_service.dart';
import 'services/notification_service.dart';

import 'bindings/auth_binding.dart';
import 'bindings/home_binding.dart';
import 'bindings/food_binding.dart';
import 'bindings/profile_binding.dart';

import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/onboarding_page.dart';
import 'views/home_page.dart';
import 'views/food_search_page.dart';
import 'views/food_log_page.dart';
import 'views/history_page.dart';
import 'views/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await HiveService.init();
  await NotificationService.init();

  final session = SessionService();
  final isLoggedIn = await session.isLoggedIn();

  // Kalau sudah login, cek apakah onboarding sudah selesai
  String initialRoute = '/login';
  if (isLoggedIn) {
    final email = await session.getUserEmail();
    if (email != null) {
      final user = HiveService().getUser(email);
      // Onboarding dianggap selesai jika name tidak kosong
      if (user != null && user.name.isNotEmpty) {
        initialRoute = '/home';
      } else {
        initialRoute = '/onboarding';
      }
    }
  }

  runApp(NouriApp(initialRoute: initialRoute));
}

class NouriApp extends StatelessWidget {
  final String initialRoute;

  const NouriApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nouri',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      defaultTransition: Transition.fadeIn,
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/onboarding',
          page: () => const OnboardingPage(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/search',
          page: () => FoodSearchPage(),
          binding: SearchBinding(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/today-log',
          page: () => const FoodLogPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/history',
          page: () => const HistoryPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfilePage(),
          binding: ProfileBinding(),
          transition: Transition.rightToLeft,
        ),
      ],
    );
  }
}
