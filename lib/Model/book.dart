import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Book {
  String name;
  String author;
  String owner;
  String ownerid;
  String publisher;
  String city;
  String info;
  String category;
  String years;
  String documentId;
  String imageUrl;

  Book(this.name, this.author, this.owner, this.imageUrl);

  // formatting for upload to Firebase when creating the trip
  Map<String, dynamic> toJson() => {
        'name': name,
        'author': author,
        'owner': owner,
        'ownerid': ownerid,
        'publisher': publisher,
        'city': city,
        'category': category,
        'info': info,
        'years': years,
        'imageUrl':imageUrl
      };

  // creating a Trip object from a firebase snapshot
  Book.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot.data()['name'],
        author = snapshot.data()['author'],
        documentId = snapshot.id,
        owner = snapshot.data()['owner'],
        ownerid = snapshot.data()['ownerid'],
        publisher = snapshot.data()['publisher'],
        category = snapshot.data()['category'],
        city = snapshot.data()['city'],
        info = snapshot.data()['info'],
        years = snapshot.data()['years'],
        imageUrl = snapshot.data()['imageUrl'];
}
