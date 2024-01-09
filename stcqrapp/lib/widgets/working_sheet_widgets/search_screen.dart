// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:timbercop/Screens/qr_code_scan_screen.dart';
// import 'package:timbercop/configs/constants.dart';
// import 'package:timbercop/configs/custom_colors.dart';
// import 'package:timbercop/entities/user.dart';
// import 'package:timbercop/models/auth_model.dart';
// import 'package:timbercop/models/logs_model.dart';
// import 'package:timbercop/widgets/global_widgets/alert_box_widget.dart';
// import 'package:timbercop/widgets/global_widgets/button_widget.dart';
// import 'package:timbercop/widgets/global_widgets/label_widget.dart';
// import 'package:timbercop/widgets/global_widgets/text_field_widget.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final _idController = TextEditingController();
//   List<bool> isSelected = [true, false];
//   List<int> qrIds = [];
//
//   SearchMethod? _selectSearchMethod;
//
//   void onPressed() async {
//     var authModel = Provider.of<AuthModel>(context, listen: false);
//     var logsModel = Provider.of<LogsModel>(context, listen: false);
//
//     // get token
//     final String token = authModel.token ?? '';
//
//     // get logged in user
//     User user = authModel.user!;
//
//     String inputList = _idController.text.replaceAll(' ', '');
//
//     _showErrorDialog(await logsModel.getLogsFromVisibleMaterialNo(
//         inputList, user.username, user.depotId, user.regionId, 1234, token));
//
//     // Provider.of<LogsModel>(context, listen: false).searchedLogsList.clear();
//     // final enteredLogIds = _idController.text.split(',');
//   }
//
//   // Error alert box template
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertBoxWidget(
//         title: 'Error',
//         content: Text(message),
//         buttonTitle: 'Okay',
//         onPressed: () => Navigator.pop(context),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: Constants.screenSize(context).height * 0.65,
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/images/Background.jpg'),
//           fit: BoxFit.cover,
//         ),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             ToggleButtons(
//               isSelected: isSelected,
//               onPressed: (int index) {
//                 // Update the state when a button is pressed
//                 setState(() {
//                   // Toggle the selected state for the clicked index
//                   isSelected[index] = !isSelected[index];
//
//                   // Unselect the other button
//                   isSelected[(index + 1) % 2] = !isSelected[index];
//                 });
//               },
//               selectedColor:
//                   Colors.black, // Set the color for the selected item
//               color: Colors.grey,
//               borderColor: Colors.black,
//               selectedBorderColor: Colors.black,
//               children: const [
//                 Icon(Icons.numbers),
//                 Icon(Icons.qr_code_2),
//               ], // Set the color for the unselected item
//             ),
//             const SizedBox(height: 20),
//             isSelected[1] == false
//                 ? Column(
//                     children: [
//                       const LabelWidget(label: 'Visible Material Numbers'),
//                       TextFieldWidget(
//                         hintText: '11-2392BS,10-2291BS,',
//                         controller: _idController,
//                         keyboardType: TextInputType.text,
//                       ),
//                       const LabelWidget(
//                           label:
//                               '- Please enter visible material numbers separated by commas ( , )\n- Don\'t leave spaces'),
//                     ],
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // When a qr id is scanned
//                       // that scanned qr id will be displayed here
//                       Expanded(
//                         child: Container(
//                           height: 45,
//                           alignment: Alignment.center,
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(width: 1, color: Colors.black),
//                             color: Colors.transparent,
//                           ),
//                           child: Text('test qr'),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       // This button is used to
//                       // go to the qr_code_scan_screen
//                       ButtonWidget(
//                         width: Constants.screenSize(context).width * 1 / 4,
//                         height: 45,
//                         borderRadius: 10,
//                         backgroundColor: CustomColors.brownColor,
//                         onPressed: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 const QRCodeScanScreen(index: 0),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.qr_code_2,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 10),
//                             Text(
//                               'Scan QR',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall!
//                                   .copyWith(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//             const SizedBox(height: 20),
//             ButtonWidget(
//               width: double.infinity,
//               height: 45,
//               borderRadius: 10,
//               backgroundColor: CustomColors.greenColor,
//               onPressed: onPressed,
//               child: Text(
//                 'Search',
//                 style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   DropdownButtonFormField<SearchMethod> _searchMethodDropdownWidget() {
//     return DropdownButtonFormField<SearchMethod>(
//       hint: Text('Click to select search method',
//           style: Theme.of(context).textTheme.bodyMedium),
//       isExpanded: true,
//       decoration: InputDecoration(
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(width: 1, color: Colors.black),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(width: 1, color: Colors.brown),
//         ),
//       ),
//       value: _selectSearchMethod,
//       items: SearchMethod.values.map((deport) {
//         return DropdownMenuItem<SearchMethod>(
//           value: deport,
//           child: Text(
//             deport.name,
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//         );
//       }).toList(),
//       selectedItemBuilder: (BuildContext context) => SearchMethod.values
//           .map(
//             (deport) => Text(
//               deport.name,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           )
//           .toList(),
//       onChanged: (value) {
//         if (value == null) {
//           return;
//         }
//         setState(() {
//           _selectSearchMethod = value;
//         });
//       },
//     );
//   }
// }
