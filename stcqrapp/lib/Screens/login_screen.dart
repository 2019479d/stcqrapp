import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stcqrapp/Screens/home_screen.dart';
import 'package:stcqrapp/configs/custom_colors.dart';
import 'package:stcqrapp/models/auth_model.dart';
import 'package:stcqrapp/widgets/global_widgets/alert_box_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/button_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/label_widget.dart';
import 'package:stcqrapp/widgets/global_widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isClicked = false;

  void _forgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertBoxWidget(
        title: 'Forgot Password?',
        content: Text.rich(
          TextSpan(
            text: 'Contact IT Department\n',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  height: 1.5,
                ),
            children: [
              TextSpan(
                text: 'Tel: 0112223344',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      height: 1.5,
                    ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        buttonTitle: 'Okay',
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _signUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertBoxWidget(
        title: 'Don\'t have an account?',
        content: Text.rich(
          TextSpan(
            text: 'Contact IT Department\n',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  height: 1.5,
                ),
            children: [
              TextSpan(
                text: 'Tel: 0112223344',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      height: 1.5,
                    ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        buttonTitle: 'Okay',
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void _loginUser() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Check if any of the fields is empty
    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill in all the fields.');
      return;
    }

    // Call the login user function from AuthModel
    Provider.of<AuthModel>(context, listen: false)
        .loginUser(
      username,
      password,
    )
        .then((_) {
      // Get token
      final String token =
          Provider.of<AuthModel>(context, listen: false).token ?? '';

      // If token is not empty,
      // Get user level
      if (token.isNotEmpty) {
        int userLevel =
            Provider.of<AuthModel>(context, listen: false).user?.userLevel ?? 0;

        // If user level is 5 or 6,
        // Don't give access to any function
        if (userLevel > 4) {
          _showErrorDialog('You have no access to this app!');
        } else {
          // For the users with user levels: 1, 2, 3, 4
          // Navigate to home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (currentContext) => const HomeScreen(),
            ),
          );
        }
      } else {
        // If username or password is wrong
        // Display alert box
        _showErrorDialog('Login credentials incorrect!');
      }
    });
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
  void initState() {
    super.initState();
    _usernameController.text = '';
    _passwordController.text = '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.hazelColor,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.brownColor,
                  ),
                ),
                Text(
                  'Enter your login credentials below!',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black.withOpacity(0.75),
                      ),
                ),
                const SizedBox(height: 40),
                const LabelWidget(label: 'Username'),
                TextFieldWidget(
                  hintText: 'johndoe',
                  controller: _usernameController,
                  suffixWidget: Icon(
                    Icons.person_outline,
                    size: 18,
                    color: Colors.black.withOpacity(0.65),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                const LabelWidget(label: 'Password'),
                TextFieldWidget(
                  hintText: 'Password@123',
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: !isClicked,
                  suffixWidget: GestureDetector(
                    onTap: () {
                      setState(() {
                        isClicked = !isClicked;
                      });
                    },
                    child: Icon(
                      isClicked
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: Colors.black.withOpacity(0.65),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _forgotPasswordDialog(),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                  width: double.infinity,
                  height: 45,
                  borderRadius: 10,
                  onPressed: () async {
                    // Internet connection check
                    final connectivityResult =
                        await (Connectivity().checkConnectivity());

                    // Check if the network connectivi
                    if (connectivityResult == ConnectivityResult.none) {
                      _showErrorDialog('No Network Connection. Try Again!');
                    } else {
                      _loginUser();
                    }
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black.withOpacity(0.75),
                          ),
                    ),
                    TextButton(
                      onPressed: () => _signUpDialog(),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
