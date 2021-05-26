import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/Sevices/database.dart';
import 'package:finalproject/Sevices/helperfunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Pages/home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference dbRef = FirebaseFirestore.instance.collection("Users");

  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helpFunctions = new HelperFunctions();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registracija")),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        // constraints: BoxConstraints(
        //      maxHeight: 482,
        //      maxWidth: MediaQuery.of(context).size.width,
        //     ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  "Užpildykite tuščius registracijos laukelius",
                  style: TextStyle(
                    height: 5,
                    fontSize: 17,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    //alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: new BoxDecoration(
                          color: Color(0x70487bea),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30))),
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Slapyvardis",
                          hintStyle: TextStyle(color: Colors.grey[700]),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return '  Įveskite slapyvardį';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    //alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: new BoxDecoration(
                          color: Color(0x70487bea),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30))),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " El. paštas",
                          hintStyle: TextStyle(color: Colors.grey[700]),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Įveskite teisingą el. pastą';
                          } else if (!value.contains('@')) {
                            return 'Įveskite teisingą el. pastą';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    //alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: new BoxDecoration(
                          color: Color(0x70487bea),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30))),
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Miestas",
                          hintStyle: TextStyle(color: Colors.grey[700]),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return '  Įveskite miesto pavadinimą';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: new BoxDecoration(
                          color: Color(0x70487BEA),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30))),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Slaptažodis",
                          hintStyle: TextStyle(color: Colors.grey[700]),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (input) {
                          if (input.length < 6) {
                            return '  Įveskite teisingą slaptažodį';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                //registacijos mygtukas
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        registerToFb();
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.orange[500])),
                    color: Colors.orange[400],
                    child: Text(
                      "Registruotis",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerToFb() {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((result) {
      dbRef.doc(result.user.uid).set({
        "email": _emailController.text,
        "city": cityController.text,
        "name": _usernameController.text
      }).then((res) {
        isLoading = false;
        HelperFunctions.saveUserNameSharedPreference(_usernameController.text);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
        );
      });
    }).catchError((err) {
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
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    cityController.dispose();
  }
}
