
import 'package:flutter/material.dart';
import '../color_utils.dart';
import '../reusable_widgets/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sign UP',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor('CB2B93'),
            hexStringToColor('9546C4'),
            hexStringToColor('5E61F4'),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              ReusableTextField('Enter UserName', Icons.person_outline, false,
                  _userNameController),
              const SizedBox(
                height: 30,
              ),
              ReusableTextField('Enter Email Id', Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 30,
              ),
              ReusableTextField('Enter Password', Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 30,
              ),

            ],
          ),
        )),
      ),
    );
  }
}
