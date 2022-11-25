import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ReceivingPage extends StatefulWidget {
  const ReceivingPage({Key? key}) : super(key: key);

  @override
  State<ReceivingPage> createState() => _ReceivingPageState();
}

class _ReceivingPageState extends State<ReceivingPage> {
  TextEditingController kodeBarcodeController = TextEditingController(text: '');

  Future<void> scanCode() async {
    String scanRes;
    scanRes = await FlutterBarcodeScanner.scanBarcode(
        '#28386a', 'Cancel', true, ScanMode.QR);
    if (!mounted) return;
    setState(() {
      kodeBarcodeController.text = scanRes;
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
              Navigator.pushNamed(context, '/home');
            }),
        backgroundColor: backgroundColor3,
        centerTitle: true,
        title: Text(
          'Receiving',
          style: primaryTextStyle.copyWith(
            fontSize: 14.sp,
          ),
        ),
        elevation: 0,
      );
    }

    Widget kodeBarcodeInput() {
      return Container(
        margin: EdgeInsets.only(top: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kode Barcode",
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
              padding: EdgeInsets.only(left: 13.sp),
              decoration: BoxDecoration(
                  color: backgroundColor3,
                  borderRadius: BorderRadius.circular(12.sp)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              size: 20.sp,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                        controller: kodeBarcodeController,
                        style: subtitleTextStyle.copyWith(fontSize: 11.sp),
                      ),
                    ),
                    SizedBox(
                      width: 8.sp,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget namabarangInput() {
      return Container(
        margin: EdgeInsets.only(top: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama Barang",
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
                    Expanded(
                      child: TextFormField(
                        // controller: kodeBarcodeController,
                        style: subtitleTextStyle.copyWith(fontSize: 11.sp),
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

    Widget qtyInput() {
      return Container(
        margin: EdgeInsets.only(top: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "QTY",
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
                    Expanded(
                      child: TextFormField(
                        // controller: kodeBarcodeController,
                        style: subtitleTextStyle.copyWith(fontSize: 11.sp),
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

    Widget kondisibarangInput() {
      return Container(
        margin: EdgeInsets.only(top: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kondisi Barang",
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
                    Expanded(
                      child: TextFormField(
                        // controller: kodeBarcodeController,
                        style: subtitleTextStyle.copyWith(fontSize: 11.sp),
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

    Widget scanButton() {
      return Container(
        height: 6.h,
        margin: EdgeInsets.only(top: 3.h),
        child: TextButton(
          onPressed: () => scanCode(),
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
          ),
          child: Text(
            'Scan',
            style: subtitleTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: medium,
            ),
          ),
        ),
      );
    }

    Widget saveButton() {
      return Container(
        height: 6.h,
        margin: EdgeInsets.only(top: 3.h),
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
          ),
          child: Text(
            'Save',
            style: subtitleTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: medium,
            ),
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
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 19.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kodeBarcodeInput(),
                namabarangInput(),
                qtyInput(),
                kondisibarangInput(),
                Container(
                  child: Row(
                    children: [
                      Expanded(child: scanButton()),
                      SizedBox(
                        width: 10.sp,
                      ),
                      Expanded(child: saveButton()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
