import 'package:fbm_app/Inventory/Cooked_food.dart';
import 'package:fbm_app/Inventory/Inventory.dart';
import 'package:fbm_app/Inventory/Packaged_food.dart';
import 'package:fbm_app/Inventory/staple_food.dart';
import 'package:fbm_app/Pages/Forms/create_FB.dart';
import 'package:fbm_app/Pages/HomePages/SplashScreen.dart';
import 'package:fbm_app/Pages/HomePages/leaderboard_donations.dart';
import 'package:fbm_app/Pages/HomePages/leaderboard_volunteer.dart';
import 'package:fbm_app/Pages/User/Donations.dart';
// import 'package:fbm_app/Pages/EmergencyPage.dart';
import 'package:fbm_app/Pages/User/FB_profile.dart';
import 'package:fbm_app/Pages/Food_Bank_Management/Food_Bank_m.dart';
import 'package:fbm_app/Pages/HomePages/Homepage.dart';
import 'package:fbm_app/Pages/Food_Bank_Management/Outlets.dart';
import 'package:fbm_app/Pages/Restaurant/Rprofile.dart';
import 'package:fbm_app/Pages/Restaurant/fbanks_connected.dart';
import 'package:fbm_app/Pages/Restaurant/listRestaurants.dart';
import 'package:fbm_app/Pages/User/Volunteers.dart';
import 'package:fbm_app/Pages/authentication/login_screen.dart';
import 'package:fbm_app/Pages/HomePages/emergencypage.dart';
import 'package:fbm_app/Pages/HomePages/leaderboard.dart';
import 'package:fbm_app/Pages/HomePages/map.dart';
import 'package:fbm_app/Pages/Forms/volunteer_reg.dart';
import 'package:fbm_app/Pages/Food_Bank_Management/volunteers_info.dart';
import 'package:fbm_app/Pages/HomePages/wastemanagement.dart';
import 'package:fbm_app/classes/data_class.dart';
import 'package:fbm_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fbm_app/Pages/Forms/donationform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } finally {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DataClass.loadFoodbanks();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Homepage(
              userDetails: {},
            ),
        '/profile': (context) => const FbProfile(
              proDetails: {},
            ),
        '/map': (context) => const MapOutlets(),
        '/leaderboard': (context) => const leaderboard(),
        '/waste': (context) => const waste(),
        '/inventory': (context) => const Inventory(),
        '/volunteers': (context) => const Volunteers(),
        '/fb_info': (context) => const Food_Bank_Management(),
        '/v_info': (context) => volunteers_info(),
        '/mydonations': (conetxt) => const Donations(),
        '/outlets': (context) => const Outlets(),
        '/restaurants': (context) => const Restaurants(),
        '/listfb': (context) => const FB_Connected(),
        '/rprofile': (context) => const RestaurantProfile(
              RDetails: {},
            ),
        '/vform': (context) => VolunteerForm(),
        '/emergency': (context) => const Emergency(),
        '/cooked_food': (context) => const CookedFood(),
        '/packaged_food': (context) => const PackagedFood(),
        '/staple_food': (context) => const StapleFood(),
        '/create_fb': (context) => CreateFoodBank(),
        '/l_donation': (context) => LeaderboardDonations(),
        '/l_volunteers': (context) => LeaderboardVolunteer(),
      },
    );
  }
}
