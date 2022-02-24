import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/agentes_modelo.dart';
import 'package:w1dm/Biggies_Pizza/Repartidor//repartidor_pedidos.dart' as pedidos;
import 'package:w1dm/Biggies_Pizza/Repartidor/repartidor_mis_entregas.dart' as entregas;
import 'package:shared_preferences/shared_preferences.dart';

class repartidor_home extends StatefulWidget {

  final String correoNegocio, nombrerepa;
  repartidor_home(this.correoNegocio, this.nombrerepa);

  @override
  repartidor_homeState createState() => repartidor_homeState();
}

class repartidor_homeState extends State<repartidor_home> with SingleTickerProviderStateMixin {

  late TabController controller;
  CollectionReference reflistanotificacioness = FirebaseFirestore.instance.collection('Notificaciones');

  
  Future<void> num ()async{
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Ventas').where('estado2', isEqualTo: "pedidofinalizado").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("Esto quiero: "+_myDocCount.length.toString());

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Ventas').where('estado', isEqualTo: "pagado").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Esto quiero: "+_myDocCount2.length.toString());

    int total =  _myDocCount2.length - _myDocCount.length;
    FirebaseFirestore.instance.collection('VentaN').doc("123").update({'notificacion': total.toString()});
  }

  //ME FALTA CREAR AUTOMATICAMENTE LA COLECCION VENTAN PARA ENVIAR AHI LA CANTIDAD DE ELEMENTOS CON LA CONDICION QUE NECESITO


  CollectionReference repapedidos = FirebaseFirestore.instance.collection('Notificaciones');

  Widget pedidoNotificacion (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return FutureBuilder<DocumentSnapshot>(
      future: repapedidos.doc("Repa_Pedidos"+correoPersonal.toString()).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Column(
            children: const [
              Tab(icon: Icon(Icons.message, color: Colors.white,)),
              Text("PEDIDOS", style: TextStyle(color: Colors.white),),
            ],
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {

          return Column(
            children: const [
              Tab(icon: Icon(Icons.message, color: Colors.white,)),
              Text("PEDIDOS", style: TextStyle(color: Colors.white),),
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;
          return
            userDocument["notificacion"] == "0"?
            Column(
              children: const [
                Tab(icon: Icon(Icons.message, color: Colors.white,)),
                Text("PEDIDOS", style: TextStyle(color: Colors.white),),
              ],
            )
            :
            Badge(
              position: BadgePosition(left: 30),
              badgeColor: Colors.white,
              badgeContent: Text(userDocument["notificacion"], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow[700]),),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Column(
                  children: const [
                    Tab(icon: Icon(Icons.message, color: Colors.white,)),
                    Text("PEDIDOS", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            );
        }

        return Text("loading");
      },
    );
  }

  Future<void> pedidosRepa (BuildContext context)async{

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    FirebaseFirestore.instance.collection('Repartidor_Registro').where('correo', isEqualTo: correoPersonal).get().then((snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {

        var nombreRepa = doc['nombre'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('nombreRepa', nombreRepa);
        print("Nombre: "+nombreRepa);
      }

      final prefs5 = await SharedPreferences.getInstance();
      final nombreRepa = prefs5.getString('nombreRepa') ?? "";

      //IMPLEMENTAR UN THANOS PARA BUSCAR LA SUCURSAL A LA QUE PERTENECE EL COCINERO
      //DESPUES USARLA AQUI ABAJO COMO CONDICION PARA CONTAR LAS VENTAS QUE TIENEN MI SUCURSAL
      QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Ventas').where('repartidor', isEqualTo: nombreRepa).where('estado3', isEqualTo: "encamino").get();
      List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
      print("Esto quiero: "+_myDocCount2.length.toString());

      FirebaseFirestore.instance.collection('Notificaciones').doc("Repa_Pedidos"+correoPersonal.toString()).set({'notificacion': _myDocCount2.length.toString()});

    });


    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('nombreRepa');
  }

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: 2, vsync: this);
    super.initState();
    pedidosRepa(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: Text('Repartidor', style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: controller,
          tabs: <Widget>[
            pedidoNotificacion(context),
            //total(context),
            Column(
              children: const [
                Tab(icon: Icon(Icons.motorcycle, color: Colors.white,)),
                Text("MIS ENTREGAS", style: TextStyle(color: Colors.white),),
              ],
            ),            //Tab(icon: Icon(Icons.monetization_on), text: "MIS COMPRAS",),
            //Tab(icon: Icon(Icons.playlist_add), text: "PEDIDOS",),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          pedidos.repartidor_pedidos(widget.correoNegocio, widget.nombrerepa),
          entregas.repartidor_mis_entregas(),
          //miscompras.Mis_Compras()
        ],
      ),
    );
  }
}
