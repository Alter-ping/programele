import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/Model/book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Pages/book_card.dart';
import 'package:finalproject/Sevices/database.dart';

class HomeView extends StatefulWidget {
  HomeView({this.uid, Key key}) : super(key: key);
  final String uid;
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final dbRef = FirebaseFirestore.instance.collection("Books");
  TextEditingController _searchController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    //with help of listener we ar going to call function onSearchChanged
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getItemStreamSnapshots();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  getItemStreamSnapshots() async {
    final data = await FirebaseFirestore.instance
        .collection('Books')
        .where("ownerid", isNotEqualTo: user.uid)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var bookSnapshot in _allResults) {
        var name = Book.fromSnapshot(bookSnapshot).name.toLowerCase();
        var author = Book.fromSnapshot(bookSnapshot).author.toLowerCase();
        var owner = Book.fromSnapshot(bookSnapshot).owner.toLowerCase();

        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(bookSnapshot);
        }
        if (author.contains(_searchController.text.toLowerCase())) {
          showResults.add(bookSnapshot);
        }
        if (owner.contains(_searchController.text.toLowerCase())) {
          showResults.add(bookSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                controller: _searchController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: "Paieška",
                  hintStyle: TextStyle(color: Colors.grey),
                  //contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _resultsList.length,
                itemBuilder: (BuildContext context, int index) => buildBookCard(
                    context, _resultsList[index], databaseMethods, user.uid),
              ),
            )
          ],
        ),
      ),
    );
  }
}
