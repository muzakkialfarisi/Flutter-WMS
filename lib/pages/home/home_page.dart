import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: EdgeInsets.only(
          top: 15.sp,
        ),
        child: Center(
          child: Text(
            "Warehouse Management System",
            style: primaryTextStyle.copyWith(
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }

    Widget menuIncoming() {
      return GridView.count(
        padding: EdgeInsets.only(
          top: 2.sp,
          right: 10.sp,
          left: 10.sp,
          bottom: 5.sp,
        ),
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () async {
              Navigator.pushNamed(context, '/delivery-order');
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Image.asset(
                          'assets/delivery_order.png',
                          width: 100.sp,
                          height: 40.sp,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        height: 4.sp,
                      ),
                      Text(
                        "Delivery Order",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              // Navigator.pushNamed(context, '/delivery-order');
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                color: Colors.brown.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Image.asset(
                          'assets/quality_check.png',
                          width: 100.sp,
                          height: 40.sp,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        height: 4.sp,
                      ),
                      Text(
                        "Quality Check",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              //Navigator.pushNamed(context, '/delivery-order');
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                color: Colors.brown.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Image.asset(
                          'assets/stagging_area.png',
                          width: 100.sp,
                          height: 40.sp,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        height: 4.sp,
                      ),
                      Text(
                        "Put Staging Area",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget menuInventory() {
      return GridView.count(
        padding: EdgeInsets.only(
          top: 2.sp,
          right: 10.sp,
          left: 10.sp,
          bottom: 5.sp,
        ),
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () async {
              Navigator.pushNamed(context, '/put-away');
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 6.sp,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Image.asset(
                          'assets/put_away.png',
                          width: 100.sp,
                          height: 40.sp,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        height: 6.sp,
                      ),
                      Text(
                        "Put Away",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              // Navigator.pushNamed(context, '/delivery-order');
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                color: Colors.brown.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Icon(
                          Icons.location_on,
                          size: 35.sp,
                          color: Colors.blue,
                        ),
                        // child: Image.asset(
                        //   'assets/transfer_location.png',
                        //   width: 100.sp,
                        //   height: 40.sp,
                        //   fit: BoxFit.fitHeight,
                        // ),
                      ),
                      SizedBox(
                        height: 4.sp,
                      ),
                      Text(
                        "Transfer",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                      Text(
                        "Location",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              // Navigator.pushNamed(context, '/delivery-order');
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                color: Colors.brown.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Image.asset(
                          'assets/stock_opname.png',
                          width: 100.sp,
                          height: 40.sp,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        height: 4.sp,
                      ),
                      Text(
                        "Stock Opname",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget menuOutgoing() {
      return GridView.count(
        padding: EdgeInsets.only(
          top: 2.sp,
          right: 10.sp,
          left: 10.sp,
          bottom: 5.sp,
        ),
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () async {
              Navigator.pushNamed(context, '/pick');
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4.sp,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Icon(
                          Icons.business_center_rounded,
                          size: 35.sp,
                          color: Colors.blue,
                        ),
                        // child: Image.asset(
                        //   'assets/pick.png',
                        //   width: 100.sp,
                        //   height: 40.sp,
                        //   fit: BoxFit.fitHeight,
                        // ),
                      ),
                      SizedBox(
                        height: 4.sp,
                      ),
                      Text(
                        "PICK",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            // onTap: () async {
            //   Navigator.pushNamed(context, '/put-away');
            // },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                color: Colors.brown.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4.sp,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Icon(
                          Icons.move_to_inbox,
                          size: 35.sp,
                          color: Colors.blue,
                        ),
                        // child: Image.asset(
                        //   'assets/repacking.png',
                        //   width: 100.sp,
                        //   height: 40.sp,
                        //   fit: BoxFit.fitHeight,
                        // ),
                      ),
                      SizedBox(
                        height: 4.sp,
                      ),
                      Text(
                        "Repacking",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              // Navigator.pushNamed(context, '/delivery-order');
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                color: Colors.brown.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Image.asset(
                          'assets/handover_to_courier.png',
                          width: 100.sp,
                          height: 40.sp,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        height: 4.sp,
                      ),
                      Text(
                        "Handover To",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                      Text(
                        "Courier ",
                        style: primaryTextStyle.copyWith(fontSize: 8.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget menuUtama() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 18.sp,
            ),
            child: Text(
              "Incoming",
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
              ),
            ),
          ),
          menuIncoming(),
          Container(
            margin: EdgeInsets.only(
              left: 18.sp,
            ),
            child: Text(
              "Inventory",
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
              ),
            ),
          ),
          menuInventory(),
          Container(
            margin: EdgeInsets.only(
              left: 18.sp,
            ),
            child: Text(
              "Outgoing",
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
              ),
            ),
          ),
          menuOutgoing(),
        ],
      );
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor4,
              backgroundColor1,
            ],
          ),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                header(),
                Container(
                  margin: EdgeInsets.only(top: 20.sp, bottom: 30.sp),
                  width: 100.sp,
                  height: 100.sp,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/logo.png"),
                    ),
                  ),
                ),
              ],
            ),
            menuUtama(),
          ],
        ),
      );
    });
  }
}
