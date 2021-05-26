import 'package:finalproject/Sevices/database.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Model/book.dart';

class MyBookView extends StatefulWidget {
  final Book book;
  MyBookView({Key key, @required this.book}) : super(key: key);

  @override
  _MyBookViewState createState() => _MyBookViewState(book);
}

class _MyBookViewState extends State<MyBookView> {
  Book book;
  _MyBookViewState(this.book);
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String userName;
  Stream chatRoomsStream;

  // ignore: missing_return
  String initiateSearch() {
    databaseMethods.getUserByUsername(userName).then((val) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Mano knygos"),
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
                      "Savininkas: " + book.owner,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.indigo,
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
