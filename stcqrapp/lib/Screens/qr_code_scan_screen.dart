import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stcqrapp/configs/constants.dart';
import 'package:stcqrapp/configs/custom_colors.dart';
import 'package:stcqrapp/models/logs_model.dart';
import 'package:stcqrapp/widgets/global_widgets/button_widget.dart';

class QRCodeScanScreen extends StatefulWidget {
  final Widget screen;
  const QRCodeScanScreen({
    Key? key,
    required this.screen,
  }) : super(key: key);

  @override
  State<QRCodeScanScreen> createState() => _QRCodeScanScreenState();
}

class _QRCodeScanScreenState extends State<QRCodeScanScreen> {
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildQrView(context),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                    context); // Navigate back when the button is pressed
              },
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ButtonWidget(
                  width: 50,
                  height: 45,
                  borderRadius: 10,
                  boxShadow: false,
                  backgroundColor: CustomColors.brownColor,
                  onPressed: () {
                    _controller?.toggleFlash();
                  },
                  child: const Icon(
                    Icons.flash_on,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.black,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: Constants.screenSize(context).width * 0.75,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        var model = Provider.of<LogsModel>(context, listen: false);

        model.qrCode = scanData.code ?? '';

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget.screen,
          ),
        );
      }
    });
  }
}
