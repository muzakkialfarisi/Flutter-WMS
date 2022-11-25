import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/delivery_order/delivery_order_model.dart';
import 'package:wms_deal_ncs/model/delivery_order/product_detail_model.dart';
import 'package:wms_deal_ncs/pages/delivery%20order/delivery_order_upload_do_page.dart';
import 'package:wms_deal_ncs/pages/delivery%20order/print_label_order.dart';
import 'package:wms_deal_ncs/pages/delivery%20order/product_order_detail.dart';
import 'package:wms_deal_ncs/provider/delivery_order/product_detail_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class DeliveryOrderDetail extends StatefulWidget {
  final DeliveryOrderModel detailDO;
  final String dateArrived;
  final Function reload;
  const DeliveryOrderDetail(this.detailDO, this.dateArrived, this.reload,
      {Key? key})
      : super(key: key);

  @override
  State<DeliveryOrderDetail> createState() => _DeliveryOrderDetailState();
}

class _DeliveryOrderDetailState extends State<DeliveryOrderDetail> {
  List produk = [];
  bool isLoading = false;
  String token = '';

  callbackReload() {
    getsession();
  }

  @override
  void initState() {
    getsession().whenComplete(() => null);
    super.initState();
  }

  Future getsession() async {
    try {
      final SharedPreferences session = await SharedPreferences.getInstance();

      setState(() {
        token = session.getString('token')!;
      });
      // ignore: empty_catches
    } catch (e) {}
    loadData();
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });
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
      final SharedPreferences share = await SharedPreferences.getInstance();
      share.clear();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      try {
        List<ProductDetailModel> data =
            await ProductDetailProvider().getProductDetails(
          apikey: keyApi,
          token: token,
          noDo: widget.detailDO.noDo.toString(),
        );
        setState(() {
          produk = data;
        });
        // ignore: empty_catches
      } catch (e) {}
    }
    setState(() {
      isLoading = false;
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
              widget.reload();
              Navigator.pop(context);
            }),
        backgroundColor: backgroundColor2,
        centerTitle: true,
        title: Text(
          'Detail Delivery Order',
          style: primaryTextStyle.copyWith(
            fontSize: 14.sp,
          ),
        ),
        elevation: 0,
      );
    }

    Widget dataNotfound() {
      return Center(
        child: Container(
          padding: EdgeInsets.only(
            top: 10.sp,
          ),
          margin: EdgeInsets.only(left: 19.sp, right: 19.sp),
          child: Text(
            "Data Tidak Di Temukan",
            style: primaryTextStyle.copyWith(
                fontSize: 15.sp, fontWeight: semiBold),
          ),
        ),
      );
    }

    Widget product() {
      return produk.isEmpty
          ? dataNotfound()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.67.w / 1.40.h,
                mainAxisSpacing: 3,
              ),
              itemCount: produk.length,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (produk[index].status == '0') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductOrderDetail(
                            widget.detailDO,
                            produk[index],
                            widget.detailDO.dateCreated == null
                                ? ''
                                : widget.detailDO.dateCreated!.substring(0, 10),
                            callbackReload,
                          ),
                        ),
                      );
                    } else if (int.parse(produk[index].qtyarrival) <
                        int.parse(produk[index].quantity)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductOrderDetail(
                            widget.detailDO,
                            produk[index],
                            widget.detailDO.dateCreated == null
                                ? ''
                                : widget.detailDO.dateCreated!.substring(0, 10),
                            callbackReload,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 5.sp,
                      right: 5.sp,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.sp),
                      ),
                      elevation: 2,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 5.sp,
                          left: 5.sp,
                          right: 5.sp,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 10.sp,
                                bottom: 10.sp,
                              ),
                              child: Text(
                                produk[index].productLevel,
                                style: primaryTextStyle.copyWith(
                                  fontSize: 8.sp,
                                ),
                              ),
                            ),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.sp),
                                child: Image.network(
                                  '$urlFile/img/product/${produk[index].imageProduk}',
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/no_image.png',
                                      width: 80.sp,
                                      height: 80.sp,
                                    );
                                  },
                                  width: 80.sp,
                                  height: 80.sp,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12.sp,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: 12.sp,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 3.sp,
                                    ),
                                    Text(
                                      // '${product.namaProduk}',
                                      '${produk[index].productName} \n',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 8.sp,
                                        fontWeight: semiBold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3.sp,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'SKU Number',
                                          style: primaryTextStyle.copyWith(
                                            fontSize: 7.sp,
                                            fontWeight: semiBold,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${produk[index].sku}',
                                          style: primaryTextStyle.copyWith(
                                            fontSize: 7.sp,
                                            fontWeight: semiBold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3.sp,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity',
                                          style: primaryTextStyle.copyWith(
                                            fontSize: 7.sp,
                                            fontWeight: semiBold,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${produk[index].quantity}',
                                          style: primaryTextStyle.copyWith(
                                            fontSize: 7.sp,
                                            fontWeight: semiBold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3.sp,
                                    ),
                                    int.parse(produk[index].qtyarrival) == 0
                                        ? Row(
                                            children: [
                                              Text(
                                                'Belum Di Upload',
                                                style:
                                                    primaryTextStyle.copyWith(
                                                  fontSize: 7.sp,
                                                  fontWeight: semiBold,
                                                ),
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              )
                                            ],
                                          )
                                        : produk[index].status == '1'
                                            ? Row(
                                                children: [
                                                  Text(
                                                    'Sudah Di Upload',
                                                    style: primaryTextStyle
                                                        .copyWith(
                                                      fontSize: 7.sp,
                                                      fontWeight: semiBold,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  int.parse(produk[index]
                                                              .qtyarrival) >=
                                                          int.parse(
                                                              produk[index]
                                                                  .quantity)
                                                      ? const Icon(
                                                          Icons.done,
                                                          color: Colors.blue,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .sim_card_alert_sharp,
                                                          color: Colors.orange,
                                                        )
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    'Belum Di Upload',
                                                    style: primaryTextStyle
                                                        .copyWith(
                                                      fontSize: 7.sp,
                                                      fontWeight: semiBold,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                  )
                                                ],
                                              ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
    }

    Widget loading() {
      return Center(
        child: Container(
          padding: EdgeInsets.only(
            top: 10.sp,
          ),
          margin: EdgeInsets.only(left: 19.sp, right: 19.sp),
          child: Text(
            "Loading",
            style: primaryTextStyle.copyWith(
                fontSize: 15.sp, fontWeight: semiBold),
          ),
        ),
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.only(
          left: 10.sp,
          right: 10.sp,
        ),
        width: double.infinity,
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.sp),
              ),
              // margin: EdgeInsets.only(top: 18.sp),
              elevation: 2,
              child: Container(
                margin: EdgeInsets.only(
                  left: 5.sp,
                  right: 5.sp,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 8.sp,
                        left: 10.sp,
                        right: 10.sp,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.detailDO.doSupplier.toString(),
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 11.sp,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                Text(
                                  widget.detailDO.status.toString(),
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 11.sp,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 2.sp,
                        left: 10.sp,
                        right: 10.sp,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.detailDO.tenatName.toString(),
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 2.sp,
                        left: 10.sp,
                        right: 10.sp,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.detailDO.houseName.toString(),
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 2.sp,
                        left: 10.sp,
                        right: 10.sp,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.detailDO.houseAddress.toString(),
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 2.sp,
                        left: 10.sp,
                        right: 10.sp,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.detailDO.dateDelivered == null
                                      ? ''
                                      // : "Receiving Date : ${widget.detailDO.dateDelivered!.substring(0, 10)}",
                                      : "Receiving Date : ${widget.detailDO.dateDelivered?.replaceAll('T', ' ')}",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                  ],
                ),
              ),
            ),
            isLoading == true ? loading() : product()
          ],
        ),
      );
    }

    Widget bottom() {
      return Container(
        color: backgroundColor1,
        child: Container(
          width: double.infinity,
          height: produk.where((e) => e.statusDo == 'DO').isNotEmpty ||
                  (widget.detailDO.status.toString() != 'DO' &&
                      widget.detailDO.dateArrived.toString() != 'null')
              ? 7.h
              : 12.h,
          margin: EdgeInsets.all(
            10.sp,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 5.h,
                      child: TextButton(
                        onPressed: () async {
                          await [
                            Permission.location,
                            Permission.bluetoothConnect,
                            Permission.bluetoothScan,
                            Permission.bluetoothAdvertise,
                            Permission.bluetooth,
                          ].request();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrintLabelOrder(
                                widget.detailDO,
                                produk,
                                token,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: backgroundColor4,
                        ),
                        child: Text(
                          'Print Label IKU',
                          style: primaryTextStyle.copyWith(
                            fontSize: 10.sp,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.sp,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 5.h,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(9.sp),
                          // ),
                          backgroundColor: backgroundColor4,
                        ),
                        child: Text(
                          'Print Receipt Note',
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
              SizedBox(
                height: 10.sp,
              ),
              produk.where((e) => e.statusDo == 'DO').isNotEmpty ||
                      (widget.detailDO.status.toString() != 'DO' &&
                          widget.detailDO.dateArrived.toString() != 'null')
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 5.h,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryOrderUploadDoPage(
                                      widget.detailDO,
                                      callbackReload,
                                      token,
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(9.sp),
                                // ),
                                backgroundColor: backgroundColor4,
                              ),
                              child: Text(
                                'Upload DO Image',
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

    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
        onWillPop: () async {
          widget.reload();
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: backgroundColor3,
          appBar: header(),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor4,
                  backgroundColor3,
                ],
              ),
            ),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(10.sp),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.sp),
                  ),
                ),
                content(),
              ],
            ),
          ),
          bottomNavigationBar:
              produk.where((x) => x.status!.toLowerCase().contains('0')).isEmpty
                  ? bottom()
                  : SizedBox(),
        ),
      );
    });
  }
}
