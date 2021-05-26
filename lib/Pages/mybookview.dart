import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/Model/book.dart';
import 'package:finalproject/Pages/mybook_card.dart';
import 'package:finalproject/Pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBookCard extends StatefulWidget {
  MyBookCard({this.uid, Key key, Book book}) : super(key: key);
  final String uid;
  @override
  _MyBookCardState createState() => _MyBookCardState();
}

class _MyBookCardState extends State<MyBookCard> {
  final dbRef = FirebaseFirestore.instance.collection("Books");

  Future resultsLoaded;
  List _allResults = [];

  @override
  void initState() {
    super.initState();
    resultsLoaded = getItemStreamSnapshots();
  }

  getItemStreamSnapshots() async {
    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    final data = await FirebaseFirestore.instance
        .collection('Books')
        .where("ownerid", isEqualTo: uid)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Mano knygos")),
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _allResults.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildMyBookCard(context, _allResults[index]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMyBookCard(BuildContext context, DocumentSnapshot document) {
    final book = Book.fromSnapshot(document);
    return new Container(
      child: Card(
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                          offset: Offset(3, 3),
                          blurRadius: 10.0,
                          spreadRadius: 2,
                          color: Colors.grey.shade400),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  //margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: new Material(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    child: new InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // Book card view
                            builder: (context) => MyBookView(book: book),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.book,
                                      color: Colors.indigo,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      book.name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.create,
                                      color: Colors.indigo,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      book.author,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.person,
                                    color: Colors.indigo,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    book.owner,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]),
                                SizedBox(height: 10),
                                Row(children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.location_city,
                                    color: Colors.indigo,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    book.city,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              iconSize: 25,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Dėmesio!"),
                                    content: Text(
                                        "Ar tikrai norite ištrinti šią knygą?"),
                                    actions: [
                                      FlatButton(
                                        child: Text("Gerai"),
                                        onPressed: () {
                                          dbRef.doc(book.documentId).delete();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Home(uid: widget.uid)),
                                          );
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Atšaukti"),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          //paveikslelio vieta
                          Stack(
                            children: <Widget>[
                              SizedBox(
                                  child: Image.network(book.imageUrl),
                                  width: 60,
                                  height: 100),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 90,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
