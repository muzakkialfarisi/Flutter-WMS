import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms_deal_ncs/pages/delivery%20order/delivery_order_page.dart';
import 'package:wms_deal_ncs/pages/home/main_page.dart';
import 'package:wms_deal_ncs/pages/login_page.dart';
import 'package:wms_deal_ncs/pages/pick/pick_page.dart';
import 'package:wms_deal_ncs/pages/profile/my_profile.dart';
import 'package:wms_deal_ncs/pages/put_away/put_away_page.dart';
import 'package:wms_deal_ncs/pages/receiving/receiving_page.dart';
import 'package:wms_deal_ncs/pages/update-Page.dart';
import 'package:wms_deal_ncs/provider/auth/login_provider.dart';
import 'package:wms_deal_ncs/provider/delivery_order/cek_product_arrival_provider.dart';
import 'package:wms_deal_ncs/provider/delivery_order/delivery_order_provider.dart';
import 'package:wms_deal_ncs/provider/delivery_order/product_detail_provider.dart';
import 'package:wms_deal_ncs/provider/pick/pick_provider.dart';
import 'package:wms_deal_ncs/provider/put_away/cek_put_away_provider.dart';
import 'package:wms_deal_ncs/provider/put_away/product_put_away_provider.dart';
import 'package:wms_deal_ncs/provider/put_away/put_away_provider.dart';
import 'package:wms_deal_ncs/provider/tenant_provider.dart';
import 'package:wms_deal_ncs/provider/warehouse_provider.dart';

import 'pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DeliveryOrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TenantProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WarehouseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductDetailProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CekProductArrivalProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PutAwayProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductPutAwayProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CekPutAwayProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PickProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const MainPage(),
          '/receiving': (context) => const ReceivingPage(),
          '/delivery-order': (context) => const DeliveryOrderPage(),
          '/put-away': (context) => const PutAwayPage(),
          '/pick': (context) => const PickPage(),
          '/update-Page': (context) => const UpdateAppPage(),
          '/my-Profile': (context) => const MyProfilePage(),
        },
      ),
    );
  }
}
