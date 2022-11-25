import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/pick/pick_model.dart';
import 'package:wms_deal_ncs/model/pick/product_pick_done_model.dart';
import 'package:wms_deal_ncs/pages/pick/product_pick_detail.dart';
import 'package:wms_deal_ncs/provider/pick/pick_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class PickListDetail extends StatefulWidget {
  final PickModel detailPick;
  final String dateArrived;
  final int idx;
  final Function reload;
  final token;
  const PickListDetail(
      this.detailPick, this.dateArrived, this.idx, this.reload, this.token,
      {Key? key})
      : super(key: key);

  @override
  State<PickListDetail> createState() => _PickListDetailState();
}

class _PickListDetailState extends State<PickListDetail> {
  List produk = [];
  bool isLoading = false;
  String namaproduk = '';
  String level = "All";
  String? houseCode;
  String? userId;

  callbackReload() {
    loadData();
  }

  @override
  void initState() {
    validate().whenComplete(() => null);
    super.initState();
  }

  Future validate() async {
    final SharedPreferences session = await SharedPreferences.getInstance();
    var housecd = session.getString('houseCode');
    var user = session.getString('userId');
    setState(() {
      houseCode = housecd!;
      userId = user!;
    });
    loadData().whenComplete(() => null);
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });
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
      final SharedPreferences share = await SharedPreferences.getInstance();
      share.clear();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      try {
        List<ProductPickDoneModel> data = await PickProvider().getproductDone(
          apikey: keyApi,
          orderId: widget.detailPick.orderId.toString(),
          nameproduct: namaproduk,
          productLevel: level,
          token: widget.token,
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
    TextEditingController namaprodukCOntroller =
        TextEditingController(text: namaproduk);
    TextEditingController levelCOntroller = TextEditingController(text: level);

    handleSearch() async {
      setState(() {
        isLoading = true;
      });
      setState(() {
        namaproduk = namaprodukCOntroller.text;
      });
      loadData();
      setState(() {
        isLoading = false;
      });
    }

    Widget selectProductLevel() {
      return Container(
        margin: EdgeInsets.only(
          right: 5.sp,
          left: 5.sp,
        ),
        height: 10.h,
        width: 100.sp,
        padding: EdgeInsets.symmetric(horizontal: 13.sp),
        decoration: BoxDecoration(
            color: backgroundColor2,
            borderRadius: BorderRadius.circular(12.sp)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Level',
              style: primaryTextStyle.copyWith(
                fontSize: 7.sp,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: levelCOntroller.text,
                    elevation: 16,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 0.sp,
                    ),
                    style: primaryTextStyle.copyWith(fontSize: 10.sp),
                    underline: Container(
                      height: 0,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        level = newValue!;
                      });
                      handleSearch();
                    },
                    items: <String>['All', 'SKU', 'IKU']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 14.sp,
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget searchInput() {
      return Container(
        margin: EdgeInsets.only(top: 5.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.3.h,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 4.sp,
                right: 4.sp,
              ),
              height: 10.h,
              decoration: BoxDecoration(
                  // color: backgroundColor1,
                  borderRadius: BorderRadius.circular(12.sp)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 10.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        decoration: BoxDecoration(
                            color: backgroundColor2,
                            borderRadius: BorderRadius.circular(12.sp)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                handleSearch();
                              },
                              child: Icon(
                                Icons.search,
                                size: 17.sp,
                              ),
                            ),
                            SizedBox(
                              width: 13.sp,
                            ),
                            Expanded(
                              child: TextFormField(
                                textInputAction: TextInputAction.search,
                                // onChanged: (text) {
                                //   handleSearch();
                                //   FocusScope.of(context)
                                //       .requestFocus(FocusNode());
                                // },
                                onEditingComplete: () {
                                  handleSearch();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                controller: namaprodukCOntroller,
                                style:
                                    subtitleTextStyle.copyWith(fontSize: 11.sp),
                                decoration: InputDecoration(
                                  hintText: 'Search Product',
                                  hintStyle: subtitleTextStyle.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        namaprodukCOntroller.text = "";
                                      });
                                      handleSearch();
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.sp,
                    ),
                    selectProductLevel(),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

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
          widget.idx == 1 ? 'Pick Data' : 'Done Pick',
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

    Widget productSKU() {
      return produk.isEmpty
          ? dataNotfound()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.67.w / 0.4.h,
                mainAxisSpacing: 3,
              ),
              itemCount: produk.length,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (widget.idx == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPickDetail(
                            // widget.detailPick,
                            produk[index],
                            widget.idx,
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
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.sp),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 22.sp, top: 5.sp),
                            child: Text(
                              produk[index].productLevel,
                              style: primaryTextStyle.copyWith(
                                fontSize: 9.sp,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 20.sp,
                                  bottom: 10.sp,
                                  right: 10.sp,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  child: Image.network(
                                    '$urlFile/img/product/${produk[index].imageProduk}',
                                    errorBuilder: (context, error, stackTrace) {
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
                                    right: 10.sp,
                                    top: 10.sp,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${produk[index].productName}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: primaryTextStyle.copyWith(
                                          fontSize: 10.sp,
                                          fontWeight: semiBold,
                                        ),
                                      ),
                                      Text(
                                        "Total Quantity : ${produk[index].quantity.toString()}",
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
                                      // Text(
                                      //   // "location : ${produk[index].zoneCode.toString()}/${produk[index].rowCode.toString()}/${produk[index].levelCode.toString()}/${produk[index].binCode.toString()}",
                                      //   "Location : ${produk[index].zoneCode.toString()}/${produk[index].rowCode.toString().substring(houseCode!.length).substring(produk[index].zoneCode.length)}/${produk[index].levelCode.toString().substring(produk[index].rowCode!.length)}/${produk[index].binCode.toString().substring(produk[index].levelCode!.length)}",
                                      //   style: primaryTextStyle.copyWith(
                                      //     fontSize: 10.sp,
                                      //   ),
                                      // ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "Order Id : ${widget.detailPick.orderId.toString()}",
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
                                  "Date Order : ${widget.detailPick.dateOrder!.substring(0, 10)}",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 9.sp,
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
                        top: 4.sp,
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
                                  "Penerima :",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 9.sp,
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
                                  "Nama : ${widget.detailPick.nama}",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 9.sp,
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
                                  "No Telp: ${widget.detailPick.noTelp}",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 9.sp,
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
                                  "Alamat : ${widget.detailPick.address}",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 9.sp,
                                    fontWeight: semiBold,
                                  ),
                                  maxLines: 4,
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
            Container(
              margin: EdgeInsets.only(bottom: 5.sp),
              child: searchInput(),
            ),
            // selectProductLevel(),
            isLoading == true ? loading() : productSKU()
          ],
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
        ),
      );
    });
  }
}
