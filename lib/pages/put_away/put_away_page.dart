import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/put_away/put_away_model.dart';
import 'package:wms_deal_ncs/model/tenant_model.dart';
import 'package:wms_deal_ncs/pages/put_away/put_away_detail.dart';
import 'package:wms_deal_ncs/provider/put_away/put_away_provider.dart';
import 'package:wms_deal_ncs/provider/tenant_provider.dart';
import 'package:wms_deal_ncs/theme.dart';
import 'package:intl/intl.dart';

class PutAwayPage extends StatefulWidget {
  const PutAwayPage({Key? key}) : super(key: key);

  @override
  State<PutAwayPage> createState() => _PutAwayPageState();
}

class _PutAwayPageState extends State<PutAwayPage> {
  final format = DateFormat("dd-MM-yyyy");
  String dateArrived =
      DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
  String noDO = '';
  List deliverydata = [];
  List tenant = [];
  List warehouse = [];
  bool isLoading = false;
  String tenantId = '';
  String houseCode = '';
  String warehouseName = '';
  String token = '';
  String sts = "AR";
  int idx = 0;
  reload() {
    loadData();
  }

  @override
  void initState() {
    getwarehouse().whenComplete(() => null);
    super.initState();
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
        List<PutAwayModel> data = await PutAwayProvider().getDeliveryOrders(
          token: token,
          apikey: keyApi,
          noDo: "",
          houseCode: houseCode.toString(),
          tenant: "",
          date: dateArrived,
          status: sts,
        );
        setState(() {
          deliverydata = data;
        });
      } catch (e) {
        print('gagal');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future getwarehouse() async {
    try {
      final SharedPreferences session = await SharedPreferences.getInstance();

      setState(() {
        token = session.getString('token')!;
        warehouse = [session.getString('houseName')!];
        houseCode = session.getString('houseCode')!;
        warehouseName = session.getString('houseName')!;
      });
    } catch (e) {
      print('gagal');
    }
    gettenant();
    loadData();
  }

  Future gettenant() async {
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
        List<TenantModel> data = await TenantProvider().gettenants(
          apikey: keyApi,
          houseCode: houseCode,
          token: token,
        );
        setState(() {
          tenant = data;
        });
      } catch (e) {
        print('gagal');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController noDoCOntroller = TextEditingController(text: noDO);
    TextEditingController tenantController =
        TextEditingController(text: tenantId);
    TextEditingController warehouseController =
        TextEditingController(text: warehouseName);
    TextEditingController tanggalController =
        TextEditingController(text: dateArrived);

    handleSearch() async {
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
          List<PutAwayModel> data = await PutAwayProvider().getDeliveryOrders(
            token: token,
            apikey: keyApi,
            noDo: noDoCOntroller.text,
            houseCode: houseCode,
            tenant: tenantId,
            date: dateArrived,
            status: sts,
          );
          setState(() {
            noDO = noDoCOntroller.text;
            deliverydata = data;
          });
        } catch (e) {
          print('gagal');
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    Future<void> scanCode() async {
      String scanRes;
      scanRes = await FlutterBarcodeScanner.scanBarcode(
          '#28386a', 'Cancel', true, ScanMode.QR);
      if (scanRes != "-1") {
        if (!mounted) return;
        setState(() {
          dateArrived = "";
          noDoCOntroller.text = scanRes;
        });
        handleSearch();
      }
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
          'Put Away',
          style: primaryTextStyle.copyWith(
            fontSize: 14.sp,
          ),
        ),
        elevation: 0,
      );
    }

    Widget scanButton() {
      return SizedBox(
        height: 5.h,
        child: TextButton(
          onPressed: () => scanCode(),
          // onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
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

    Widget searchInput() {
      return Container(
        margin: EdgeInsets.only(top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.3.h,
            ),
            Container(
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
                        padding: EdgeInsets.symmetric(horizontal: 13.sp),
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
                                onEditingComplete: () {
                                  handleSearch();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                controller: noDoCOntroller,
                                style:
                                    subtitleTextStyle.copyWith(fontSize: 11.sp),
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: subtitleTextStyle.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        noDoCOntroller.text = "";
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
                      width: 5.sp,
                    ),
                    Container(
                      width: 60.sp,
                      height: 6.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.sp),
                      child: scanButton(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget selectInput() {
      return Container(
        margin: EdgeInsets.only(top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.3.h,
            ),
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 10.h,
                      padding: EdgeInsets.symmetric(horizontal: 13.sp),
                      decoration: BoxDecoration(
                          color: backgroundColor2,
                          borderRadius: BorderRadius.circular(12.sp)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tenant',
                            style: primaryTextStyle.copyWith(
                              fontSize: 8.sp,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: tenantController.text,
                                  elevation: 16,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 0.sp,
                                  ),
                                  style: primaryTextStyle.copyWith(
                                      fontSize: 10.sp),
                                  underline: Container(
                                    height: 0,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      tenantId = newValue!;
                                    });
                                    handleSearch();
                                  },
                                  items: tenant
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value.tenantid.toString(),
                                      child: Text(value.name.toString()),
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
                    ),
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Expanded(
                    child: Container(
                      height: 10.h,
                      padding: EdgeInsets.symmetric(horizontal: 13.sp),
                      decoration: BoxDecoration(
                          color: backgroundColor2,
                          borderRadius: BorderRadius.circular(12.sp)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Warehouse',
                            style: primaryTextStyle.copyWith(
                              fontSize: 8.sp,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: warehouseController.text,
                                  elevation: 16,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 0.sp,
                                  ),
                                  style: primaryTextStyle.copyWith(
                                      fontSize: 10.sp),
                                  underline: Container(
                                    height: 0,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? newValue) {
                                    // setState(() {
                                    //   houseCode = newValue!;
                                    // });
                                    // handleSearch();
                                  },
                                  items: warehouse
                                      .map<DropdownMenuItem<String>>((value) {
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget tanggalInput() {
      return Container(
        margin: EdgeInsets.only(top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 13.sp),
              decoration: BoxDecoration(
                  color: backgroundColor2,
                  borderRadius: BorderRadius.circular(12.sp)),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: DateTimeField(
                        controller: tanggalController,
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: InputDecoration(
                          hintText: 'Enter Date',
                          hintStyle: primaryTextStyle.copyWith(
                            fontSize: 11.sp,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                // tanggalController.text = "";
                                dateArrived = "";
                              });
                              handleSearch();
                            },
                            icon: const Icon(
                              Icons.clear,
                            ),
                          ),
                        ),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        onChanged: (text) {
                          setState(() {
                            dateArrived = DateFormat("yyyy-MM-dd")
                                .format(text!)
                                .toString();
                          });

                          handleSearch();
                        },
                        style: primaryTextStyle.copyWith(fontSize: 10.sp),
                      ),
                    ),
                    SizedBox(
                      width: 5.sp,
                    ),
                    Icon(
                      Icons.date_range,
                      size: 17.sp,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget categories() {
      return Container(
        margin: EdgeInsets.only(
          top: 15.sp,
          left: 12.sp,
          right: 12.sp,
          bottom: 5.sp,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                  sts = "AR";
                  idx = 0;
                });
                handleSearch();
                setState(() {
                  isLoading = false;
                });
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
                  "List Put Away",
                  style: primaryTextStyle.copyWith(
                      fontSize: 11.sp, fontWeight: medium),
                ),
              ),
            ),
            SizedBox(
              width: 10.sp,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                  sts = "PUT";
                  idx = 1;
                });
                handleSearch();
                setState(() {
                  isLoading = false;
                });
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
                  "Success Put Away",
                  style: primaryTextStyle.copyWith(
                      fontSize: 11.sp, fontWeight: medium),
                ),
              ),
            ),
          ]),
        ),
      );
    }

    Widget listData() {
      return Container(
          margin: EdgeInsets.only(
            top: 10.sp,
          ),
          child: deliverydata.isEmpty
              ? dataNotfound()
              : Column(
                  children: deliverydata
                      .map(
                        (data) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PutAwayDetail(
                                  data,
                                  '',
                                  reload,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.tenatName,
                                            style: primaryTextStyle.copyWith(
                                              fontSize: 11.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          Text(
                                            'No DO : ${data.doSupplier}',
                                            style: primaryTextStyle.copyWith(
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 5.sp,
                                          right: 5.sp,
                                          bottom: 15.sp,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              data.dateArrived == null
                                                  ? ''
                                                  : data.dateArrived
                                                      .substring(0, 10),
                                              style: primaryTextStyle.copyWith(
                                                fontSize: 9.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15.sp,
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
                ));
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
          appBar: header(),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 19.sp),
              child: ListView(
                children: [
                  categories(),
                  Container(
                      padding: EdgeInsets.only(
                        right: 6.sp,
                        left: 6.sp,
                        top: 10.sp,
                      ),
                      child: Divider(
                        color: Colors.black,
                        height: 10.sp,
                      )),
                  searchInput(),
                  tanggalInput(),
                  selectInput(),
                  isLoading == true ? loading() : listData(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
