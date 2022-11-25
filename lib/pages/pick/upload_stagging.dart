import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/provider/pick/pick_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class UploadStaggingPage extends StatefulWidget {
  final String idStagging;
  final String userId;
  final Function callbackReload;
  const UploadStaggingPage(this.idStagging, this.callbackReload, this.userId,
      {Key? key})
      : super(key: key);

  @override
  State<UploadStaggingPage> createState() => _UploadStaggingPageState();
}

class _UploadStaggingPageState extends State<UploadStaggingPage> {
  XFile? imageFile;
  String stringImage = '';
  String token = "";

  @override
  void initState() {
    validate().whenComplete(() => null);
    super.initState();
  }

  Future validate() async {
    final SharedPreferences session = await SharedPreferences.getInstance();
    setState(() {
      token = session.getString('token').toString();
    });
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 600,
    );
    setState(() {
      imageFile = pickedFile!;
      final imageBytes = File(pickedFile.path.toString()).readAsBytesSync();
      stringImage = base64.encode(imageBytes);
    });
    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue, fontSize: 10.sp),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1.sp,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text(
                      "Camera",
                      style: TextStyle(color: Colors.blue, fontSize: 10.sp),
                    ),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: backgroundColor2,
        centerTitle: true,
        title: Text(
          'Upload Stagging Area',
          style: primaryTextStyle.copyWith(
            fontSize: 14.sp,
          ),
        ),
        elevation: 0,
      );
    }

    Widget uploadGambar() {
      return Container(
        margin: EdgeInsets.only(
          left: 15.sp,
          right: 15.sp,
          top: 6.sp,
          bottom: 5.sp,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: (imageFile == null)
                  ? Container(
                      margin: EdgeInsets.only(top: 20.sp, bottom: 30.sp),
                      width: 100.sp,
                      height: 100.sp,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/no_image.png"),
                        ),
                      ),
                    )
                  : Image.file(File(imageFile!.path)),
            ),
            MaterialButton(
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: () {
                _showChoiceDialog(context);
              },
              child: Text(
                "Upload",
                style: TextStyle(
                  fontSize: 10.sp,
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget bottom() {
      return Container(
        color: backgroundColor1,
        child: Container(
          width: double.infinity,
          height: 5.h,
          margin: EdgeInsets.all(
            5.sp,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 5.h,
                      child: TextButton(
                        onPressed: () async {
                          if (JwtDecoder.isExpired(token)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(milliseconds: 500),
                                backgroundColor: secondaryColor,
                                content: Text(
                                  "Waktu Session Habis Silahkan Login Kembali",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ),
                            );
                            final SharedPreferences share =
                                await SharedPreferences.getInstance();
                            share.clear();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          } else {
                            if (stringImage == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 500),
                                  backgroundColor: secondaryColor,
                                  content: Text(
                                    "The ImageStaged field is required",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                              );
                            } else {
                              List save = await PickProvider().uploadStagging(
                                apikey: "",
                                token: token,
                                userId: widget.userId,
                                strImage: stringImage,
                                id: widget.idStagging,
                              );
                              if (save[0] == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(milliseconds: 500),
                                    backgroundColor: succesColor,
                                    content: Text(
                                      'Succes Uploaded!!!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                                widget.callbackReload();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(milliseconds: 500),
                                    backgroundColor: secondaryColor,
                                    content: Text(
                                      save[1],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(9.sp),
                          // ),
                          backgroundColor: backgroundColor4,
                        ),
                        child: Text(
                          'Simpan',
                          style: primaryTextStyle.copyWith(
                            fontSize: 10.sp,
                            fontWeight: semiBold,
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
      );
    }

    Widget productinput() {
      return Container(
        margin: EdgeInsets.only(
          top: 4.sp,
        ),
        child: Card(
          elevation: 2,
          child: Column(
            children: [
              uploadGambar(),
            ],
          ),
        ),
      );
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: backgroundColor1,
        resizeToAvoidBottomInset: false,
        appBar: header(),
        body: SafeArea(
          child: ListView(
            children: [
              productinput(),
            ],
          ),
        ),
        bottomNavigationBar: bottom(),
      );
    });
  }
}
