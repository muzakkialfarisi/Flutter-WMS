import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wms_deal_ncs/pages/home/home_page.dart';
import 'package:wms_deal_ncs/pages/profile/my_profile.dart';
import '../../theme.dart';
import 'package:sizer/sizer.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

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

    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.sp),
        ),
        child: BottomNavigationBar(
          selectedItemColor: backgroundColor1,
          unselectedItemColor: Colors.indigo[200],
          backgroundColor: backgroundColor4,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(top: 10.sp),
                child: Icon(
                  Icons.home,
                  size: 20.sp,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 10.sp),
                  child: Icon(
                    Icons.dashboard,
                    size: 20.sp,
                  ),
                ),
                label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 10.sp),
                  child: Icon(
                    Icons.person,
                    size: 20.sp,
                  ),
                ),
                label: 'Profile'),
          ],
          selectedLabelStyle: TextStyle(
            fontSize: 12.sp,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12.sp,
          ),
        ),
      );
    }

    Widget body() {
      switch (currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return Text("home");
        case 2:
          return const MyProfilePage();
        default:
          return Text("home");
      }
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
        onWillPop: () {
          return _outApp();
        },
        child: Scaffold(
          backgroundColor: backgroundColor1,
          bottomNavigationBar: customBottomNav(),
          body: body(),
        ),
      );
    });
  }
}
