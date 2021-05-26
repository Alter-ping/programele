import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Model/book.dart';
import 'package:finalproject/Pages/bookview.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:finalproject/Sevices/database.dart';

Widget buildBookCard(BuildContext context, DocumentSnapshot document,
    DatabaseMethods databaseMethods, String uid) {
  final book = Book.fromSnapshot(document);
  return SingleChildScrollView(
    child: new Container(
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
                    color: Colors.indigo,
                  ),
                  child: new Material(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    child: new InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // Book card view
                            builder: (context) => BookView(book: book),
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
                                      size: 20,
                                      color: Colors.indigo,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      book.name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
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
                                          color: Colors.black87,
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
                                        color: Colors.black87,
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
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: FavoriteButton(
                              isFavorite: false,
                              iconSize: 50,
                              valueChanged: (isFavourite) {
                                isFavourite = true;
                                if (isFavourite == true) {
                                  databaseMethods.createLikedBook(book, uid);
                                }
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
                                    left: 80,
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
    ),
  );
}
