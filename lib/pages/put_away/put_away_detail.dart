import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/put_away/product_put_away_model.dart';
import 'package:wms_deal_ncs/model/put_away/put_away_model.dart';
import 'package:wms_deal_ncs/pages/put_away/product_put_detail.dart';
import 'package:wms_deal_ncs/provider/put_away/product_put_away_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class PutAwayDetail extends StatefulWidget {
  final PutAwayModel detailDO;
  final String dateArrived;
  final Function reload;
  const PutAwayDetail(this.detailDO, this.dateArrived, this.reload, {Key? key})
      : super(key: key);

  @override
  State<PutAwayDetail> createState() => _PutAwayDetailState();
}

class _PutAwayDetailState extends State<PutAwayDetail> {
  List produk = [];
  bool isLoading = false;
  String namaproduk = '';
  String level = "All";
  String token = '';

  callbackReload() {
    loadData();
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
    } catch (e) {
      print('gagal');
    }
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
        List<ProductPutAwayModel> data =
            await ProductPutAwayProvider().getProductPutAways(
          apikey: keyApi,
          token: token,
          noDo: widget.detailDO.noDo.toString(),
          productlevel: level,
          namaProduk: namaproduk,
        );
        setState(() {
          produk = data;
        });
      } catch (e) {
        // print('gagal');
      }
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
        height: 8.h,
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
                        height: 8.h,
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
          'Detail Data',
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
                crossAxisCount: 2,
                childAspectRatio: 1.67.w / 1.20.h,
                mainAxisSpacing: 3,
              ),
              itemCount: produk.length,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (int.parse(produk[index].sisaQty) > 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPutDetail(
                              widget.detailDO, produk[index], callbackReload),
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
                              margin: EdgeInsets.only(left: 7.sp),
                              child: Text(
                                produk[index].productLevel,
                                style: primaryTextStyle.copyWith(
                                  fontSize: 9.sp,
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
                                      fit: BoxFit.cover,
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
                                    Text(
                                      // '${product.namaProduk}',
                                      'SKU : ${produk[index].sku}',
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
                                    int.parse(produk[index].sisaQty) !=
                                            int.parse(produk[index].quantity)
                                        ? Row(
                                            children: [
                                              Text(
                                                'Sudah Di Simpan ',
                                                style:
                                                    primaryTextStyle.copyWith(
                                                  fontSize: 7.sp,
                                                  fontWeight: semiBold,
                                                ),
                                              ),
                                              const Spacer(),
                                              int.parse(produk[index].sisaQty) <
                                                      1
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
                                                'Belum Di Simpan ',
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
                                  widget.detailDO.doSupplier.toString(),
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
                                  "Arrived Date : ${widget.detailDO.dateArrived?.replaceAll('T', ' ')}",
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
