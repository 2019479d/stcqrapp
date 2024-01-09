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

class LogsFromQrIdScreen extends StatefulWidget {
  const LogsFromQrIdScreen({super.key});

  @override
  State<LogsFromQrIdScreen> createState() => _LogsFromQrIdScreenState();
}

class _LogsFromQrIdScreenState extends State<LogsFromQrIdScreen> {
  List<String> qrIds = [];
  String qrIdListString = '';

  void onPressed() async {
    var authModel = Provider.of<AuthModel>(context, listen: false);
    var logsModel = Provider.of<LogsModel>(context, listen: false);

    // get token
    final String token = authModel.token ?? '';

    // get logged in user
    User user = authModel.user!;

    if (logsModel.qrIdListString != '') {
      _showErrorDialog(await logsModel.getLogsFromQrId(
          user.username, user.depotId, user.regionId, token));

      setState(() {
        logsModel.qrCodes = [];
        logsModel.qrIdListString = '';
      });
    } else {
      _showErrorDialog('Scan QR IDs to search!');
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

  List<TextEditingController> _volumeControllers = [];
  List<TextEditingController> _midGirthControllers = [];
  List<TextEditingController> _transCostControllers = [];
  List<TextEditingController> _salesPriceControllers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<LogsModel>(context, listen: true).logsList;
    Provider.of<LogsModel>(context, listen: true).qrIdListString;

    // Initialize controllers and clear the lists
    _volumeControllers = List.generate(
        Provider.of<LogsModel>(context, listen: true).logsList.length,
        (index) => TextEditingController());
    _midGirthControllers = List.generate(
        Provider.of<LogsModel>(context, listen: true).logsList.length,
        (index) => TextEditingController());
    _transCostControllers = List.generate(
        Provider.of<LogsModel>(context, listen: true).logsList.length,
        (index) => TextEditingController());
    _salesPriceControllers = List.generate(
        Provider.of<LogsModel>(context, listen: true).logsList.length,
        (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LogsModel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Working Sheet'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // clear log list when going back
              setState(() {
                model.logs = [];
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
        ),
        body: Container(
          color: CustomColors.hazelColor,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: model.logsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: CustomColors.oliveSkinColor,
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          buildInfoRow('Visible Material Number',
                              model.logsList[index].visibleMaterialNo),
                          buildInfoRow('QR ID', model.logsList[index].qrId),
                          buildInfoRow(
                              'Grade', model.logsList[index].grading ?? ""),
                          buildInfoRow('Timber Class',
                              model.logsList[index].timberClass),
                          buildInfoRow(
                              'Species', model.logsList[index].species),
                          buildInfoRow(
                              'Region', model.logsList[index].regionText),
                          buildInfoRow(
                              'Depot', model.logsList[index].depotText),
                          buildInfoRow('User', model.logsList[index].username),
                          buildInfoRow('Length',
                              model.logsList[index].length.toString()),
                          buildInfoRow(
                              'Girth', model.logsList[index].girth.toString()),
                          buildInfoRow('Original Volume',
                              model.logsList[index].volume.toString()),
                          buildEditableInfoRow(
                              'Current Volume', _volumeControllers[index]),
                          buildEditableInfoRow(
                              'Mid Grith Price', _midGirthControllers[index]),
                          buildEditableInfoRow(
                              'Transport Cost', _transCostControllers[index]),
                          buildEditableInfoRow(
                              'Sales price', _salesPriceControllers[index]),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 2,
                indent: 5,
                endIndent: 5,
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          // This section is to
                          // scan a new QR code
                          const LabelWidget(label: 'QR Code'),
                          Container(
                            width: double.infinity,
                            height: 45,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.black),
                              color: Colors.transparent,
                            ),
                            child: Text(model.qrIdListString
                                .replaceAll(RegExp(r',$'), '')),
                          ),
                          const SizedBox(height: 20),
                          // This is a button panel
                          // to clear scanned qr and
                          // a button to scan qr
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonWidget(
                                width: 100,
                                height: 45,
                                borderRadius: 10,
                                backgroundColor: CustomColors.greenColor,
                                onPressed: () {
                                  setState(() {
                                    model.qrCodes = [];
                                    model.qrIdListString = '';
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
                                onPressed: () async {
                                  setState(() {
                                    model.qrCode = '';
                                  });
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const QRCodeScanScreen(
                                              screen: LogsFromQrIdScreen()),
                                    ),
                                  );

                                  if (!model.qrCodes.contains(model.qrCode)) {
                                    setState(() {
                                      model.qrCodes.add(model.qrCode);
                                      model.qrIdListString +=
                                          '${model.qrCodes.last},';
                                    });
                                  }
                                },
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
                        ],
                      ),
                      const SizedBox(height: 20),
                      ButtonWidget(
                        width: 200,
                        height: 45,
                        borderRadius: 10,
                        onPressed: onPressed,
                        child: const Text(
                          'Search',
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget buildEditableInfoRow(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 120,
            height: 35,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------

// void onPressed() {
//   Provider.of<LogsModel>(context, listen: false).searchedLogsList.clear();
//   final enteredLogIds = _idController.text.split(',');
//   Provider.of<LogsModel>(context, listen: false)
//       .fetchLogByPk(enteredLogIds)
//       .then((logs) {
//     Provider.of<LogsModel>(context, listen: false).searchedLogsList.addAll(logs);
//     for (int i = 0; i < logs.length; i++) {
//       _volumeControllers[i].text = logs[i].volume.toString();
//       _midGirthControllers[i].text = logs[i].midGrithPrice.toString();
//       _transCostControllers[i].text = logs[i].transCost.toString();
//       _salesPriceControllers[i].text = logs[i].salesPrice.toString();
//     }
//   });
//   Navigator.pop(context);
// }
