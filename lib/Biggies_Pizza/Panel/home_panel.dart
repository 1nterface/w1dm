import 'package:badges/badges.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:w1dm/Biggies_Pizza/Panel/panel_de_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:w1dm/Biggies_Pizza/Clientes/menu_cliente.dart' as menu;
import 'package:w1dm/Biggies_Pizza/Panel/panel_de_control.dart' as panel_de_control;
import 'package:w1dm/Biggies_Pizza/Panel/soporte.dart' as soporte;
import 'package:shared_preferences/shared_preferences.dart';

class home_panel extends StatefulWidget {

  @override
  home_panelState createState() => home_panelState();
}

class home_panelState extends State<home_panel> with SingleTickerProviderStateMixin {

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

    comprasNotificaciones(context);
    //promosNotificaciones(context);
    // TODO: implement initState
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  Widget promosNotificaciones (BuildContext context){
    return StreamBuilder(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Notificaciones').doc("Promos").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            return
              userDocument["notificacion"] == "0"?
              Tab(icon:Icon(Icons.phone_android), text: "PEDIDOS",)
                  :
              Badge(
                position: BadgePosition(left: 40),
                badgeColor: Colors.white,
                badgeContent: Text(userDocument["notificacion"], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[900]), ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Tab(icon: Icon(Icons.restaurant), text: "PEDIDOS",),
                ),
              );
          }
        }
    );
  }

  Widget comprasNotificaciones (BuildContext context){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return  StreamBuilder(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Notificaciones').doc("Soporte"+correoPersonal.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            userDocument["notificacion"] == "0"?
            print('nada')
                :
            print('nada');


            return
              userDocument["notificacion"] == "0"?
              Tab(icon:Icon(Icons.security), text: "SOPORTE",)
                  :
              Tab(icon:Icon(Icons.security), text: "SOPORTE",);

          }
        }
    );

  }

  Widget pedidosNotificacion (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos"+correoPersonal.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            //SALASH NOTIFICACION OBJETO INSTANCIADO
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            return
              userDocument["notificacion"] == "0"?
              Tab(icon:Icon(Icons.phone_android), text: "PEDIDOS",)
                  :
              Badge(
                position: BadgePosition(left: 30),
                badgeColor: Colors.white,
                badgeContent: Text(userDocument["notificacion"], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[900]),),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Tab(icon: Icon(Icons.phone_android), text: "PEDIDOS",),
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
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('¿Deseas salir de la compra?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Si'),
                    onPressed: () {

                      //signOut();
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            }
        );

        return value == true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red[800],
          title: Text('La Festa Pizzas'),
          bottom: TabBar(
            controller: controller,
            tabs: <Widget>[
              //Tab(icon: Icon(Icons.chat), text: "CHAT",),
              pedidosNotificacion(context),
              Tab(icon:Icon(Icons.security), text: "SOPORTE",),
              //comprasNotificaciones(context),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            //proveedor.Menu_Clientes2(),
            panel_de_control.panel_de_control(),
            soporte.soporte(),
            //acreedores.Mis_Compras2(),
            //empleados.Pagos_Clientes(),
          ],
        ),
      ),
    );
  }
}

