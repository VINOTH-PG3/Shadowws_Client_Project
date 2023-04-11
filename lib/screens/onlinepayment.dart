import 'package:flutter/material.dart';

class OnlinePayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Online Payment'),
      ),
      body: Center(
        child: Container(
          child: Text('Online Payment Page'),
        ),
      ),
    );
  }
}