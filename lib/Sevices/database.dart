import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finalproject/Model/book.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .get();
  }

  createChatRoom(String roomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("Chatroom")
        .doc(roomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String roomId, messageMap) {
    FirebaseFirestore.instance
        .collection("Chatroom")
        .doc(roomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String roomId) async {
    return /*await*/ FirebaseFirestore.instance
        .collection("Chatroom")
        .doc(roomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return /*await*/ FirebaseFirestore.instance
        .collection("Chatroom")
        .where("Users", arrayContains: userName)
        .snapshots();
  }

  createLikedBook(Book book, uid) {
    final User user = FirebaseAuth.instance.currentUser;
    CollectionReference dbRef =
        FirebaseFirestore.instance.collection("LikedBooks");
    dbRef.add({
      "name": book.name,
      "author": book.author,
      "city": book.city,
      "category": book.category,
      "publisher": book.publisher,
      "years": book.years,
      "info": book.info,
      "ownerid": book.ownerid,
      "owner": book.owner,
      "imageUrl": book.imageUrl,
      "likedby": user.uid
    });
  }
}
