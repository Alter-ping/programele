//!! parasius |stfu| iklijuoja koda statefull
//?? KAM TAS REIKALINGA??
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: must_be_immutable
class SearchBar extends StatelessWidget {
  final dbRef = FirebaseDatabase.instance.reference().child("Books");
  TextEditingController _searchController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextField(
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              controller: _searchController,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
