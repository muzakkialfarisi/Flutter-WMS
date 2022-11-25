import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/pick/product_pick_model.dart';
import 'package:wms_deal_ncs/model/put_away/data_iku_model.dart';
import 'package:wms_deal_ncs/model/put_away/data_storage_model.dart';
import 'package:wms_deal_ncs/provider/pick/pick_provider.dart';
import 'package:wms_deal_ncs/provider/put_away/cek_put_away_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class ProductPickDetail extends StatefulWidget {
  // final PickModel pickDetail;
  final ProductPickModel productdtl;
  final int idx;
  final Function callbackreload;
  const ProductPickDetail(
      // this.pickDetail,
      this.productdtl,
      this.idx,
      this.callbackreload,
      {Key? key})
      : super(key: key);

  @override
  State<ProductPickDetail> createState() => _ProductPickDetailState();
}

class _ProductPickDetailState extends State<ProductPickDetail> {
  TextEditingController quantityController = TextEditingController(text: '');
  TextEditingController noteController = TextEditingController(text: '');

  bool isLoading = false;
  bool isLoadingiku = false;
  String sisaBarang = "";
  String storageCode = '';
  List<DataIkuModel> dataiku = [];
  List<DataStorageModel> dataStorage = [];
  bool qualityCek = false;
  String qualityStatus = "Accept";
  String remarks = "";
  String? token;
  String? houseCode;
  String? userId;
  String? levelSt;
  String? binSt;
  String? nama;
  String? rowSt;

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
      token = session.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController storageCodeController =
        TextEditingController(text: storageCode);
    TextEditingController remarksController =
        TextEditingController(text: remarks);

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
          token: token.toString(),
          apikey: "",
          kodeStorage: storageCodeController.text,
          houseCode: houseCode.toString(),
        );
        if (dataStorage.isEmpty) {
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
          setState(() {
            storageCode = "";
          });
          dataStorage = [];
        } else {
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
          setState(() {
            storageCode = storageCodeController.text;
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
          storageCodeController.text = scanRes;
        });
        handleSearchStorageCode();
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
              // widget.callbackreload();
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
                                controller: storageCodeController,
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
                                        storageCodeController.text = "";
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
                      widget.productdtl.productLevel == "IKU"
                          ? Text(
                              "${widget.productdtl.iku}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: primaryTextStyle.copyWith(
                                fontSize: 10.sp,
                                fontWeight: semiBold,
                              ),
                            )
                          : SizedBox(
                              height: 1.w,
                            ),
                      Text(
                        "Total Quantity : ${widget.productdtl.quantity.toString()}",
                        style: primaryTextStyle.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                      Text(
                        "Location : ${widget.productdtl.zoneCode.toString()}/${widget.productdtl.rowCode.toString().substring(houseCode!.length).substring(widget.productdtl.zoneCode!.length)}/${widget.productdtl.levelCode.toString().substring(widget.productdtl.rowCode!.length)}/${widget.productdtl.binCode.toString().substring(widget.productdtl.levelCode!.length)}",
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

    Widget inputQualityCek() {
      return Container(
        margin: EdgeInsets.only(
          left: 6.sp,
          right: 6.sp,
        ),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(5.sp),
            child: SizedBox(
              child: Row(
                children: [
                  Text(
                    'Quality Check: ',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                  Checkbox(
                    value: qualityCek,
                    onChanged: (value) {
                      setState(() {
                        remarks = "";
                        qualityStatus = "Accept";
                        qualityCek = value!;
                      });
                    },
                  ),
                  qualityCek == true
                      ? SizedBox(
                          width: 10.sp,
                        )
                      : SizedBox(
                          width: 1.sp,
                        ),
                  qualityCek == true
                      ? DropdownButton<String>(
                          value: qualityStatus,
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
                              remarks = "";
                              qualityStatus = newValue!;
                            });
                          },
                          items: <String>['Accept', 'Reject']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      : SizedBox(
                          width: 0.sp,
                        ),
                  qualityCek == true
                      ? Icon(
                          Icons.arrow_drop_down,
                          size: 14.sp,
                        )
                      : SizedBox(
                          width: 0.sp,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget remarksInput() {
      return Container(
        margin: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Remarks",
              style: primaryTextStyle.copyWith(
                fontSize: 10.sp,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 1.sp,
            ),
            Container(
              height: 10.h,
              padding: EdgeInsets.symmetric(horizontal: 12.sp),
              decoration: BoxDecoration(
                  color: backgroundColor2,
                  borderRadius: BorderRadius.circular(10.sp)),
              child: Center(
                child: Row(
                  children: [
                    // Image.asset('assets/icon_name.png', width: 4.w),
                    SizedBox(
                      width: 6.sp,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (text) {
                          remarks = text;
                        },
                        controller: remarksController,
                        minLines: 20,
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
                                  if (storageCode == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        backgroundColor: secondaryColor,
                                        content: Text(
                                          'Storage Code Belum Di Input',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (qualityCek == true) {
                                      if (qualityStatus == "Reject" &&
                                          remarks == "") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            backgroundColor: secondaryColor,
                                            content: Text(
                                              'Remarks Harus DI Isi',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ),
                                        );
                                      } else {
                                        List save = await PickProvider()
                                            .saveProductlist(
                                          apikey: "",
                                          token: token.toString(),
                                          storageCode: storageCode,
                                          idPick: widget.productdtl.idPick
                                              .toString(),
                                          iku: widget.productdtl.iku.toString(),
                                          total: widget.productdtl.quantity
                                              .toString(),
                                          userId: userId.toString(),
                                          qcStatus: qualityStatus,
                                          qcremark: remarks,
                                        );
                                        if (save[0] == 200) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              backgroundColor: succesColor,
                                              content: Text(
                                                'Succes Pick',
                                                textAlign: TextAlign.center,
                                                style:
                                                    TextStyle(fontSize: 12.sp),
                                              ),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          widget.callbackreload();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              backgroundColor: secondaryColor,
                                              content: Text(
                                                save[1],
                                                textAlign: TextAlign.center,
                                                style:
                                                    TextStyle(fontSize: 12.sp),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      List save =
                                          await PickProvider().saveProductlist(
                                        apikey: "",
                                        token: token.toString(),
                                        storageCode: storageCode,
                                        idPick:
                                            widget.productdtl.idPick.toString(),
                                        iku: widget.productdtl.iku.toString(),
                                        total: widget.productdtl.quantity
                                            .toString(),
                                        userId: userId.toString(),
                                        qcStatus: "",
                                        qcremark: "",
                                      );
                                      if (save[0] == 200) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            backgroundColor: succesColor,
                                            content: Text(
                                              'Succes Pick',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ),
                                        );
                                        Navigator.pop(context);
                                        widget.callbackreload();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: const Duration(
                                                milliseconds: 500),
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
                                'Pick',
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
              // widget.productdtl.productLevel == 'IKU'
              //     ? searchInputIKU()
              //     : const SizedBox(),
              searchInputStorage(),
              inputQualityCek(),
              qualityStatus == "Reject" ? remarksInput() : const SizedBox(),
              // widget.productdtl.productLevel == 'SKU'
              // ?
              // inputQuantity()
              // : const SizedBox(),

              // inputNote(),
            ],
          ),
        ),
      );
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
        onWillPop: () async {
          // widget.callbackreload();
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
                houseCode == null ? Text("Loading") : productDetail(),
                productinput(),
                storageData(),
              ],
            ),
          ),
          bottomNavigationBar:
              // widget.productdtl.productLevel == "SKU" ? bottomSku() : bottomIku(),
              bottom(),
        ),
      );
    });
  }
}
