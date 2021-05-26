//!! parasius |stfu| iklijuoja koda statefull

import 'package:finalproject/Chat/chatRoomScreen.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Pages/addbook.dart';
import 'package:finalproject/Pages/homeview.dart';
import 'navigationdrawer.dart';

class Home extends StatefulWidget {
  Home({this.uid, Key key}) : super(key: key);
  final String uid;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        //title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_box,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(uid: this.widget.uid),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Expanded(
            child: HomeView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(uid: this.widget.uid),
                ),
              );
        },
        tooltip: 'Increment',
        backgroundColor: Colors.indigo,
        child: Icon(Icons.chat_rounded),
      ),
      drawer: NavigateDrawer(uid: this.widget.uid),
    );
  }
}
