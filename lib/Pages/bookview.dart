import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/Chat/conversation_screen.dart';
import 'package:finalproject/Sevices/constants.dart';
import 'package:finalproject/Sevices/database.dart';
import 'package:finalproject/Sevices/helperfunctions.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Model/book.dart';

class BookView extends StatefulWidget {
  final Book book;
  BookView({Key key, @required this.book}) : super(key: key);

  @override
  _BookViewState createState() => _BookViewState(book);
}

class _BookViewState extends State<BookView> {
  Book book;
  _BookViewState(this.book);
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String userName;

  QuerySnapshot searchSnapshot;
  Stream chatRoomsStream;

  // ignore: missing_return
  String initiateSearch() {
    databaseMethods.getUserByUsername(userName).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {
      databaseMethods.getChatRooms(Constants.myName).then((value) {
        setState(() {
          chatRoomsStream = value;
        });
      });
    });
  }

  @override
  void initState() {
    getUserInfo();
    initiateSearch();
    userName = widget.book.owner;
    super.initState();
  }

  // final Book book;
  createChatroomAndStartConversation({var userName}) {
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
      print("Jūs negalite rašyti pačiam sau!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Knyga"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(book.name,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  //Subtitle
                  subtitle: Text("Autorius: " + book.author),
                  leading: Icon(
                    Icons.book,
                    color: Colors.indigo,
                  ),
                ),
                Divider(),

                Container(
                  child: ListTile(
                    title: Text(
                      "Savininkas: " + userName,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.indigo,
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Container(
                            child: Row(
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                "Susisiekti",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.indigo,
                              onPressed: () {
                                createChatroomAndStartConversation(
                                    userName: userName);
                              },
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),

                ListTile(
                  title: Text("Miestas: " + book.city,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      )),
                  leading: Icon(
                    Icons.location_city,
                    color: Colors.indigo,
                  ),
                ),
                ListTile(
                  title: Text("Kategorija: " + book.category,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      )),
                  leading: Icon(
                    Icons.collections_bookmark,
                    color: Colors.indigo,
                  ),
                ),
                ListTile(
                  title: Text("Leidykla: " + book.publisher,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      )),
                  subtitle: Text("Leidimo metai: " + book.years),
                  leading: Icon(
                    Icons.menu_book,
                    color: Colors.indigo,
                  ),
                ),
                // Informacijos juostele
                Row(
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          )),
                    ),
                    Text("Komentaras"),
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    book.info,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
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
