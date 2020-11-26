import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant_disease_detection/screens/home_screen.dart';
import 'package:plant_disease_detection/screens/welcome_screen.dart';

void main() {
  runApp(PlantDiseaseApp());
}

class PlantDiseaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Disease Detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
      home: AnimatedSplashScreen(
        duration: 500,
        splashIconSize: 200,
        splash: Hero(
          tag: 'plant-logo',
          child: Image.asset('assets/img/plant-logo.png'),
        ),
        nextScreen: WelcomeScreen(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        // backgroundColor: Colors.blue,
      ),
    );
  }
}
