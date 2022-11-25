import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/put_away/data_iku_model.dart';
import 'package:wms_deal_ncs/model/put_away/data_storage_model.dart';
import 'package:wms_deal_ncs/model/put_away/product_put_away_model.dart';
import 'package:wms_deal_ncs/model/put_away/put_away_model.dart';
import 'package:wms_deal_ncs/provider/put_away/cek_put_away_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class ProductPutDetail extends StatefulWidget {
  final PutAwayModel detailDO;
  final ProductPutAwayModel productdtl;
  final Function callbackReload;
  const ProductPutDetail(this.detailDO, this.productdtl, this.callbackReload,
      {Key? key})
      : super(key: key);

  @override
  State<ProductPutDetail> createState() => _ProductPutDetailState();
}

class _ProductPutDetailState extends State<ProductPutDetail> {
  TextEditingController quantityController = TextEditingController(text: '');
  TextEditingController noteController = TextEditingController(text: '');

  bool isLoading = false;
  bool isLoadingiku = false;
  String sisaBarang = "";
  String ikuCode = '';
  String storageCode = '';
  List<DataIkuModel> dataiku = [];
  List<DataStorageModel> dataStorage = [];
  String? username;
  String? levelSt;
  String? binSt;
  String? nama;
  String? houseCode;
  String? rowSt;
  String token = "";

  @override
  void initState() {
    validate().whenComplete(() => null);
    super.initState();
  }

  Future validate() async {
    final SharedPreferences session = await SharedPreferences.getInstance();

    var user = session.getString('userName');
    setState(() {
      houseCode = session.getString('houseCode')!;
      token = session.getString('token').toString();
      username = user!;
    });
    sisaBarang = widget.productdtl.sisaQty.toString();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController ikuCodeCOntroller =
        TextEditingController(text: ikuCode);
    TextEditingController storageCodeCOntroller =
        TextEditingController(text: storageCode);

    handleSearchIku() async {
      setState(() {
        isLoadingiku = true;
      });
      if (JwtDecoder.isExpired(token.toString())) {
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
        dataiku = await CekPutAwayProvider().getiku(
          token: token,
          apikey: "",
          dOProductId: widget.productdtl.doProductId.toString(),
          noQrCode: ikuCodeCOntroller.text,
        );
        debugPrint(ikuCodeCOntroller.text);
        if (dataiku.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 500),
              backgroundColor: secondaryColor,
              content: Text(
                'Nomor Iku Tidak Terdaftar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          );
        } else {
          if (dataiku.first.datePutedAway.toString() != '3') {
            debugPrint(dataiku.first.iku);
            debugPrint(dataiku.first.storageCode.toString());
            debugPrint(dataiku.first.datePutedAway.toString());
            dataiku = [];
            setState(() {
              ikuCode = "";
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 500),
                backgroundColor: secondaryColor,
                content: Text(
                  'Nomor Iku Sudah Pernah Di Input' +
                      dataiku.first.datePutedAway.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            );
          } else {
            setState(() {
              ikuCode = ikuCodeCOntroller.text;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 500),
                backgroundColor: succesColor,
                content: Text(
                  'Nomor Iku Berhasil Di Temukan',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            );
          }
        }
      }
      setState(() {
        isLoadingiku = false;
      });
    }

    handleSearchStorageCode() async {
      setState(() {
        isLoading = true;
      });
      if (JwtDecoder.isExpired(token.toString())) {
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
        dataStorage = await CekPutAwayProvider().geStorage(
          token: token,
          apikey: "",
          kodeStorage: storageCodeCOntroller.text,
          houseCode: houseCode.toString(),
        );
        if (dataStorage.isEmpty) {
          setState(() {
            storageCode = "";
          });
          dataStorage = [];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 500),
              backgroundColor: secondaryColor,
              content: Text(
                'Storage Tidak Di Temukan ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          );
        } else {
          setState(() {
            storageCode = storageCodeCOntroller.text;
          });
          levelSt = dataStorage.first.levelCode
              .toString()
              .substring(dataStorage.first.rowCode!.length);
          binSt = dataStorage.first.binCode
              .toString()
              .substring(dataStorage.first.levelCode!.length);
          rowSt =
              dataStorage.first.rowCode.toString().substring(houseCode!.length);
          rowSt =
              rowSt.toString().substring(dataStorage.first.zoneCode!.length);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 500),
              backgroundColor: succesColor,
              content: Text(
                'Storage Berhasil Di Temukan ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          );
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    Future<void> scanCodeStorage() async {
      String scanRes;
      scanRes = await FlutterBarcodeScanner.scanBarcode(
          '#28386a', 'Cancel', true, ScanMode.QR);
      if (scanRes != "-1") {
        if (!mounted) return;
        setState(() {
          // dateArrived = "";
          storageCodeCOntroller.text = scanRes;
        });
        handleSearchStorageCode();
      }
    }

    Future<void> resultIku() async {
      setState(() {});
      handleSearchIku();
    }

    Future<void> scanCodeIku() async {
      String scanRes;
      scanRes = await FlutterBarcodeScanner.scanBarcode(
          '#28386a', 'Cancel', true, ScanMode.QR);
      if (scanRes != "-1") {
        if (!mounted) return;
        setState(() {
          // dateArrived = "";
          ikuCodeCOntroller.text = scanRes;
        });
        resultIku();
      }
    }

    PreferredSizeWidget header() {
      return AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              widget.callbackReload();
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

    Widget storageData() {
      return Container(
        margin: EdgeInsets.only(left: 10.sp),
        child: dataStorage.isEmpty
            ? SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Storage :',
                      style: primaryTextStyle.copyWith(fontSize: 15.sp)),
                  Text('Zone : ${dataStorage.first.zoneCode.toString()}',
                      style: primaryTextStyle.copyWith(fontSize: 12.sp)),
                  Text('Row : $rowSt',
                      style: primaryTextStyle.copyWith(fontSize: 12.sp)),
                  Text('Level  : $levelSt',
                      style: primaryTextStyle.copyWith(fontSize: 12.sp)),
                  Text('Bin  : $binSt',
                      style: primaryTextStyle.copyWith(fontSize: 12.sp)),
                ],
              ),
      );
    }

    Widget scanButtonStorage() {
      return SizedBox(
        height: 5.h,
        child: TextButton(
          onPressed: () => scanCodeStorage(),
          // onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.sp),
            ),
          ),
          child: Text(
            'Scan',
            style: subtitleTextStyle.copyWith(
              fontSize: 10.sp,
              fontWeight: medium,
            ),
          ),
        ),
      );
    }

    Widget searchInputStorage() {
      return Container(
        margin: EdgeInsets.only(
          top: 15.sp,
          bottom: 20.sp,
          left: 5.sp,
          right: 5.sp,
        ),
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
              height: 6.h,
              decoration: BoxDecoration(
                  color: backgroundColor1,
                  borderRadius: BorderRadius.circular(12.sp)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        decoration: BoxDecoration(
                            color: backgroundColor2,
                            borderRadius: BorderRadius.circular(12.sp)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                handleSearchStorageCode();
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
                                onEditingComplete: () {
                                  handleSearchStorageCode();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                controller: storageCodeCOntroller,
                                style:
                                    subtitleTextStyle.copyWith(fontSize: 11.sp),
                                decoration: InputDecoration(
                                  hintText: 'StorageCode',
                                  hintStyle: subtitleTextStyle.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        storageCodeCOntroller.text = "";
                                      });
                                      handleSearchStorageCode();
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
                    Container(
                      margin: EdgeInsets.only(
                        right: 4.sp,
                        top: 2.sp,
                        bottom: 2.sp,
                      ),
                      width: 60.sp,
                      height: 6.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.sp),
                      child: scanButtonStorage(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget scanButtonIKU() {
      return SizedBox(
        height: 5.h,
        child: TextButton(
          onPressed: () => scanCodeIku(),
          // onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.sp),
            ),
          ),
          child: Text(
            'Scan',
            style: subtitleTextStyle.copyWith(
              fontSize: 10.sp,
              fontWeight: medium,
            ),
          ),
        ),
      );
    }

    Widget searchInputIKU() {
      return Container(
        margin: EdgeInsets.only(
          top: 15.sp,
          left: 5.sp,
          right: 5.sp,
        ),
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
              height: 6.h,
              decoration: BoxDecoration(
                  color: backgroundColor1,
                  borderRadius: BorderRadius.circular(12.sp)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        decoration: BoxDecoration(
                            color: backgroundColor2,
                            borderRadius: BorderRadius.circular(12.sp)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                handleSearchIku();
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
                                onEditingComplete: () {
                                  handleSearchIku();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                controller: ikuCodeCOntroller,
                                style:
                                    subtitleTextStyle.copyWith(fontSize: 11.sp),
                                decoration: InputDecoration(
                                  hintText: 'IKU Code',
                                  hintStyle: subtitleTextStyle.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        ikuCodeCOntroller.text = "";
                                      });
                                      handleSearchIku();
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
                    Container(
                      margin: EdgeInsets.only(
                        right: 4.sp,
                        top: 2.sp,
                        bottom: 2.sp,
                      ),
                      width: 60.sp,
                      height: 6.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.sp),
                      child: scanButtonIKU(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
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
                      print(error);
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
                        "Remaining Quantity : $sisaBarang",
                        style: primaryTextStyle.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                      Text(
                        "Size : ${widget.productdtl.sizeName.toString()}",
                        style: primaryTextStyle.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                      // Text(
                      //   "Total Quantity : ${widget.productdtl.quantity.toString()}",
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
        ),
      );
    }

    Widget inputQuantity() {
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

    Widget bottomSku() {
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

                                if (quantityController.text == '') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      backgroundColor: secondaryColor,
                                      content: Text(
                                        'Quantity Belum Di isi',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ),
                                  );
                                } else if (int.parse(quantityController.text) >
                                    int.parse(sisaBarang)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      backgroundColor: secondaryColor,
                                      content: Text(
                                        'Jumlah Quantity Tidak Boleh Melebihi Sisa Barang',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ),
                                  );
                                } else if (storageCode == '') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      backgroundColor: secondaryColor,
                                      content: Text(
                                        'Storage Code Tidak Boleh Kosong ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (JwtDecoder.isExpired(token.toString())) {
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
                                    List response = await CekPutAwayProvider()
                                        .saveSku(
                                            apikey: "",
                                            token: token,
                                            doProductId: widget
                                                .productdtl.doProductId
                                                .toString(),
                                            storageCode:
                                                storageCodeCOntroller.text,
                                            quantity: quantityController.text);
                                    if (response[0] == '200') {
                                      setState(() {
                                        sisaBarang = (int.parse(sisaBarang) -
                                                int.parse(
                                                    quantityController.text))
                                            .toString();
                                        storageCode = "";
                                        dataStorage = [];
                                      });
                                      if (int.parse(sisaBarang) < 1) {
                                        widget.callbackReload();
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            backgroundColor: succesColor,
                                            content: Text(
                                              'Data Tersimpan',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ),
                                        );
                                        setState(() {
                                          quantityController.text = "";
                                          storageCode = "";
                                        });
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          backgroundColor: secondaryColor,
                                          content: Text(
                                            response[1],
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

    Widget bottomIku() {
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
                                  if (storageCode == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        backgroundColor: secondaryColor,
                                        content: Text(
                                          'Storage Code Tidak Boleh Kosong ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                    );
                                  } else if (dataiku.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        backgroundColor: secondaryColor,
                                        content: Text(
                                          'Iku Tidak Boleh Kosong  ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                    );
                                  } else {
                                    List response = await CekPutAwayProvider()
                                        .saveIku(
                                            apikey: "",
                                            token: token,
                                            doProductId: widget
                                                .productdtl.doProductId
                                                .toString(),
                                            noIku: dataiku.first.iku.toString(),
                                            storageCode: dataStorage
                                                .first.storageCode
                                                .toString());
                                    if (response[0] == '200') {
                                      setState(() {
                                        sisaBarang = (int.parse(sisaBarang) - 1)
                                            .toString();
                                        storageCode = "";
                                        dataStorage = [];
                                        dataiku = [];
                                      });
                                      if (int.parse(sisaBarang) < 1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            backgroundColor: succesColor,
                                            content: Text(
                                              'Data Tersimpan',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ),
                                        );
                                        widget.callbackReload();
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            backgroundColor: succesColor,
                                            content: Text(
                                              'Data Tersimpan',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ),
                                        );
                                        setState(() {
                                          ikuCode = "";
                                          storageCode = "";
                                        });
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          backgroundColor: secondaryColor,
                                          content: Text(
                                            response[1],
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
              widget.productdtl.productLevel == 'IKU'
                  ? searchInputIKU()
                  : const SizedBox(),
              searchInputStorage(),
              widget.productdtl.productLevel == 'SKU'
                  ? inputQuantity()
                  : const SizedBox(),

              // inputNote(),
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
                storageData(),
              ],
            ),
          ),
          bottomNavigationBar: widget.productdtl.productLevel == "SKU"
              ? bottomSku()
              : bottomIku(),
        ),
      );
    });
  }
}
