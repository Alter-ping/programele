import 'package:finalproject/Chat/chatRoomScreen.dart';
import 'package:finalproject/Pages/likedbookview.dart';
import 'package:finalproject/Pages/manual.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Setup/sign_in.dart';
import 'package:finalproject/Pages/home.dart';
import 'package:finalproject/Pages/mybookview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//MENU BAR
class NavigateDrawer extends StatefulWidget {
  final String uid;
  NavigateDrawer({Key key, this.uid}) : super(key: key);
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(widget.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data['email']);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            accountName: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(widget.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data['name']);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            decoration: BoxDecoration(
              color: Colors.indigo[300],
            ),
          ),

          // //Pagr ekranas

          // ListTile(
          //   leading: new IconButton(
          //     icon: new Icon(Icons.home, color: Colors.indigo),
          //     onPressed: () => null,
          //   ),
          //   title: Text('Pradinis ekranas'),
          //   onTap: () {
          //     print(widget.uid);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => Home(uid: widget.uid)),
          //     );
          //   },
          // ),

          //Mano knygos

          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.book, color: Colors.indigo),
              onPressed: () => null,
            ),
            title: Text('Mano knygos'),
            onTap: () {
              //print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBookCard(uid: widget.uid)),
              );
            },
          ),

          //Patikusios knygos

          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.favorite, color: Colors.indigo),
              onPressed: () => null,
            ),
            title: Text('Patikusios knygos'),
            onTap: () {
              //print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LikedBookCard(uid: widget.uid)),
              );
            },
          ),

          //Pokalbiai

          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.message, color: Colors.indigo),
              onPressed: () => null,
            ),
            title: Text('Pokalbiai'),
            onTap: () {
              //print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatRoom(uid: widget.uid)),
              );
            },
          ),

          //Instrukcija

          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.help, color: Colors.indigo),
              onPressed: () => null,
            ),
            title: Text('Naudojimosi instrukcija'),
            onTap: () {
              //print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManualPage()),
              );
            },
          ),

          //Apie programele

          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.info, color: Colors.indigo),
              onPressed: () => null,
            ),
            title: Text('Apie programėlę'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationIcon: FlutterLogo(),
                applicationName: "Knygų keitimosi programėlė",
                applicationVersion: "1.0",
                applicationLegalese: "Programėlė sukurta Luko Aleksos",
                children: <Widget>[
                  Text(
                      "\n       Ši progrąmėlė yra virtuali knygų skaitytojų bendruomenė, kurioje žmonės dalinsis knygomis su kitais nariais, bendraus ir dalinsis įspūdžiais apie jau perskaitytas knygas."),
                ],
              );
            },
          ),

          //Atsijungti

          ListTile(
              leading: new IconButton(
                  icon: new Icon(Icons.exit_to_app, color: Colors.indigo),
                  onPressed: () => null),
              title: Text('Atsijungti'),
              onTap: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then(
                  (res) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                );
              }),
        ],
      ),
    );
  }

  void showAboutDialog({
    @required BuildContext context,
    String applicationName,
    String applicationVersion,
    Widget applicationIcon,
    String applicationLegalese,
    List<Widget> children,
    bool useRootNavigator = true,
    RouteSettings routeSettings,
  }) {
    assert(context != null);
    assert(useRootNavigator != null);
    showDialog<void>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: applicationName,
          applicationVersion: applicationVersion,
          applicationIcon: applicationIcon,
          applicationLegalese: applicationLegalese,
          children: children,
        );
      },
      routeSettings: routeSettings,
    );
  }
}
