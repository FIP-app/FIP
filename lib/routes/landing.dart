import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/providers/AuthProvider.dart';
import 'package:proyecto/routes/load.dart';
import 'package:proyecto/routes/login.dart';
import 'package:proyecto/routes/register.dart';
import '../utils/page_transition.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin, PageTransitionUtil {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.getIsLogged()) {
        Navigator.of(context)
            .pushAndRemoveUntil(createRoute(const Load()), (r) => false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        color: Color(0xffA5BFE7),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30.0),
              width: 250.0,
              height: 250.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2.0)),
              child: const Image(image: AssetImage('assets/FIPLogo.png')),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 50, 30, 10),
              child: const Text(
                "Tu parqueo desde la palma de tu mano",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "DMSans",
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 10, 25, 50),
              child: const Text(
                "Bienvenido a FIP, la solución para encontrar parqueo dentro de Bogota",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "DMSans",
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              //margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      child: Text("Unete ahora"),
                      onPressed: () {
                        Navigator.of(context)
                            .push(createRoute(const Register()));
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffe9538e)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      child: Text("Accede"),
                      onPressed: () {
                        Navigator.of(context).push(createRoute(const Login()));
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
