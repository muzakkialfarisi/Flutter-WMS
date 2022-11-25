import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/provider/auth/login_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Future<bool> _outApp() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Keluar ?',
                style: TextStyle(fontSize: 12.sp),
              ),
              content: Text(
                'Apakah Anda Yakin Ingin Keluar Dari Aplikasi Ini',
                style: TextStyle(fontSize: 13.sp),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Tidak',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                TextButton(
                  onPressed: () => exit(0),
                  child: Text(
                    'Ya',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          )) ??
          false;
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.only(
          top: 15.sp,
        ),
        child: Center(
          child: Text(
            "Warehouse Management System",
            style: primaryTextStyle.copyWith(
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }

    Widget usernameInput() {
      return Container(
        margin: EdgeInsets.only(top: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username",
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Container(
              height: 7.h,
              padding: EdgeInsets.symmetric(horizontal: 13.sp),
              decoration: BoxDecoration(
                  color: backgroundColor3,
                  borderRadius: BorderRadius.circular(12.sp)),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 17.sp,
                    ),
                    SizedBox(
                      width: 13.sp,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: usernameController,
                        style: subtitleTextStyle.copyWith(fontSize: 11.sp),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Username',
                          hintStyle:
                              subtitleTextStyle.copyWith(fontSize: 11.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: EdgeInsets.only(top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Password",
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Container(
              height: 7.h,
              padding: EdgeInsets.symmetric(horizontal: 13.sp),
              decoration: BoxDecoration(
                  color: backgroundColor3,
                  borderRadius: BorderRadius.circular(12.sp)),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      size: 17.sp,
                    ),
                    SizedBox(
                      width: 13.sp,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: passwordController,
                        style: subtitleTextStyle.copyWith(fontSize: 11.sp),
                        obscureText: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your password',
                          hintStyle:
                              subtitleTextStyle.copyWith(fontSize: 11.sp),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget loginButton() {
      return Container(
        height: 6.h,
        width: double.infinity,
        margin: EdgeInsets.only(top: 3.h),
        child: TextButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            if (usernameController.text == '' ||
                passwordController.text == '') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 500),
                  backgroundColor: secondaryColor,
                  content: Text(
                    'Username or Password has not been filled in yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              );
            } else {
              List log = await LoginProvider().login(
                apikey: "",
                username: usernameController.text,
                password: passwordController.text,
              );
              if (log.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 500),
                    backgroundColor: secondaryColor,
                    content: Text(
                      'Error Tidak Dapat Menggapai Server',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                );
              } else if (log[0] == 400) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 500),
                    backgroundColor: secondaryColor,
                    content: Text(
                      log[1],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                );
              } else {
                Navigator.pushNamed(context, '/home');
              }
            }
            setState(() {
              isLoading = false;
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
          ),
          child: Text(
            'Login',
            style: subtitleTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: medium,
            ),
          ),
        ),
      );
    }

    Widget loadingButton() {
      return Container(
        height: 35.sp,
        width: double.infinity,
        margin: EdgeInsets.only(top: 17.sp),
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16.sp,
                height: 16.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 0.7.w,
                  valueColor: AlwaysStoppedAnimation(primaryTextColor),
                ),
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                'Loading',
                style: primaryTextStyle.copyWith(
                  fontSize: 13.sp,
                  fontWeight: medium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
        onWillPop: () {
          return _outApp();
        },
        child: Scaffold(
          backgroundColor: backgroundColor1,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 19.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  Center(
                    child: Container(
                      width: 80.sp,
                      height: 100.sp,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/logo.png"),
                        ),
                      ),
                    ),
                  ),
                  usernameInput(),
                  passwordInput(),
                  isLoading == true ? loadingButton() : loginButton(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
