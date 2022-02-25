import 'package:badges/badges.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:w1dm/Biggies_Pizza/Clientes/menu_cliente.dart' as menu;
import 'package:w1dm/Biggies_Pizza/Clientes/ofertas.dart' as ofertas;

import 'package:w1dm/Biggies_Pizza/Clientes/compras.dart' as compras;
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home extends StatefulWidget {


  cajas_modelo product;
  home(this.product);

  @override
  homeState createState() => homeState();
}

class homeState extends State<home> with SingleTickerProviderStateMixin {

  late TabController controller;

  Future<void> comprasNotificacion (BuildContext context)async{

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correopersonal', isEqualTo: correoPersonal).where('visto', isEqualTo: "si").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("Esto quiero: "+_myDocCount.length.toString());

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correopersonal', isEqualTo: correoPersonal).where('visto', isEqualTo: "no").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Esto quiero: "+_myDocCount2.length.toString());

    int total =   _myDocCount.length - _myDocCount2.length;
    FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+correoPersonal.toString()).set({'notificacion': total.toString()});
  }


  @override
  void initState() {

    print("NOMBRE EMPRESA PARA PASAR A MENU CLIENTES: "+widget.product.nombreProducto);

    comprasNotificaciones(context);
    //promosNotificaciones(context);
    // TODO: implement initState
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //signOut();
    controller.dispose();
  }

  CollectionReference promo = FirebaseFirestore.instance.collection('Notificaciones');

  Widget promosNotificaciones (BuildContext context){
    return FutureBuilder<DocumentSnapshot>(
      future: promo.doc("Promos").get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return
            data["notificacion"] == "0"?
            Column(
              children: [
                Tab(icon: Icon(Icons.announcement, color: Colors.white,)),
                Text("OFERTAS", style: TextStyle(color: Colors.white),),
              ],
            )
                :
            Badge(
              position: BadgePosition(left: 40),
              badgeColor: Colors.red[700],
              badgeContent: Text(data["notificacion"], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Column(
                  children: [
                    Tab(icon: Icon(Icons.announcement, color: Colors.white,)),
                    Text("OFERTAS", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            );
        }

        return Text("loading");
      },
    );
  }

  Widget comprasNotificaciones (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+correoPersonal.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;


            return
              data["notificacion"] == "0"?
              Column(
                children: const [
                  Tab(icon: Icon(Icons.monetization_on, color: Colors.white,)),
                  Text("COMPRAS", style: TextStyle(color: Colors.white),),
                ],
              )
                  :
              Badge(
                position: BadgePosition(left: 40),
                badgeColor: Colors.red[700],
                badgeContent: Text(data["notificacion"], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Column(
                    children: [
                      Tab(icon: Icon(Icons.monetization_on, color: Colors.white,)),
                      Text("COMPRAS", style: TextStyle(color: Colors.white),),
                    ],
                  ),

                ),
              );

          }
        }
    );
  }

  var now = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: Text("Gil", style: const TextStyle(color: Colors.white),),
        bottom: TabBar(
          controller: controller,
          tabs: <Widget>[
            Column(
              children: [
                Tab(icon: Icon(Icons.restaurant, color: Colors.white,)),
                Text("MENU", style: TextStyle(color: Colors.white),),
              ],
            ),
            //Tab(icon: Icon(Icons.chat), text: "CHAT",),
            Column(
              children: [
                Tab(icon: Icon(Icons.restaurant, color: Colors.white,)),
                Text("MENU", style: TextStyle(color: Colors.white),),
              ],
            ),
            Column(
              children: [
                Tab(icon: Icon(Icons.restaurant, color: Colors.white,)),
                Text("MENU", style: TextStyle(color: Colors.white),),
              ],
            ),
            //comprasNotificaciones(context),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          //proveedor.Menu_Clientes2(),
          menu.menu_cliente("nombreProducto", "nombreProveedor", "newid", "foto", "estado", "cdb", 0, 0),
          ofertas.ofertas(),
          compras.compras(),
          //acreedores.Mis_Compras2(),
          //empleados.Pagos_Clientes(),
        ],
      ),
    );
  }
}