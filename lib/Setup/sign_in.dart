import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/Pages/home.dart';
import 'package:finalproject/Setup/register.dart';
import 'package:finalproject/Sevices/database.dart';
import 'package:finalproject/Sevices/helperfunctions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helpFunctions = new HelperFunctions();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //          >>su SingleChildScrollView galima scrollint kiek nori ir dingsta bottom overflowed<<
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.indigo[200], Colors.indigo[200]])),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                new Image.asset('pictures/pic1.png',
                    width: 200.0, height: 200.0),
                //el pasto ivedimas
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.grey[300],
                  ),
                  constraints: BoxConstraints(
                    maxHeight: 482,
                    //   maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),

                      //el pasto ivedimas

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

                      //slaptazodzio ivedimas

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

                      SizedBox(
                        height: 15,
                      ),

                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: RaisedButton(
                          onPressed: signIn,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Colors.indigo[500])),
                          color: Colors.indigo[400],
                          child: Text(
                            " Prisijungti ",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                        ),
                      ),

                      Text(
                        "arba",
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[800],
                        ),
                      ),

                      //registacijos mygtukas
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: RaisedButton(
                          onPressed: register,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Colors.orange[500])),
                          color: Colors.orange[400],
                          child: Text(
                            "Registruotis",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    //?? KA DARO ASYNC ??
    // Initialize FlutterFire

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        UserCredential authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        final User user = authResult.user;

        //Perduoda vartotojo varda
        final userDocument = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .get();
        final userData = userDocument.data();
        final userName = userData['name'];
        HelperFunctions.saveUserNameSharedPreference(userName);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home(uid: user.uid)),
        );
      } catch (e) {
        print(e.message);
      }
    }
  }

  void register() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }
}
