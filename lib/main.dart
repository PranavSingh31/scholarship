import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:portal/adminLogin.dart';
import 'package:portal/file.dart';
import 'package:portal/profile.dart';

import 'dashboard.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        title: 'Scholarship Upload',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/login':  (BuildContext ctx) => const Login(),
          '/dashboard': (BuildContext ctx) => const Dashboard(),
          '/profile': (BuildContext ctx) => const Profile(),
          '/documents':(BuildContext ctx) => const FileUpload(),
          '/adminLogin':(BuildContext ctx) => const AdminLogin(),
        },
        home: const Login(),
      ),
      // to use a custom loader.....
      /*
      useDefaultLoading: ,
      overlayWidget: Center(
          child: SpinKitCubeGrid(
            color: Colors.red,
            size: 50.0,
          ),
        ),
      overlayOpacity: 0.8,
      */
    );
  }
}