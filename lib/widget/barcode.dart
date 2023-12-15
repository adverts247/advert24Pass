import 'package:adverts247Pass/themes.dart';
import 'package:flutter/material.dart';
// ignore_for_file: always_specify_types

import 'package:barcode_widget/barcode_widget.dart';

class BarcodeDisplayWidget extends StatefulWidget {
  BarcodeDisplayWidget({super.key, this.url});
  String? url;
  @override
  State<BarcodeDisplayWidget> createState() => _BarcodeDisplayWidgetState();
}

class _BarcodeDisplayWidgetState extends State<BarcodeDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scan to download',
                  style: TextStyles().blackTextStyle400().copyWith(
                        fontSize: 16,
                      ),
                ),
                const SizedBox(
                  height: 30,
                ),
                BarcodeWidget(
                  barcode: Barcode.qrCode(
                    errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                  ),
                  data: widget.url.toString(),
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
