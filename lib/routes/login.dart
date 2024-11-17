import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/providers/AuthProvider.dart';
import 'package:proyecto/routes/load.dart';
import 'package:proyecto/routes/register.dart';
import 'package:proyecto/utils/page_transition.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with PageTransitionUtil {
  late TextEditingController _emailController, _pswController;
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _pswController = TextEditingController();
    super.initState();
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  Padding createField(TextEditingController c, String text) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: c,
              cursorColor: Colors.black,
              obscureText: (text == "Contraseña"),
              enableSuggestions: !(text == "Contraseña"),
              autocorrect: !(text == "Contraseña"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text == "Correo" ? validateEmail : null),
              decoration: InputDecoration(
                focusColor: Colors.black,
                labelText: text,
                labelStyle: const TextStyle(
                    fontFamily: "DMSans", fontSize: 16, color: Colors.black),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 6.0)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.4)),
              ),
            )
          ],
        ));
  }

  void onLogin() async {
    var success = await context
        .read<AuthProvider>()
        .login(_emailController.text, _pswController.text);

    if (!success) {
      _emailController.text = "";
      _pswController.text = "";
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Jum, sucedió algo con tu login")));
    } else {
      Navigator.of(context)
          .pushAndRemoveUntil(createRoute(const Load()), (r) => false);
    }
  }

  void _submit() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      onLogin();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Falta validar algo")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AuthProvider>();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "Ingresa",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontSize: 40,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Inicia sesión para continuar.",
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ),
              ),
              createField(_emailController, "Correo"),
              createField(_pswController, "Contraseña"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: SizedBox(
                  width: 400,
                  height: 60,
                  child: TextButton(
                    onPressed: _submit,
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff88a3f4),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero))),
                    child: const Text(
                      "Ingresa",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "DMSans",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: SizedBox(
                  width: 400,
                  height: 60,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(createRoute(const Register()));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero))),
                    child: const Text(
                      "Crea tu cuenta",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "DMSans",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
