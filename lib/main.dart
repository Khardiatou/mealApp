import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:mealmagic/screens/home/home_screen.dart';
import 'package:mealmagic/screens/auth/login_screen.dart';
import 'package:mealmagic/screens/auth/register_screen.dart';
import 'package:mealmagic/screens/home/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mealmagic/screens/auth/reset_password_screen.dart';
import 'package:mealmagic/screens/restaurant/restaurant_screen.dart';
import 'package:mealmagic/screens/auth/sign_up_delivery_screen.dart';
import 'package:mealmagic/screens/restaurant/add_restaurant_screen.dart';
import 'package:mealmagic/screens/help_screen.dart';
import 'package:mealmagic/screens/profile/user_profile_screen.dart';
import 'package:mealmagic/screens/terms_conditions_screen.dart';
import 'package:mealmagic/screens/cookies_screen.dart';
import 'package:mealmagic/screens/privacy_screen.dart';
import 'package:mealmagic/screens/nos_services_screen.dart';
import 'package:mealmagic/screens/auth/create_business_account_screen.dart';
import 'package:mealmagic/screens/restaurant/restaurant_nene.dart';
import 'package:mealmagic/screens/restaurant/restaurant_reunion.dart';
import 'package:mealmagic/screens/restaurant/delice_restaurant.dart';
import 'package:mealmagic/screens/checkout/basket_screen.dart';
import 'package:mealmagic/screens/restaurant/rsn_menu_page.dart';
import 'package:mealmagic/screens/checkout/payment_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MealMagic',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
      
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/restaurantNene': (context) => RestaurantNene(),
        '/restaurantReunion': (context) => RestaurantReunionPage(),
        '/restaurantKoudougou': (context) => RestaurantKoudougouPage(),
        '/reset-password': (context) => ResetPasswordScreen(),
        '/signUpDelivery': (context) => SignUpDeliveryScreen(),
        '/addRestaurant': (context) => AddRestaurantScreen(),
        '/help': (context) => HelpScreen(),
        '/profile': (context) => UserProfileSection(),
        '/terms-conditions': (context) => TermsConditionsScreen(),
        '/cookies': (context) => CookiesScreen(),
        '/privacy': (context) => PrivacyScreen(),
        '/nos-services': (context) => NosServicesScreen(),
        '/create-business-account': (context) => CreateBusinessAccountScreen(),
        '/basket': (context) => BasketScreen(),
        '/menu': (context) =>MenuScreen(),
       '/payment': (context) {
  final totalAmount = ModalRoute.of(context)!.settings.arguments as double;
  return PaymentScreen(totalAmount: totalAmount);
},

      },
    );
  }
}
