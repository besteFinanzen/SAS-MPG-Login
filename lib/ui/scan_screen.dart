import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sas_login_app/ui/templates.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  bool _isLogin = true;

  StreamSubscription<Object?>? _subscription;

  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));

  final MobileScannerController _controller = MobileScannerController(
    autoStart: false,
    torchEnabled: true,
    useNewCameraSelector: true,
    detectionTimeoutMs: 1000,
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!_controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
      // Restart the scanner when the app is resumed.
      // Don't forget to resume listening to the barcode events.
        _subscription = _controller.barcodes.listen(_handleBarcode);

        unawaited(_controller.start());
      case AppLifecycleState.inactive:
      // Stop the scanner when the app is paused.
      // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(_controller.stop());
    }
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = _controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(_controller.start());
  }

  void _handleBarcode(Object? barcode) {
    if (barcode is BarcodeCapture) {
      for (final barcode in barcode.barcodes) {
        if (barcode.format != BarcodeFormat.qrCode) {
          continue;
        } else if (barcode.rawValue == null) {
          continue;
        }
        final intCode = int.tryParse(barcode.rawValue!);
        print(intCode);
        try {
          //TODO: Add your code here
        } catch (e) {
          if (!context.mounted) return;
          //Show snack bar with error message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Fehler beim Lesen des QR-Codes: $e'),
            backgroundColor: CupertinoColors.systemRed,
          ));
          return;
        }
        _confettiController.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainFrame(
      headline: Text('Scan QR code um ein ${_isLogin ? 'Logout' : 'Login'} durchzuführen'),
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
                  padding: const EdgeInsets.all(20.0),
                  child: MobileScanner(controller: _controller),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}