import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wms_deal_ncs/model/delivery_order/delivery_order_model.dart';
import 'package:wms_deal_ncs/provider/delivery_order/cek_product_arrival_provider.dart';
import 'package:wms_deal_ncs/theme.dart';

class PrintLabelOrder extends StatefulWidget {
  final DeliveryOrderModel detailDO;
  final List produk;
  final String token;
  const PrintLabelOrder(this.detailDO, this.produk, this.token, {Key? key})
      : super(key: key);

  @override
  State<PrintLabelOrder> createState() => _PrintLabelOrderState();
}

class _PrintLabelOrderState extends State<PrintLabelOrder> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  bool erPrint = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevices();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void printIku(i, e) async {
      printer.printCustom('IKU', 0, 1);
      printer.printQRcode(i, 200, 200, 1);
      printer.printCustom(e.productName, 0, 1);
      printer.printCustom(i, 0, 1);
      printer.printNewLine();
      printer.printLeftRight("SKU", e.sku.toString(), 0);
      printer.printLeftRight(
          "Warehouse", widget.detailDO.houseName.toString(), 0);
      printer.printLeftRight("Zona", e.zona.toString(), 0);
      printer.printLeftRight("Tanggal Kirim",
          widget.detailDO.dateDelivered.toString().replaceAll('T', ' '), 0);
    }

    void productprint(e) async {
      if (e.productLevel == 'SKU') {
        printer.printCustom('SKU', 0, 1);
        printer.printQRcode(e.doProductCode, 200, 200, 1);
        printer.printCustom(e.productName, 0, 1);
        printer.printLeftRight("SKU", e.sku.toString(), 0);
        printer.printLeftRight("DoNumber", widget.detailDO.noDo.toString(), 0);
        printer.printLeftRight(
            "Tenat", widget.detailDO.tenatName.toString(), 0);
        printer.printLeftRight(
            "Warehouse", widget.detailDO.houseName.toString(), 0);
        printer.printLeftRight("Zona", e.zona.toString(), 0);
        printer.printLeftRight("Size", e.size.toString(), 0);
        printer.printLeftRight("Kategori", e.kategori.toString(), 0);
        printer.printLeftRight("Tanggal Kirim",
            widget.detailDO.dateDelivered.toString().replaceAll('T', ' '), 0);
      } else {
        List iku = await CekProductArrivalProvider().getiku(
          apikey: "",
          dOProductId: e.doProductId.toString(),
          token: widget.token,
        );
        iku.map((i) => printIku(i, e)).toList();
      }
      printer.printNewLine();
      printer.printNewLine();
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Print Label'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<BluetoothDevice>(
                  value: selectedDevice,
                  onChanged: (device) {
                    setState(() {
                      selectedDevice = device;
                    });
                  },
                  hint: const Text("selected Thermal printer"),
                  items: devices
                      .map((e) => DropdownMenuItem(
                            child: Text(e.name!),
                            value: e,
                          ))
                      .toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedDevice == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 500),
                          backgroundColor: secondaryColor,
                          content: const Text(
                            "Printer Not Selected",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      printer.connect(selectedDevice!);
                    }
                  },
                  child: const Text("Connect"),
                ),
                ElevatedButton(
                  onPressed: () {
                    printer.disconnect();
                  },
                  child: const Text("Disconnect"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (JwtDecoder.isExpired(widget.token)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(milliseconds: 500),
                          backgroundColor: secondaryColor,
                          content: const Text(
                            "Waktu Session Habis Silahkan Login Kembali",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      final SharedPreferences share =
                          await SharedPreferences.getInstance();
                      share.clear();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    } else {
                      if ((await printer.isConnected)!) {
                        widget.produk.map((e) => productprint(e)).toList();
                        // printer.printQRcode('22222', 200, 200, 1);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(milliseconds: 500),
                            backgroundColor: secondaryColor,
                            content: const Text(
                              'Printer No Connect',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Print"),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
