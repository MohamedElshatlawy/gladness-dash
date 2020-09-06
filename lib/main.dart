import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_dashboard/Providers/bottomNavProvider.dart';
import 'package:qutub_dashboard/Providers/categoryProvider.dart';
import 'package:qutub_dashboard/Providers/userProvider.dart';
import 'package:qutub_dashboard/ui/Login/login.dart';
import 'package:qutub_dashboard/ui/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BottomNavProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'ar',
        ),
        home: Splash(),
      ),
    ));
} 
