//!! parasius |stfu| iklijuoja koda statefull
//?? KAM TAS REIKALINGA??
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/Chat/conversation_screen.dart';
import 'package:finalproject/Sevices/database.dart';
import 'package:finalproject/Sevices/helperfunctions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:finalproject/Sevices/constants.dart';

class ChatSearch extends StatefulWidget {
  ChatSearch({this.uid, Key key}) : super(key: key);
  final String uid;
  @override
  _ChatSearchState createState() => _ChatSearchState();
}

// ignore: unused_element
String _myName;

class _ChatSearchState extends State<ChatSearch> {
  final String title = "Pokalbiai";
  final dbRef = FirebaseDatabase.instance.reference().child("Users");
  TextEditingController searchController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot searchSnapshot;

  // ignore: missing_return
  String initiateSearch() {
    databaseMethods.getUserByUsername(searchController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].data()["name"],
              );
            },
          )
        : Container();
  }

  createChatroomAndStartConversation({String userName}) {
    if (userName != Constants.myName) {
      String roomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "Users": users,
        "roomId": roomId,
      };

      DatabaseMethods().createChatRoom(roomId, chatRoomMap);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(roomId, userName)),
      );
    } else {
      print("Tu negali rašyti pats sau!");
    }
  }

  // ignore: non_constant_identifier_names
  Widget SearchTile({String userName}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatroomAndStartConversation(userName: userName);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Parašyti",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
    //print("${_myName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paieška")),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54ffffff),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: " Ieškoti vartotojo",
                        hintStyle: TextStyle(color: Colors.grey),
                        //contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(40)),
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
