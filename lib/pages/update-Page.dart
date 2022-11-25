import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppPage extends StatefulWidget {
  const UpdateAppPage({Key? key}) : super(key: key);

  @override
  State<UpdateAppPage> createState() => _UpdateAppPageState();
}

class _UpdateAppPageState extends State<UpdateAppPage> {
  String? newVersion;
  String? minVersion;
  String oldVersion = mobileVersion;
  String? linkApp;
  @override
  void initState() {
    validate().whenComplete(() => null);
    super.initState();
  }

  Future validate() async {
    final SharedPreferences session = await SharedPreferences.getInstance();
    setState(() {
      newVersion = session.getString('versiApp')!;
      minVersion = session.getString('minVersion')!;
      linkApp = session.getString('linkApp')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _outApp() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Keluar ?',
                style: TextStyle(fontSize: 30.sp),
              ),
              content: Text(
                'Apakah Anda Yakin Ingin Keluar Dari Aplikasi Ini',
                style: TextStyle(fontSize: 25.sp),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Tidak',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
                TextButton(
                  onPressed: () => exit(0),
                  child: Text(
                    'Ya',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ],
            ),
          )) ??
          false;
    }

    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.all(19.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/image_profile.png',
                        width: 17.w,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hallo, User',
                            style: primaryTextStyle.copyWith(
                              fontSize: 13.sp,
                              fontWeight: semiBold,
                            ),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Text(
                            'Your Version : ${oldVersion.toString()}',
                            style: primaryTextStyle.copyWith(
                              fontSize: 10.sp,
                              fontWeight: semiBold,
                            ),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Text(
                            'New Version : ${newVersion.toString()}',
                            style: primaryTextStyle.copyWith(
                              fontSize: 10.sp,
                              fontWeight: semiBold,
                            ),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Text(
                            'Min Version : ${minVersion.toString()}',
                            style: primaryTextStyle.copyWith(
                              fontSize: 10.sp,
                              fontWeight: semiBold,
                            ),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 22.w,
                    ),
                    Expanded(
                      child: Container(
                        height: 5.5.h,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 0.5.h),
                        child: TextButton(
                          onPressed: () async {
                            var urllaunchable = await canLaunchUrl(
                                Uri.parse(linkApp.toString()));
                            if (urllaunchable) {
                              await launchUrl(Uri.parse(linkApp.toString()));
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.sp),
                            ),
                          ),
                          child: Text(
                            'Update Apps',
                            style: primaryTextStyle.copyWith(
                              fontSize: 9.sp,
                              fontWeight: medium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
          body: header(),
        ),
      );
    });
  }
}
