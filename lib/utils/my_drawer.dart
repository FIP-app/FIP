import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/entities/User.dart';
import 'package:proyecto/providers/AuthProvider.dart';
import 'package:proyecto/providers/DocumentProvider.dart';
import 'package:proyecto/routes/landing.dart';
import 'package:proyecto/utils/page_transition.dart';

Map<String, IconData> iconsMap = {
  "Metodo de pago" : Icons.paid_rounded,
  "Arrienda tu parqueadero" : Icons.local_parking,
  "Busca tu parqueadero": Icons.search,
  "Administra tus spots" : Icons.key,
  "Administra tu reserva" : Icons.car_crash,
  "Cerrar sesion": Icons.logout_rounded
};

mixin MyDrawer  {


  void showMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Esta funcionalidad no esta disponible")));
  }

  ListTile createDrawerOption({
    required String text, 
    required BuildContext context,
    required Function onSignOut
  }) {
    return ListTile(
      leading: Icon(
        iconsMap[text],
        size: 40,
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 17,
          ),
        ),
      ),
      onTap: () async {
        if (text != "Cerrar sesion") {
          showMessage(context);
        } else {
          onSignOut();
        }
      },
    );
  }

  Drawer buildDrawer({
    required User? user, 
    required BuildContext context,
    required Function onSignOut
    }) {
    return Drawer(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
            width: 200.0,
            height: 270.0,
            child: DrawerHeader(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 2.0)),
                      child:
                          const Image(image: AssetImage('assets/FIPLogo.png')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Text(
                        "Bienvenido ${user?.name}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: "Poppins", fontSize: 16.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          ...iconsMap.entries.map((e) => e.key != "Cerrar sesion" ? createDrawerOption(
            text: e.key,
            context: context,
            onSignOut: onSignOut
          ) : const ListTile()) 
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
            child: createDrawerOption(
              text: "Cerrar sesion",
              context: context,
              onSignOut: onSignOut
            ),
          )     
        ],
      ),
      ),
    );
  }
}
