import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/delivery_order/delivery_order_model.dart';
import 'package:wms_deal_ncs/model/delivery_order/product_detail_model.dart';
import 'package:wms_deal_ncs/provider/delivery_order/product_detail_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class ProductOrderDetail extends StatefulWidget {
  final DeliveryOrderModel detailDO;
  final ProductDetailModel productdtl;
  final String dateDelivered;
  final Function callbackReload;
  const ProductOrderDetail(
      this.detailDO, this.productdtl, this.dateDelivered, this.callbackReload,
      {Key? key})
      : super(key: key);

  @override
  State<ProductOrderDetail> createState() => _ProductOrderDetailState();
}

class _ProductOrderDetailState extends State<ProductOrderDetail> {
  TextEditingController quantityController = TextEditingController(text: '');
  TextEditingController noteController = TextEditingController(text: '');

  XFile? imageFile;
  String stringImage = '';
  bool isLoading = false;
  String? username;
  String token = '';

  @override
  void initState() {
    validate().whenComplete(() => null);
    super.initState();
  }

  Future validate() async {
    final SharedPreferences session = await SharedPreferences.getInstance();

    setState(() {
      username = session.getString('userName')!;
      token = session.getString('token')!;
    });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
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

  // Future<void> retrieveLostData() async {
  //   final LostDataResponse response = await ImagePicker().retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     setState(() {
  //       if (response.files == null) {
  //         imageFile = response.file;
  //         stringImage = base64.encode(File(imageFile!.path).readAsBytesSync());
  //       } else {
  //         // _imageFileList = response.files;
  //       }
  //     });
  //   }
  // }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 600,
    );

    setState(() {
      imageFile = pickedFile!;
      // final imageBytes = File(imageFile!.path).readAsBytesSync();
      stringImage = base64.encode(File(imageFile!.path).readAsBytesSync());
    });
    // retrieveLostData();
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
                  // Divider(
                  //   height: 1.sp,
                  //   color: Colors.blue,
                  // ),
                  // ListTile(
                  //   onTap: () {
                  //     _openGallery(context);
                  //   },
                  //   title: Text(
                  //     "Gallery",
                  //     style: TextStyle(color: Colors.blue, fontSize: 10.sp),
                  //   ),
                  //   leading: const Icon(
                  //     Icons.account_box,
                  //     color: Colors.blue,
                  //   ),
                  // ),
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
    String action = widget.productdtl.qtyarrival.toString() == "" ||
            widget.productdtl.qtyarrival.toString() == "0"
        ? "add"
        : "update";
    int sisa = widget.productdtl.qtyarrival.toString() == ""
        ? int.parse(widget.productdtl.quantity.toString())
        : int.parse(widget.productdtl.quantity.toString()) -
            int.parse(widget.productdtl.qtyarrival.toString());
    ProductDetailProvider productProvider =
        Provider.of<ProductDetailProvider>(context);

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
          'Product Detail',
          style: primaryTextStyle.copyWith(
            fontSize: 14.sp,
          ),
        ),
        elevation: 0,
      );
    }

    Widget productDetail() {
      return Container(
        margin: EdgeInsets.only(
          top: 5.sp,
        ),
        child: Card(
          elevation: 2,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 5.sp,
                  bottom: 10.sp,
                  right: 10.sp,
                  top: 10.sp,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.sp),
                  child: Image.network(
                    '$urlFile/img/product/${widget.productdtl.imageProduk}',
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/no_image.png',
                        width: 30.w,
                        height: 20.h,
                        fit: BoxFit.cover,
                      );
                    },
                    width: 35.w,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 10.sp,
                    right: 10.sp,
                    top: 10.sp,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.productdtl.productName}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: primaryTextStyle.copyWith(
                          fontSize: 10.sp,
                          fontWeight: semiBold,
                        ),
                      ),
                      Text(
                        "Total Quantity : ${widget.productdtl.quantity.toString()}",
                        style: primaryTextStyle.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                      Text(
                        "Remaining Quantity : ${sisa.toString()}",
                        style: primaryTextStyle.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                      Text(
                        "Date Of Arrival: ${DateTime.now().toString()}",
                        style: primaryTextStyle.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget inputQuantity() {
      return Container(
        margin: EdgeInsets.only(
          top: 20.sp,
          left: 10.sp,
          right: 10.sp,
          bottom: 15.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quantity",
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
                      Icons.onetwothree,
                      size: 17.sp,
                    ),
                    SizedBox(
                      width: 13.sp,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: quantityController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        style: subtitleTextStyle.copyWith(fontSize: 11.sp),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Quantity',
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

    Widget inputNote() {
      return Container(
        margin: EdgeInsets.only(
          left: 10.sp,
          right: 10.sp,
          bottom: 15.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Note",
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 1.sp,
            ),
            Container(
              height: 12.h,
              padding: EdgeInsets.symmetric(horizontal: 12.sp),
              decoration: BoxDecoration(
                  color: backgroundColor2,
                  borderRadius: BorderRadius.circular(10.sp)),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: 6.sp,
                    ),
                    Expanded(
                      child: TextFormField(
                        // onChanged: (text) {
                        //   alamatLengkap = text;
                        // },
                        controller: noteController,
                        minLines: 10,
                        maxLines: null,
                        style: primaryTextStyle.copyWith(fontSize: 10.sp),
                        decoration: InputDecoration.collapsed(
                            hintText: '',
                            hintStyle:
                                subtitleTextStyle.copyWith(fontSize: 10.sp)),
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
                  ? const SizedBox()
                  : Image.file(File(imageFile!.path)),
            ),
            MaterialButton(
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: () {
                _showChoiceDialog(context);
              },
              child: Text(
                "Upload Product",
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
                      child: isLoading == true
                          ? Center(
                              child: Text(
                                'Loading',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: semiBold,
                                ),
                              ),
                            )
                          : TextButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (JwtDecoder.isExpired(token)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration:
                                          const Duration(milliseconds: 500),
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
                                  if (quantityController.text == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        backgroundColor: secondaryColor,
                                        content: Text(
                                          'Quantity Tidak Boleh Kosong !!!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                    );
                                  } else if (int.parse(
                                          quantityController.text) <
                                      1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        backgroundColor: secondaryColor,
                                        content: Text(
                                          'Jumlah Quantity Tidak Boleh 0 !!!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                    );
                                  } else if (int.parse(
                                          quantityController.text) >
                                      sisa) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        backgroundColor: secondaryColor,
                                        content: Text(
                                          'Gagal Tidak Boleh Melebihi Sisa Quantity !!!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                    );
                                  } else if (stringImage == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        backgroundColor: secondaryColor,
                                        content: Text(
                                          'Gagal Foto Product Belum DI Pilih !!!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (await productProvider
                                        .saveProductDetails(
                                      token: token,
                                      strimage: stringImage,
                                      dOProductId: widget.productdtl.doProductId
                                          .toString(),
                                      quantity: quantityController.text,
                                      note: widget.productdtl.notearrival
                                              .toString() +
                                          noteController.text,
                                      arrivedBy: username.toString(),
                                    )) {
                                      widget.callbackReload();
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          backgroundColor: secondaryColor,
                                          content: Text(
                                            "Tidak Dapat Menggapai Server",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                                setState(() {
                                  isLoading = false;
                                });
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
              inputQuantity(),
              inputNote(),
              uploadGambar(),
            ],
          ),
        ),
      );
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
        onWillPop: () async {
          widget.callbackReload();
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: backgroundColor1,
          resizeToAvoidBottomInset: false,
          appBar: header(),
          body: SafeArea(
            child: ListView(
              children: [
                productDetail(),
                productinput(),
              ],
            ),
          ),
          bottomNavigationBar: bottom(),
        ),
      );
    });
  }
}
