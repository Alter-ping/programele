import 'package:flutter/material.dart';

class ManualPage extends StatefulWidget {
  @override
  _ManualPageState createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  bool isLoading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Naudojimosi instrukcija")),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
              children: <Widget>[
                Center(
                  child: Image.asset('pictures/manual.png',
                    width: 480, height: 1250),
                ),
          ]
        ),
        ),
      ),
    );
  }
}
