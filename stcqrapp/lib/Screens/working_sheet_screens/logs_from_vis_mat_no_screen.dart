import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stcqrapp/Screens/home_screen.dart';
import 'package:stcqrapp/configs/custom_colors.dart';
import 'package:stcqrapp/entities/user.dart';
import 'package:stcqrapp/models/auth_model.dart';
import 'package:stcqrapp/models/logs_model.dart';
import 'package:stcqrapp/widgets/global_widgets/alert_box_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/button_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/label_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/text_field_widget.dart';

class LogsFromVisMatNoScreen extends StatefulWidget {
  const LogsFromVisMatNoScreen({super.key});

  @override
  State<LogsFromVisMatNoScreen> createState() => _LogsFromVisMatNoScreenState();
}

class _LogsFromVisMatNoScreenState extends State<LogsFromVisMatNoScreen> {
  final _idController = TextEditingController();
  List<String> qrIds = [];

  void onPressed() async {
    var authModel = Provider.of<AuthModel>(context, listen: false);
    var logsModel = Provider.of<LogsModel>(context, listen: false);

    // get token
    final String token = authModel.token ?? '';

    // get logged in user
    User user = authModel.user!;

    String inputList = _idController.text.replaceAll(' ', '');

    if (_idController.text != '') {
      _showErrorDialog(await logsModel.getLogsFromVisibleMaterialNo(
          inputList, user.username, user.depotId, user.regionId, token));

      setState(() {
        _idController.text = '';
      });
    } else {
      _showErrorDialog('Enter Visible Material Numbers to search!');
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
                          const LabelWidget(label: 'Visible Material Numbers'),
                          TextFieldWidget(
                            hintText: '11-2392BS,10-2291BS,',
                            controller: _idController,
                            keyboardType: TextInputType.text,
                          ),
                          const LabelWidget(
                              label:
                                  'Please enter visible material numbers separated by commas ( , )\nDon\'t leave any spaces'),
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
