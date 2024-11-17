import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/entities/User.dart';
import 'package:proyecto/providers/AuthProvider.dart';
import 'package:proyecto/providers/DocumentProvider.dart';
import 'package:proyecto/routes/load.dart';
import 'package:proyecto/routes/login.dart';
import 'package:proyecto/utils/page_transition.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin, PageTransitionUtil {
  late AnimationController _controller;
  late TextEditingController _nameController,
      _emailController,
      _pswController,
      _dateController;

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _pswController = TextEditingController();
    _dateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
        print(_dateController.text);
      });
    }
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
              validator: (text == "Correo" ? validateEmail : null),
              onTap:
                  (text == "Fecha de nacimiento" ? () => _selectDate() : null),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                //errorText: ("Correo" == text) ? "Jm?" : null,
                prefixIcon: ("Fecha de nacimiento" == text
                    ? const Icon(Icons.calendar_today)
                    : null),
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

  void _onRegister() async {
    if (_form.currentState!.validate()) {
      String uid = await context
          .read<AuthProvider>()
          .register(_emailController.text, _pswController.text);
      if (uid == 'weak-password') {
        _emailController.text = "";
        _pswController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Al parecer tu contraseña es muy debil.")));
        return;
      } else if (uid == 'email-already-in-use') {
        _emailController.text = "";
        _pswController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sucedió algo con tu cuenta.")));
        return;
      }

      User nw = User(_nameController.text, _emailController.text,
          _dateController.text, uid);

      context.read<DocumentProvider>().insertRecord(
          collection: "users",
          doc: nw,
          onError: (error) {
            print(error);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Paso algo con tu registro.")));
          },
          onSuccess: () =>
              Navigator.of(context).push(createRoute(const Load())));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Algo mal validado")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AuthProvider>();
    var db = context.watch<DocumentProvider>();
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
                  "Crear una cuenta nueva",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontSize: 40,
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(createRoute(const Login()));
                  },
                  child: const Text(
                    "¿Ya estás registrado? Inicia sesión aquí.",
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ),
              ),
              createField(_nameController, "Nombre"),
              createField(_emailController, "Correo"),
              createField(_pswController, "Contraseña"),
              createField(_dateController, "Fecha de nacimiento"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: SizedBox(
                  width: 400,
                  height: 60,
                  child: TextButton(
                    onPressed: _onRegister,
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff88a3f4),
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
