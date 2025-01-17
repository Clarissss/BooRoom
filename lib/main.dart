import 'package:bookingroom/ScreenBA/homeAdmin.dart';
import 'package:bookingroom/ScreenBKU/homeBku.dart';
import 'package:bookingroom/ScreenUser/home.dart';
import 'package:bookingroom/ScreenLogin/login_page.dart';
import 'package:bookingroom/ScreenDosen/manage_prospect_dosen.dart';
import 'package:bookingroom/ScreenFakultas/manage_prospect_Fakultas.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Booking App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login_screen',
      routes: {
        'login_screen': (context) => LoginScreen(),
        'admin_screen': (context) => AdminDashboard(),
        'bku_screen': (context) => BkuDashboard(),
        'prodi_screen': (context) => ManageProspectDosenPage(),
        'fakultas_screen': (context) => ManageProspectFakultasPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'home_screen') {
          final String userData = settings.arguments as String; // Get userData from arguments
          return MaterialPageRoute(
            builder: (context) => HomeScreen(userData: userData), // Pass userData
          );
        }
        return null; // Handle other routes normally
      },
    );
  }
}
