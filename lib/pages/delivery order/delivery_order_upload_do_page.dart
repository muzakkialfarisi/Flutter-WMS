import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/delivery_order/delivery_order_model.dart';
import 'package:wms_deal_ncs/provider/delivery_order/delivery_order_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class DeliveryOrderUploadDoPage extends StatefulWidget {
  final DeliveryOrderModel detailDO;
  final Function callbackReload;
  final String token;
  const DeliveryOrderUploadDoPage(
      this.detailDO, this.callbackReload, this.token,
      {Key? key})
      : super(key: key);

  @override
  State<DeliveryOrderUploadDoPage> createState() =>
      _DeliveryOrderUploadDoPageState();
}

class _DeliveryOrderUploadDoPageState extends State<DeliveryOrderUploadDoPage> {
  XFile? imageFile;
  String stringImage = '';

  void _openCamera(BuildContext context) async {
    // final pickedFile = await ImagePicker().pickImage(
    //   source: ImageSource.camera,
    // );
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
    DeliveryOrderProvider deliveryProvider =
        Provider.of<DeliveryOrderProvider>(context);
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
          'Upload DO Image',
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
                "Upload Do",
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
                          if (JwtDecoder.isExpired(widget.token)) {
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
                            if (await deliveryProvider.uploadDo(
                              apikey: "",
                              token: widget.token,
                              noDo: widget.detailDO.noDo.toString(),
                              strImage: stringImage,
                            )) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 500),
                                  backgroundColor: succesColor,
                                  content: Text(
                                    'Berhasil MengUpload Manifes DO !!!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                              );
                              widget.callbackReload();
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 500),
                                  backgroundColor: secondaryColor,
                                  content: Text(
                                    'Gagal !!! Tidak Dapat Menggapai Server',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                              );
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
