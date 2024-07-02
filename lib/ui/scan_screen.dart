import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_login_app/ui/templates.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/screens/io_device.dart';

import '../backend/init.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isLogin = true;

  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));

  void _showError(final String text) {
    showCustomErrorDialog(
        context,
        "Error",
        "okay",
        text
    );
  }

  void _showStudent(Student student) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${student.name} aus der ${student.className} wurde ${(_isLogin) ? "eingeloggt" : "ausgeloggt"}"),
      )
    );
  }

  void _handleBarcode(String text) {
    final intCode = int.tryParse(text);
    if (intCode == null) {
      _showError("Der gescannte QR-Code ist keine Zahl: $text");
      return;
    }
    final Student? student = onCode(intCode, _isLogin? "in" : "out");
    if (student != null) {
      _showStudent(student);
      _confettiController.play();
    } else {
      _showError("Der gescannte QR-Code gehört keinem gespeicherten Schüler");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainFrame(
      headline: Text(_isLogin ? 'Login' : 'Logout'),
      backgroundColor: _isLogin ? CupertinoColors.systemGreen : CupertinoColors.systemRed,
      child: Stack(
        children: [
          IgnorePointer(
            child: ConfettiWidget(
              blastDirectionality: BlastDirectionality.explosive,
              confettiController: _confettiController,
              numberOfParticles: 100,
              shouldLoop: false,
              colors: (_isLogin) ? [
                Colors.green,
                Colors.red,
                Colors.yellow,
                Colors.blue,
              ] : [
                Colors.orange,
                Colors.purple,
                Colors.pink,
                Colors.teal,
              ]
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(MediaQuery.of(context).size.width / 20), // (40, 40, 40, 40)
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: _isLogin ? CupertinoColors.systemRed : CupertinoColors.systemGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Center(
                          child: Text(
                            _isLogin ? 'Zum Logout wechseln' : 'Zum Login wechseln',
                            style: const TextStyle(color: CupertinoColors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: QRCodeScanner(
                    key: UniqueKey(),
                    "hi there",
                    _handleBarcode,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QRCodeScanner extends StatefulWidget {
  final String cancelButtonText;
  final dynamic Function(String) onScanned;

  const QRCodeScanner(this.cancelButtonText, this.onScanned, {super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final String lineColor = '#ff6666';

  @override
  Widget build(BuildContext context) {
    return BarcodeScanner(
      lineColor: lineColor,
      cancelButtonText: widget.cancelButtonText,
      isShowFlashIcon: false,
      scanType: ScanType.qr,
      onScanned: widget.onScanned,
    );
  }
}