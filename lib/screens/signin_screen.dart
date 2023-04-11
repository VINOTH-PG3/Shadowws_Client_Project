import 'dart:convert';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../dashboard.dart';
import '../reusable_widgets/reusable_widget.dart';


class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  Future<void> login() async {
    final userName = userNameController.text;
    final password = passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      // show error message if either field is empty
      showAlertDialog(
          context, 'Error', 'Mandatory Fields are Empty');
      return;
    }

    setState(() {
      isLoading = true;
    });

    var response = await http.post(
      Uri.parse('https://agrarian-tooth.000webhostapp.com/cli_login.php'),
       //Uri.parse('http://192.168.0.76/d_shadowws_client_5/cli_login.php'),
        body: {
          'u_name': userName,
          'password': password,
        });

    var data = jsonDecode(response.body);
    if (data.containsKey('error')) {
      // show error message if login was unsuccessful
      showAlertDialog(context, 'Error', data['error']);
    } else {
      // save user_id to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', data['user_id']);
      await prefs.setString('client_name', data['client_name']);
      await prefs.setString('client_email', data['client_email']);
      await prefs.setString('client_mobile', data['client_mobile']);

      // navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
      if (userName == "") return;

      var appSignatureID = await SmsAutoFill().getAppSignature;
      Map sendOtpData = {
        "mobile_number": userName,
        "app_signature_id": appSignatureID
      };
    }

    setState(() {
      isLoading = false;
    });
  }
  /*Future<void> login() async {
    final userName = userNameController.text;
    final password = passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      // show error message if either field is empty
      showAlertDialog(
          context, 'Error', 'Mandatory Fields are Empty');
      return;
    }

    setState(() {
      isLoading = true;
    });

    var response = await http.post(
        Uri.parse('https://agrarian-tooth.000webhostapp.com/cli_login.php'),
        body: {
          'u_name': userName,
          'password': password,
        });

    var data = jsonDecode(response.body);
    if (data.containsKey('error')) {
      // show error message if login was unsuccessful
      showAlertDialog(context, 'Error', data['error']);
    } else {
      // save user_id to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', data['user_id']);
      await prefs.setString('client_name', data['client_name']);
      await prefs.setString('client_email', data['client_email']);

      // generate and send OTP to user's mobile number
      var otp = generateOTP();
      sendOTP(data['mobile'], otp);

      // navigate to OTP verification page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OTPVerification(otp)),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

// function to generate a 6-digit OTP
  String generateOTP() {
    var rand = Random();
    return rand.nextInt(999999).toString().padLeft(6, '0');
  }

// function to send OTP to user's mobile number
  void sendOTP(String mobile, String otp) {
    // add your code here to send OTP to user's mobile number
    // you can use any SMS API service for this purpose
  }
*/
  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(message, style: TextStyle(color: Colors.black, fontSize: 16)),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        backgroundColor: Colors.yellow.shade100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Logowidget('images/logo.gif'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'SHADOWWS',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),  const SizedBox(
                      height: 25,
                    ),
                    ReusableTextField('Username', Icons.person_outline, false,
                        userNameController),
                    const SizedBox(
                      height: 15,
                    ),
                    ReusableTextField(
                      'Password',
                      Icons.lock_outline,
                      true,
                      passwordController,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        'LOG IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.grey.shade800;
                          }
                          return Colors.red.shade800;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(4),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Stack(
              children: [
                // Other widgets
                if (isLoading)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Center(
                                  child: Image.asset(
                                    'images/loading.gif', // Replace this with your own GIF image path
                                    width: 350,
                                    height: 400,

                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )
        ],
      ),
    );
  }
}
