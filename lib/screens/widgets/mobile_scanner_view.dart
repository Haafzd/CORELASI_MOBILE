import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerView extends StatefulWidget {
  final Function(String) onDetect;

  const MobileScannerView({super.key, required this.onDetect});

  @override
  State<MobileScannerView> createState() => _MobileScannerViewState();
}

class _MobileScannerViewState extends State<MobileScannerView> {
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      fit: BoxFit.cover, 
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          if (barcode.rawValue != null) {
            widget.onDetect(barcode.rawValue!);
            break; 
          }
        }
      },
    );
  }
}
