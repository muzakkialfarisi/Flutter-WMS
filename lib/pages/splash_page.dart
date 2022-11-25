import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String appV = mobileVersion;
  Timer? authTimer;
  String? versi;
  @override
  void initState() {
    // Timer(const Duration(seconds: 2), () => version());
    version();
    super.initState();
  }

  Future<void> logout() async {
    final SharedPreferences share = await SharedPreferences.getInstance();
    share.clear();
  }

  Future version() async {
    var url = '$urlApi/Auth/Versions?Device=Android';
    var response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      var link = jsonDecode(response.body)[0]['link'];
      versi = jsonDecode(response.body)[0]['version'];
      var minversi = jsonDecode(response.body)[0]['minVersion'];
      if (int.parse(appV.replaceAll(".", "")) <
          int.parse(minversi.replaceAll(".", ""))) {
        final SharedPreferences share = await SharedPreferences.getInstance();
        share.setString("linkApp", link.toString());
        share.setString("versiApp", versi.toString());
        share.setString("minVersion", minversi.toString());
        Navigator.pushNamed(context, '/update-Page');
      } else {
        final SharedPreferences session = await SharedPreferences.getInstance();
        if (session.getString('userId') == null) {
          Navigator.pushNamed(context, '/login');
        } else {
          Navigator.pushNamed(context, '/home');
        }
      }
    } else {
      version();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: backgroundColor1,
        body: Center(
          child: Container(
            width: 200.sp,
            height: 250.sp,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/logo.png"),
              ),
            ),
          ),
        ),
      );
    });
  }
}
