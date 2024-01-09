import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stcqrapp/Screens/add_qr_screen.dart';
import 'package:stcqrapp/Screens/login_screen.dart';
import 'package:stcqrapp/Screens/update_qr_details_screen.dart';
import 'package:stcqrapp/Screens/working_sheet_screens/logs_from_qr_id_screen.dart';
import 'package:stcqrapp/Screens/working_sheet_screens/logs_from_vis_mat_no_screen.dart';
import 'package:stcqrapp/configs/custom_colors.dart';
import 'package:stcqrapp/models/auth_model.dart';
import 'package:stcqrapp/models/logs_model.dart';
import 'package:stcqrapp/widgets/global_widgets/alert_box_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    int userLevel =
        Provider.of<AuthModel>(context, listen: false).user?.userLevel ?? 0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
        ),
        body: Container(
          color: CustomColors.hazelColor,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                width: 300,
                height: 65,
                borderRadius: 10,
                onPressed: () {
                  Provider.of<LogsModel>(context, listen: false).qrCode = '';
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddQRScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Add QR',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ButtonWidget(
                width: 300,
                height: 65,
                borderRadius: 10,
                onPressed: userLevel <= 3
                    ? () {
                        Provider.of<LogsModel>(context, listen: false).qrCode =
                            '';
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpdateQRDetailsScreen(),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  'Update QR',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  const Text(
                    'Working Sheet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ButtonWidget(
                    width: 300,
                    height: 65,
                    borderRadius: 10,
                    onPressed: userLevel <= 3
                        ? () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LogsFromVisMatNoScreen(),
                              ),
                            )
                        : null,
                    child: const Text(
                      'Visible Material Number',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ButtonWidget(
                    width: 300,
                    height: 65,
                    borderRadius: 10,
                    onPressed: userLevel <= 3
                        ? () {
                            Provider.of<LogsModel>(context, listen: false)
                                .qrCode = '';

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LogsFromQrIdScreen(),
                              ),
                            );
                          }
                        : null,
                    child: const Text(
                      'QR ID',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: _floatingActionButton(
          icon: const Icon(
            Icons.logout,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertBoxWidget(
                title: 'Are you sure?',
                textButton2: TextButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  ),
                ),
                buttonTitle: 'No',
                onPressed: () => Navigator.pop(context),
              ),
            );
          },
        ),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(
      {required Icon icon, required VoidCallback? onPressed}) {
    return FloatingActionButton(
      isExtended: true,
      backgroundColor: CustomColors.brownColor,
      foregroundColor: Colors.white,
      onPressed: onPressed,
      child: icon,
    );
  }
}
