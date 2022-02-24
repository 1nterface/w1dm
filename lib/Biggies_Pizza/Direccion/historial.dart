import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/carpinteria.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/carpinteria_producto_detalle.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/historial_detalle.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class historial extends StatefulWidget {
  @override
  historialState createState() => historialState();
}

class historialState extends State<historial> {

  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Pedidos_Jimena');

  Future<void> pedidos (BuildContext context)async{

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Ventas').where('estado3', isEqualTo: "encamino").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Esto quiero: "+_myDocCount2.length.toString());

    FirebaseFirestore.instance.collection('Notificaciones').doc("Direccion_Pedidos").set({'notificacion': _myDocCount2.length.toString()});
  }

  var category;
  //FOLIO, NOMBRE, CELULAR, COLONIA, CALLE, NUMERO
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _colonia = TextEditingController();
  final TextEditingController _calle = TextEditingController();
  final TextEditingController _numero = TextEditingController();

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

  Future<void> _sheetCarrito(context) async {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text('Alta de Pedidos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.red,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: _nombre,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.star,
                        color: Colors.green[700],
                      ),
                      hintText: 'Nombre Cliente',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextField(
                    controller: _celular,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.star,
                        color: Colors.green[700],
                      ),
                      hintText: 'Celular',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: _colonia,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.star,
                        color: Colors.green[700],
                      ),
                      hintText: 'Colonia',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: _calle,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.star,
                        color: Colors.green[700],
                      ),
                      hintText: 'Calle',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextField(
                    controller: _numero,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.star,
                        color: Colors.green[700],
                      ),
                      hintText: 'Numero Exterior',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child:  OutlineButton(
                      onPressed: () async {

                        QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                        List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                        final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena');
                        DocumentReference docReference = collRef.doc();

                        var now = DateTime.now();

                        int celular = int.parse(_celular.text);
                        int numeroext = int.parse(_numero.text);

                        docReference.set({
                          'folio': _myDocCount.length+1,
                          'newid': docReference.id,
                          'id': "987",
                          'nombreProducto': _nombre.text,
                          'celular': celular,
                          'colonia': _colonia.text,
                          'calle': _calle.text,
                          'numeroext': numeroext,
                          'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                        });

                        Navigator.pop(context);

                      },
                      child: SizedBox(
                        width: 300,
                        child: Text('Registrar pedido', textAlign: TextAlign.center,),
                      ),
                      borderSide: BorderSide(color: Colors.green),
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          );
        }
    );
  }

  CollectionReference refpersonal = FirebaseFirestore.instance.collection('Personal_Registro');

  FirebaseAuth auth = FirebaseAuth.instance;

  void _ventanaFlotante(BuildContext context){
    TextEditingController _numeroMovil = TextEditingController();

    void inputData() async{

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final correoPersonal = user!.email;

      //SALASH2 PARA FOR ANTIGUO
      FirebaseFirestore.instance.collection('Clave').where("correo", isEqualTo: correoPersonal).get().then((snapshot) async {
        for (DocumentSnapshot doc in snapshot.docs) {

          var clave = doc['clave'];

          print(clave);

          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final uid = user!.uid;

          var uri = 'sms:+ '+_numeroMovil.text+'?body='+"Ingresa estos datos en tu registro.\n"+"Clave Unica: "+clave+"\n"+"Correo Empresa: "+correoPersonal.toString();
          if (await canLaunch(uri))
          {
            await launch(uri);
          }
          else
          {
            final FirebaseAuth auth = FirebaseAuth.instance;
            final User? user = auth.currentUser;
            final uid = user!.uid;
            // iOS
            var uri = _numeroMovil.text+clave;
            if (await canLaunch(uri))
            {
              await launch(uri);
            }
            else
            {
              throw 'Could not launch $uri';
            }
          }

        } //METODO THANOS FOR EACH

      });

    }

    Alert(
        context: context,
        title: "ENVIÓ DE CÓDIGO DE SEGURIDAD",
        content: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              controller: _numeroMovil,
              decoration: InputDecoration(
                icon: Icon(Icons.phone_android),
                labelText: 'Ingresa el número móvil',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              inputData();
              Navigator.pop(context);
            },
            child: Text(
              "Enviar código de seguridad",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  final TextEditingController _tel = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  signOut() async {
    await _auth.signOut();
  }

  var now = DateTime.now();

  Widget listaHistorial(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistaproduccion.where('correoNegocio', isEqualTo: correo).orderBy('folio', descending: true).snapshots(),
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
                    onLongPress: (){


                    },
                    onTap: () async{

                      await Navigator.push(context, MaterialPageRoute(builder: (context) => historial_detalle(cajas_modelo("", documents["tiempodeespera"],documents["tel"],documents["folio"],2,6862028991, 0, 777, documents["concepto"], documents["estado"], documents["tiempodeespera"],"", documents["newid"], 0))),);

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
                                              InkWell(
                                                  child: Icon(Icons.motorcycle, color: Colors.white, size: 25,),
                                                  onTap:(){
                                                    //_tiempoRecorrido(context, documents["estado3"], documents["pendiente"], documents["transitopendiente"], documents["encamino"], documents["ensitio"], documents["finalizo"], documents["hora"]);
                                                  }
                                              ),
                                              //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                              documents["repa"] == "Nadie"?
                                              Colors.red[700]
                                                  :
                                              Colors.green[800]

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
                                                child: Text(documents["totalNota"].toString(), textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.brown),)),

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
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width, 50.0)),
          ),          backgroundColor: Colors.red[800],
          centerTitle: true,
          title: Text("Ventas La Festa Pizzas", style: TextStyle(color: Colors.white)),
        ),

        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0,),

              listaHistorial(),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}