import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:w1dm/Biggies_Pizza/Panel/panel_de_control_detalle.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/carpinteria_producto_detalle.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/panel_pedido_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';

class panel_de_control extends StatefulWidget {
  @override
  panel_de_controlState createState() => panel_de_controlState();
}

class panel_de_controlState extends State<panel_de_control> {

  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Pedidos_Jimena');

  Future<void> pedidos (BuildContext context)async{

    var now = DateTime.now();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correoNegocio', isEqualTo: correoPersonal).where("visto", isEqualTo: "no").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Notificacion: "+_myDocCount2.length.toString());

    FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos"+correoPersonal.toString()).set  ({'notificacion': _myDocCount2.length.toString()});
  }

  var category;
  //FOLIO, NOMBRE, CELULAR, COLONIA, CALLE, NUMERO
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _colonia = TextEditingController();
  final TextEditingController _calle = TextEditingController();
  final TextEditingController _numero = TextEditingController();

  void t(){
    Future.delayed(Duration(seconds: 5), () {
      print(" This line is execute after 5 seconds");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    pedidos(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var now = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }


  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController _cantidad6 = TextEditingController();
  final TextEditingController _cantidadr = TextEditingController();


  listaPedidos(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistaproduccion.where("miembrodesde", isEqualTo: DateFormat("yyyy-MM-dd").format(now)).orderBy('folio', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (!snapshot.hasData) {
              return Text("Loading..");
            }
            //reference.where("title", isEqualTo: 'UID').snapshots(),

            else
            {
              //ESTE SI FUNCIONA, VOLVER A HACER TODO COM ESTE WIDGET
              return ListView(
                children: snapshot.data!.docs.map((documents) {

                  //LAS VARIABLES QUE DELCARO AQUI HACEN EL BAD STATE!!!!!!!

                  return InkWell(
                    onTap: () async{

                      final String direccion = documents["calle"]+" #"+documents["numext"]+", "+documents["colonia"];

                      await Navigator.push(context, MaterialPageRoute(builder: (context) => panel_de_control_detalle(panel_pedido_modelo("", documents["nombrecliente"],documents["tel"],documents["folio"],2,0, 0,0, documents["concepto"], documents["estado3"], documents["nombrecliente"], documents["miembrodesde"],documents["newid"], documents["totalNota"], documents["calle"], documents["colonia"], 0, documents["numext"], documents["estadoc"], direccion))),);

                      FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(documents["newid"]).update({'visto': 'si'});


                    },
                    child: Card(
                      elevation: 1.0,
                      color:
                      documents["visto"] == "no"?
                      Colors.white
                          :
                      Colors.white,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 5, left: 5,bottom: 5, top:5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.motorcycle, color: Colors.white, size: 25,),
                                              //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                              documents["repa"] == "Nadie"?
                                              Colors.red[700]
                                                  :
                                              Colors.green[900]

                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                                width: 120,
                                                child: Text('Pedido #'+documents["folio"].toString(), textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),)),

                                            SizedBox(
                                                width: 120,
                                                child: Text(documents["estado3"], textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.brown),)),

                                          ],
                                        ),
                                        SizedBox(width: 10),
                                        SizedBox(
                                          width: 120.0,
                                          child: Column(
                                            children: [
                                              Text(documents["concepto"],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(color:Colors.brown)),
                                              SizedBox(height: 10,),
                                              Text("Tiempo "+documents["tiempodeespera"]+" | "+documents["hora"],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(color:Colors.grey)),
                                              documents["repa"] == "null"?
                                              Container()
                                                  :
                                              Text(documents["repa"], style: TextStyle(color: Colors.brown), maxLines: 1, overflow: TextOverflow.fade, softWrap: false),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //
                                    // InkWell(
                                    //onTap: (){

                                    //  _tiempoRecorrido(context, estado3, pendiente, transitopendiente, encamino, ensitio, finalizo, hora);

                                    //},
                                    //child: Icon(Icons.timer)
                                    //),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }
      ),
    );
  }
  var tiempo, empresa, coloniaNegocio, calleNegocio;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('¿Deseas cerrar la sesión?'),
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

                      signOut();
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

        //),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0,),
              listaPedidos(),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}

class OnelookLogoBarra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AssetImage assetImage = AssetImage('images/pizzeria.png');
    Image image = Image(image: assetImage, height: 33,);
    return Padding(
      padding: EdgeInsets.only(top:5),
      child: Container(child: image,),
    );
  }
}
