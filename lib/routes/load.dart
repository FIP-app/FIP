import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/providers/TestProvider.dart';

class Load extends StatefulWidget {
  const Load({ super.key });

  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TestProvider>();
    return Scaffold(
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
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0
                  )
                ),
                child: const Image(
                  image: AssetImage('assets/FIPLogo.png')
                ),
              ),
            const Padding(
              padding: EdgeInsets.all(30.0),
              child:  Text(
              "Coming soon...",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 40,
                color: Colors.black,
                fontStyle: FontStyle.italic
              ),
            ),
            )
          ],
        ),
      ),
    );
  }
}