import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Pages/home.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class AddBookPage extends StatefulWidget {
  final String uid;
  AddBookPage({Key key, this.uid}) : super(key: key);
  @override
  _AddBookPageState createState() => new _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final listOfCategories = [
    "Klasika",
    "Biografinė",
    "Fantastinė",
    "Pomėgių",
    "Mokslinė",
    "Užsienio",
    "Grožinė",
    "Vaikams",
    "Kita"
  ];
  String dropdownValue = 'Klasika';
  CollectionReference dbRef = FirebaseFirestore.instance.collection("Books");
  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController yearsController = TextEditingController();
  TextEditingController infoController = TextEditingController();

//------------------------------------------------------------------
  File imageFile;
  File imageFile2;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    final PickedFile camera = await picker.getImage(source: ImageSource.camera);

    setState(() {
      imageFile = File(camera.path);
    });
  }

  Future pickPhoto() async {
    final PickedFile camera =
        await picker.getImage(source: ImageSource.gallery);

    setState(() {
      imageFile2 = File(camera.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = path.basename(imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

//------------------------------------------------------------------

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text("Add book")),

      //body: SingleChildScrollView(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Book name
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    //height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: new BoxDecoration(
                          color: Color(0x70487bea),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30))),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Įveskite knygos pavadinimą",
                          hintStyle: TextStyle(color: Colors.grey[900]),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return ' Įveskite knygos pavadinimą';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                // Author
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: new BoxDecoration(
                          color: Color(0x70487bea),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30))),
                      child: TextFormField(
                        controller: authorController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Įveskite autorių",
                          hintStyle: TextStyle(color: Colors.grey[900]),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return ' Įveskite autorių';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                // Category
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: DropdownButtonFormField(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    decoration: InputDecoration(
                      labelText: "Pasirinkite kategoriją",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    //alignment: Alignment.center,
                    items: listOfCategories.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return ' Pasirinkite kategoriją';
                      }
                      return null;
                    },
                  ),
                ),

                // Publisher
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    //alignment: Alignment.center,
                    child: Container(
                      //height: 30,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: new BoxDecoration(
                          color: Color(0x70487bea),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30))),
                      child: TextFormField(
                        controller: publisherController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Įveskite leidyklą",
                          hintStyle: TextStyle(color: Colors.grey[800]),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return ' Įveskite leidyklą';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                // Years
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    //alignment: Alignment.center,
                    child: Container(
                      //height: 30,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: new BoxDecoration(
                          color: Color(0x70487bea),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30))),
                      child: TextFormField(
                        controller: yearsController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Įveskite leidimo metus",
                          hintStyle: TextStyle(color: Colors.grey[800]),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Įveskite leidimo metus';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                // Info
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    //alignment: Alignment.center,
                    child: Container(
                      //height: 30,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: new BoxDecoration(
                          color: Color(0x70487bea),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30))),
                      child: TextFormField(
                        controller: infoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Palikite komentarą",
                          hintStyle: TextStyle(color: Colors.grey[800]),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Palikite komentarą';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    //pick camera

                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 5.0),
                            margin: const EdgeInsets.only(left: 15.0),
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: imageFile != null
                                  ? Image.file(imageFile)
                                  : FlatButton(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 40,
                                      ),
                                      onPressed: pickImage,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //pick photo

                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 5.0),
                            margin: const EdgeInsets.only(
                              left: 75.0,
                            ),
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: imageFile2 != null
                                  ? Image.file(imageFile2)
                                  : FlatButton(
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 40,
                                      ),
                                      onPressed: pickPhoto,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //uploadImageButton(context),

//---------------------------------------------------------------------------------

                // Submit
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                //getUsername();
                                addToFb();
                                uploadImageToFirebase(context);
                                //dispose();
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Colors.indigo[500])),
                            color: Colors.indigo[400],
                            child: Text(
                              "Įkelti",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
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

  void addToFb() async {
    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .get();
    final userData = userDoc.data();
    final city = userData['city'];
    final owner = userData['name'];

    dbRef.add({
      "name": nameController.text,
      "author": authorController.text,
      "city": city,
      "category": dropdownValue,
      "publisher": publisherController.text,
      "years": yearsController.text,
      "info": infoController.text,
      "ownerid": uid,
      "owner": owner
    }).then((res) {
      isLoading = false;

      //KAD ISSOKTU POP UP PRANESANTIS KAD SEKMINGAI PRIDDETA KNYGA

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(uid: widget.uid)),
      );
    }).catchError(
      (err) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}

final Color yellow = Color(0xfffbc31b);
final Color orange = Color(0xfffb6900);
