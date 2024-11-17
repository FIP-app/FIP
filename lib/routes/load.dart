import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/entities/User.dart';
import 'package:proyecto/providers/AuthProvider.dart';
import 'package:proyecto/providers/DocumentProvider.dart';
import 'package:proyecto/providers/TestProvider.dart';
import 'package:proyecto/routes/landing.dart';
import 'package:proyecto/utils/my_drawer.dart';
import 'package:proyecto/utils/page_transition.dart';

class Load extends StatefulWidget {
  const Load({super.key});

  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> with MyDrawer, PageTransitionUtil {
  User? _user;
  AuthProvider auth = AuthProvider();
  DocumentProvider db = DocumentProvider();
  final _appBarTitle = const Text(
    "FIP",
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: "Poppins",
    ),
  );

  void getUser() {
    db.getRecord(
        collection: "users",
        doc: auth.auth.currentUser!.uid,
        onSuccess: (DocumentSnapshot<Map<String, dynamic>> res) {
          setState(() {
            _user = User.fromFireStore(auth.auth.currentUser!.uid, res);
          });
        },
        onError: (obj) => _user = null);
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    var db = context.watch<DocumentProvider>();
    var auth = context.watch<AuthProvider>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: buildDrawer(
        user: _user,
        context: context,
        onSignOut: () async {
          await context.read<AuthProvider>().auth.signOut();
          Navigator.of(context).pushAndRemoveUntil(createRoute(const LandingPage()), (route) => false);
        }
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: _appBarTitle,
      ),
      body: Container(
        color: const Color(0xffA5BFE7),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              width: 255.0,
              height: 255.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2.0)),
              child: const Image(image: AssetImage('assets/FIPLogo.png')),
            ),
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "Coming soon...",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
