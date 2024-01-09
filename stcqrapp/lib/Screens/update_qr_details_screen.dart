import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stcqrapp/Screens/home_screen.dart';
import 'package:stcqrapp/Screens/qr_code_scan_screen.dart';
import 'package:stcqrapp/configs/custom_colors.dart';
import 'package:stcqrapp/entities/user.dart';
import 'package:stcqrapp/models/auth_model.dart';
import 'package:stcqrapp/models/logs_model.dart';
import 'package:stcqrapp/widgets/global_widgets/alert_box_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/button_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/label_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/text_field_widget.dart';

class UpdateQRDetailsScreen extends StatefulWidget {
  const UpdateQRDetailsScreen({super.key});

  @override
  State<UpdateQRDetailsScreen> createState() => _UpdateQRDetailsScreenState();
}

class _UpdateQRDetailsScreenState extends State<UpdateQRDetailsScreen> {
  final _idController = TextEditingController();
  final _reasonController = TextEditingController();

  void _onSubmit() async {
    try {
      var authModel = Provider.of<AuthModel>(context, listen: false);
      var logsModel = Provider.of<LogsModel>(context, listen: false);

      String visMatNo = _idController.text;
      String reason = _reasonController.text;

      // Internet connection check
      final connectivityResult = await (Connectivity().checkConnectivity());

      // Check if the QR ID is empty
      if (logsModel.qrCode != '') {
        // Check if the visible material number is empty
        if (visMatNo != '') {
          // Check if the network connectivity is available
          if (connectivityResult != ConnectivityResult.none) {
            // get token
            final String token = authModel.token ?? '';

            // get logged in user
            User user = authModel.user!;

            // Execute modifyQR function and,
            // Return response.body
            _showErrorDialog(await logsModel.modifyQr(visMatNo, user.username,
                user.depotId, user.regionId, token, reason));

            setState(() {
              visMatNo = '';
              reason = '';
              logsModel.qrCode = '';
            });
          } else {
            _showErrorDialog('No Network Connectivity. Try Again!');
          }
        } else {
          _showErrorDialog('Visible Material Number is empty!');
        }
      } else {
        _showErrorDialog('QR ID is empty!');
      }
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  // Error alert box template
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertBoxWidget(
        title: 'SERVER',
        content: Text(message),
        buttonTitle: 'Okay',
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LogsModel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Update QR'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            ),
          ),
        ),
        body: Container(
          color: CustomColors.hazelColor,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // This section is to
                  // scan a new QR code
                  const LabelWidget(label: 'QR Code'),
                  Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black),
                      color: Colors.transparent,
                    ),
                    child: Text(model.qrCode),
                  ),
                  const SizedBox(height: 20),
                  // This is a button panel
                  // to clear scanned qr and
                  // a button to scan qr
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonWidget(
                        width: 100,
                        height: 45,
                        borderRadius: 10,
                        backgroundColor: CustomColors.greenColor,
                        onPressed: () {
                          setState(() {
                            model.qrCode = '';
                          });
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // This button is used to
                      // go to the qr_code_scan_screen
                      ButtonWidget(
                        width: 100,
                        height: 45,
                        borderRadius: 10,
                        backgroundColor: CustomColors.brownColor,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QRCodeScanScreen(
                                screen: UpdateQRDetailsScreen()),
                          ),
                        ),
                        child: const Text(
                          'Scan QR',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // This section is used to
                  // enter visible material number
                  const LabelWidget(label: 'Visible Material Number'),
                  TextFieldWidget(
                    hintText: '01-1234AB',
                    controller: _idController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  const LabelWidget(label: 'Reason'),
                  TextFieldWidget(
                    hintText: 'Type the reason ...',
                    controller: _reasonController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    maxLength: 255,
                  ),
                  const SizedBox(height: 40),
                  ButtonWidget(
                    width: double.infinity,
                    height: 45,
                    borderRadius: 10,
                    onPressed: _onSubmit,
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
