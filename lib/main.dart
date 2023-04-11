import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/splashScreen.dart';
import 'screens/signin_screen.dart';
import 'dart:io';


void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  // Show splash screen while app is initializing
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
      home: SplashScreen()));

  // Wait for app to initialize before showing the main screen
  await Future.delayed(Duration(seconds: 5));

  // Show main screen
  runApp(const MyApp());
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SigninScreen(),
    );
  }
}
