import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/pick/pick_model.dart';
import 'package:wms_deal_ncs/model/pick/product_pick_model.dart';
import 'package:wms_deal_ncs/pages/pick/pick_list_detail.dart';
import 'package:wms_deal_ncs/pages/pick/product_pick_detail.dart';
import 'package:wms_deal_ncs/pages/pick/upload_stagging.dart';
import 'package:wms_deal_ncs/provider/pick/pick_provider.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:intl/intl.dart';

class PickPage extends StatefulWidget {
  const PickPage({Key? key}) : super(key: key);

  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> with TickerProviderStateMixin {
  final format = DateFormat("dd-MM-yyyy");
  String dateOrder = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
  List pickdata = [];
  List tenant = [];
  List warehouse = [];
  List productPick = [];
  bool isLoading = false;
  bool loadingButton = false;
  String tenantId = '';
  late TabController _tabController;
  int idx = 0;
  String? houseCode;
  String? userId;
  String token = "";
  String flagPick = "0";
  var isChecked = true;
  String currText = '';
  bool isLoadingP = false;
  String namaproduk = '';
  String level = "All";
  String status = "2";
  String idPickAssign = "";

  callbackProduct() async {
    setState(() {
      flagPick = "2";
      idx = 1;
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
        List<ProductPickModel> data = await PickProvider().getPickproduct(
          apikey: keyApi,
          token: token,
          userId: userId.toString(),
          pickedStatus: "Ordered",
        );
        if (data.isNotEmpty) {
          String pickAssId = await PickProvider().getAssignPick(
            apikey: keyApi,
            token: token,
            userId: userId.toString(),
            idPick: data.first.idPick.toString(),
          );
          setState(() {
            productPick = data;
            idPickAssign = pickAssId;
          });
        } else {
          setState(() {
            productPick = [];
            idPickAssign = "";
          });
        }
      } catch (e) {
        print('gagal');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  reload() {
    if (idx == 0) {
      status = "2";
      flagPick = "0";
      loadData();
    } else if (idx == 1) {
      flagPick = "2";
      loadProduct();
    } else {
      status = "4";
      flagPick = "1";
      loadData();
    }
  }

  @override
  void initState() {
    validate().whenComplete(() => null);
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Future validate() async {
    final SharedPreferences session = await SharedPreferences.getInstance();

    var housecd = session.getString('houseCode');
    var user = session.getString('userId');
    setState(() {
      houseCode = housecd!;
      userId = user!;
      token = session.getString('token').toString();
    });
    loadData().whenComplete(() => null);
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
        List<PickModel> data = await PickProvider().getpicks(
          apikey: keyApi,
          flagPick: flagPick,
          orderId: "",
          status: status,
          token: token,
          houseCode: houseCode.toString(),
          dateOrder: dateOrder,
          tenantId: "",
        );
        setState(() {
          pickdata = data;
        });
      } catch (e) {
        print('gagal');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future loadProduct() async {
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
        List<ProductPickModel> data = await PickProvider().getPickproduct(
          apikey: keyApi,
          token: token,
          userId: userId.toString(),
          pickedStatus: "Ordered",
        );
        if (data.isNotEmpty) {
          String pickAssId = await PickProvider().getAssignPick(
            apikey: keyApi,
            token: token,
            userId: userId.toString(),
            idPick: data.first.idPick.toString(),
          );
          setState(() {
            productPick = data;
            idPickAssign = pickAssId;
          });
        } else {
          setState(() {
            productPick = [];
            idPickAssign = "";
          });
        }
      } catch (e) {
        print('gagal');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    handleListOrder() async {
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
          List data = await PickProvider().saveOrderPicks(
            apikey: keyApi,
            orderId: pickdata
                .where((w) => w.checked == true)
                .map((e) => {"orderId": e.orderId})
                .toList(),
            houseCode: houseCode.toString(),
            token: token,
            userId: userId.toString(),
          );
          if (data[0] != '200') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 500),
                backgroundColor: secondaryColor,
                content: Text(
                  data[1],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            );
            reload();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 500),
                backgroundColor: succesColor,
                content: Text(
                  "Succes Select Pick",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            );
            callbackProduct();
          }
        } catch (e) {
          print('gagal');
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    Widget dataNotfound() {
      return Center(
        child: Container(
          padding: EdgeInsets.only(
            top: 20.sp,
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

    Widget categories() {
      return Container(
        margin: EdgeInsets.only(top: 4.h, left: 20.sp),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            GestureDetector(
              onTap: () async {
                setState(() {
                  idx = 0;
                });
                reload();
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
                margin: EdgeInsets.only(right: 10.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all(color: subtitleColor),
                    color: idx == 0 ? primaryColor : transparentColor),
                child: Text(
                  "List Order",
                  style: primaryTextStyle.copyWith(
                      fontSize: 10.sp, fontWeight: medium),
                ),
              ),
            ),
            SizedBox(
              width: 10.sp,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  idx = 1;
                });
                reload();
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
                margin: EdgeInsets.only(right: 10.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all(color: subtitleColor),
                    color: idx == 1 ? primaryColor : transparentColor),
                child: Text(
                  "List Pick",
                  style: primaryTextStyle.copyWith(
                      fontSize: 10.sp, fontWeight: medium),
                ),
              ),
            ),
            SizedBox(
              width: 10.sp,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  idx = 2;
                });
                reload();
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
                margin: EdgeInsets.only(right: 10.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all(color: subtitleColor),
                    color: idx == 2 ? primaryColor : transparentColor),
                child: Text(
                  "Success Pick",
                  style: primaryTextStyle.copyWith(
                      fontSize: 10.sp, fontWeight: medium),
                ),
              ),
            ),
          ]),
        ),
      );
    }

    Widget listOrder() {
      return Column(
          children: pickdata
              .map(
                (data) => Container(
                  padding: EdgeInsets.only(
                    left: 5.sp,
                    right: 5.sp,
                    top: 5.sp,
                    bottom: 5.sp,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    child: CheckboxListTile(
                      title: Container(
                        padding: EdgeInsets.only(
                          left: 5.sp,
                          right: 5.sp,
                          top: 5.sp,
                          bottom: 5.sp,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data.tenantName}',
                              style: primaryTextStyle.copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                            SizedBox(
                              height: 2.sp,
                            ),
                            Text(
                              'Order : ${data.orderId}',
                              style: primaryTextStyle.copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                            SizedBox(
                              height: 2.sp,
                            ),
                            Text(
                              data.dateOrder.substring(0, 10),
                              style: primaryTextStyle.copyWith(
                                fontSize: 9.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: data.checked,
                      onChanged: (val) {
                        setState(() {
                          if (data.checked == true) {
                            data.checked = false;
                          } else {
                            data.checked = true;
                          }
                          if (val == true) {
                            currText = data.tenantName;
                          }
                        });
                      },
                    ),
                  ),
                ),
              )
              .toList());
    }

    Widget listProduct() {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1.67.w / 0.4.h,
            mainAxisSpacing: 3,
          ),
          itemCount: productPick.length,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if (productPick[index].pickedStatus == "Ordered") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPickDetail(
                        // widget.detailPick,
                        productPick[index],
                        1,
                        callbackProduct,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: 20.sp,
                  right: 20.sp,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 20.sp,
                          top: 5.sp,
                          bottom: 5.sp,
                        ),
                        child: Row(
                          children: [
                            Text(
                              productPick[index].productLevel,
                              style: primaryTextStyle.copyWith(
                                fontSize: 9.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 20.sp,
                              right: 20.sp,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.sp),
                              child: Image.network(
                                '$urlFile/img/product/${productPick[index].imageProduk}',
                                errorBuilder: (context, error, stackTrace) {
                                  print(error);
                                  return Image.asset(
                                    'assets/no_image.png',
                                    width: 25.w,
                                    height: 15.h,
                                    fit: BoxFit.cover,
                                  );
                                },
                                width: 25.w,
                                height: 15.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: 10.sp,
                                top: 20.sp,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${productPick[index].productName}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 10.sp,
                                      fontWeight: semiBold,
                                    ),
                                  ),
                                  productPick[index].productLevel == 'IKU'
                                      ? Text(
                                          "${productPick[index].iku}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: primaryTextStyle.copyWith(
                                            fontSize: 9.sp,
                                          ),
                                        )
                                      : SizedBox(
                                          height: 1.w,
                                        ),
                                  Text(
                                    "Total Quantity : ${productPick[index].quantity.toString()}",
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  // Text(
                                  //   produk[index].storageCode.toString(),
                                  //   style: primaryTextStyle.copyWith(
                                  //     fontSize: 10.sp,
                                  //   ),
                                  // ),
                                  Row(
                                    children: [
                                      Text(
                                        // "location : ${produk[index].zoneCode.toString()}/${produk[index].rowCode.toString()}/${produk[index].levelCode.toString()}/${produk[index].binCode.toString()}",
                                        "Location : ${productPick[index].zoneCode.toString()}/${productPick[index].rowCode.toString().substring(houseCode!.length).substring(productPick[index].zoneCode.length)}/${productPick[index].levelCode.toString().substring(productPick[index].rowCode!.length)}/${productPick[index].binCode.toString().substring(productPick[index].levelCode!.length)}",
                                        style: primaryTextStyle.copyWith(
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      productPick[index].pickedStatus ==
                                              "Ordered"
                                          ? const SizedBox()
                                          : const Expanded(
                                              child: Icon(
                                                Icons.done,
                                                color: Colors.blue,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
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
          });
    }

    Widget listDonePick() {
      return Column(
        children: pickdata
            .map(
              (data) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickListDetail(
                        data,
                        '',
                        idx,
                        reload,
                        token,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor2,
                  ),
                  padding: EdgeInsets.all(10.sp),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    // margin: EdgeInsets.only(top: 18.sp),
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.only(left: 5.sp),
                      decoration: BoxDecoration(
                        color: backgroundColor1,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 5.sp,
                              right: 5.sp,
                              top: 5.sp,
                              bottom: 5.sp,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data.tenantName}',
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 10.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.sp,
                                ),
                                Text(
                                  'Order : ${data.orderId}',
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 10.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.sp,
                                ),
                                // Text(
                                //   'Total Product : ${data.totalProduct}',
                                //   style: primaryTextStyle.copyWith(
                                //     fontSize: 10.sp,
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 2.sp,
                                // ),
                                // Text(
                                //   'Qty : ${data.totalQty}',
                                //   style: primaryTextStyle.copyWith(
                                //     fontSize: 10.sp,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 5.sp,
                                right: 5.sp,
                                top: 5.sp,
                                bottom: 5.sp,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data.dateOrder.substring(0, 10),
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25.sp,
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
              ),
            )
            .toList(),
      );
    }

    Widget list() {
      if (idx == 0) {
        return pickdata.isEmpty ? dataNotfound() : listOrder();
      } else if (idx == 1) {
        return productPick.isEmpty ? dataNotfound() : listProduct();
      } else {
        return pickdata.isEmpty ? dataNotfound() : listDonePick();
      }
    }

    Widget listDataPick() {
      return Container(
          margin: EdgeInsets.only(
            top: 10.sp,
          ),
          child: list());
    }

    Widget bottomOrderPick() {
      return loadingButton == true
          ? loading()
          : pickdata.isEmpty
              ? const SizedBox()
              : Container(
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
                                            loadingButton = true;
                                          });
                                          handleListOrder();
                                          setState(() {
                                            loadingButton = false;
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

    Widget bottomListPick() {
      return loadingButton == true
          ? loading()
          : productPick.isEmpty
              ? const SizedBox()
              : productPick.where((p) => p.pickedStatus == "Ordered").isEmpty
                  ? Container(
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadStaggingPage(
                                                    idPickAssign,
                                                    callbackProduct,
                                                    userId.toString(),
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
                                              'Upload Stagging',
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
                    )
                  : const SizedBox();
    }

    Widget bottom() {
      return idx == 0 ? bottomOrderPick() : bottomListPick();
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: backgroundColor1,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
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
              'Pick Page',
              style: primaryTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            ),
            elevation: 0,
          ),
          body: Container(
            child: ListView(
              children: [
                categories(),
                Container(
                    padding: EdgeInsets.only(
                      right: 15.sp,
                      left: 15.sp,
                      top: 10.sp,
                    ),
                    child: Divider(
                      color: Colors.black,
                      height: 10.sp,
                    )),
                isLoading == true ? loading() : listDataPick(),
                //loading(),
              ],
            ),
          ),
          bottomNavigationBar: idx != 2 ? bottom() : const SizedBox(),
        ),
      );
    });
  }
}
