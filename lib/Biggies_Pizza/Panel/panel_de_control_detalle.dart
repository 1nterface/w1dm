import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/gerencia_home.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/gerencia_home_sheet.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/producto_detalle2.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/producto_detalle2.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/panel_pedido_modelo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class panel_de_control_detalle extends StatefulWidget {

  panel_pedido_modelo product;
  panel_de_control_detalle(this.product);

  @override
  panel_de_control_detalleState createState() => panel_de_control_detalleState();
}

class panel_de_control_detalleState extends State<panel_de_control_detalle> {

  CollectionReference reflistaproduccionotros = FirebaseFirestore.instance.collection('Insumos_Otros');
  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
  CollectionReference reflistacajasinsumos = FirebaseFirestore.instance.collection('Cajas_Insumos');
  CollectionReference reflistacajas = FirebaseFirestore.instance.collection('Cajas');
  CollectionReference reflistadecarrito = FirebaseFirestore.instance.collection('Ingredientes');
  CollectionReference reflistarepas = FirebaseFirestore.instance.collection('Repartidor_Registro');

  final TextEditingController _producto = TextEditingController();
  final TextEditingController _cantidad = TextEditingController();
  final TextEditingController _precio = TextEditingController();

  void _igualarACero (BuildContext context, String newid) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas igualar a cero el total?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () {

                FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(newid).update({
                  'totalNota': 0.0,
                  'estado3': 'PENDIENTE',
                  'concepto': '',
                });
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior


              },
            ),
          ],
        );
      },
    );
  }

  Widget total (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);

            //HAY UN PEDO CON EL TOTAL DE LA NOTA, VERL QUE HACER
            // ENTRE RESCATE Y PEDIDO EN LINEA
            double flete2 = data["flete"];
            double resultadof = 0;

            double costo = data["totalNota"];
            costo = (costo * fac).round() / fac;
            resultadof = flete2 + costo;
            resultadof = (resultadof * fac).round() / fac;
            return Text('\$'+resultadof.toString(), style: TextStyle(color: Colors.grey[600], fontSize: 40.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }
  Widget total4   (BuildContext context){
    return StreamBuilder(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);

            //HAY UN PEDO CON EL TOTAL DE LA NOTA, VERL QUE HACER
            // ENTRE RESCATE Y PEDIDO EN LINEA
            double costo = userDocument["totalNota"];
            costo = (costo * fac).round() / fac;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: (){
                      _igualarACero(context, widget.product.newid);
                    },
                    child: Text('\$'+costo.toString(), style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),)),
              ],
            );

          }
        }
    );
  }

  Future<void> pedidos (BuildContext context)async{

    var now = DateTime.now();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correoNegocio', isEqualTo: correoPersonal).where("visto", isEqualTo: "no").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Notificacion: "+_myDocCount2.length.toString());

    FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos"+correoPersonal.toString()).set ({'notificacion': _myDocCount2.length.toString()});

    //CREO QUE AQUI VA LA CREACION DE UNA RUTA PARA EL REPARTIDOR POR NEGOCIO CON EL FOLIO
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.product.estado);
    total(context);
    total4(context);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    total(context);
    total4(context);
    pedidos(context);

    super.dispose();
  }

  var category;
  final _formKey = GlobalKey<FormState>();


  bool ropa = true, zapatos = true, bolsas = true, filtro = false, filtro2 = false;


  Widget subtotal (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);
            double costo = data["totalNota"];
            costo = (costo * fac).round() / fac;

            return Text('\$'+costo.toString(), style: TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }
  Widget servicioADomi (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);
            double flete = data["flete"];

            return Text('\$'+flete.toString(), style: TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }
  Widget totalbn (BuildContext context){
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);

            //HAY UN PEDO CON EL TOTAL DE LA NOTA, VERL QUE HACER
            // ENTRE RESCATE Y PEDIDO EN LINEA
            double flete2 = data["flete"];
            double resultadof = 0;

            double costo = data["totalNota"];
            costo = (costo * fac).round() / fac;
            resultadof = flete2 + costo;
            resultadof = (resultadof * fac).round() / fac;
            return Text('\$'+resultadof.toString(), style: TextStyle(color: Colors.grey[600], fontSize: 40.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }

  Future<void> _sheetCarrito(context) async {

    showModalBottomSheet(
        shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(30)
        ),
        context: context,
        builder: (BuildContext bc){
          return Stack(
            children: [

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        widget.product.coloniaNegocio == "recoger"?
                        Column(
                          children: [
                            Text("Recoleccion", style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
                            SizedBox(
                                width: 350,
                                child: Text("Cliente "+widget.product.foto, style: TextStyle(fontSize: 25), textAlign: TextAlign.center)),
                          ],
                        )
                            :
                        SizedBox(
                            width: 350,
                            child: Text("Direccion de "+widget.product.foto, style: TextStyle(fontSize: 25), textAlign: TextAlign.center)),
                        widget.product.coloniaNegocio == "recoger"?
                        Container()
                            :
                        Row(
                          children:[
                            SizedBox(height:10),
                            Text(widget.product.numextNegocio.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ]
                        )
                      ]
                  ),
                ]
              ),
              Padding(
                padding: const EdgeInsets.only(right:20.0, left:20.0, top: 20.0, bottom: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Text(widget.product.codigoDeBarra, style: TextStyle(fontWeight: FontWeight.bold),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text('Subtotal: ', style: TextStyle(color: Colors.black, fontSize: 20.0),),
                        widget.product.nombreProveedor != "rescatesolicitado"?
                        subtotal(context)
                            :
                        subtotal(context),
                      ],
                    ),
                    SizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text('Servicio A Dom.: ', style: TextStyle(color: Colors.black, fontSize: 20.0),),
                        servicioADomi(context),                                ],
                    ),
                    SizedBox(height:12),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Total: ', style: TextStyle(color: Colors.grey[500], fontSize: 40.0, fontWeight: FontWeight.bold),),
                          widget.product.nombreProveedor != "rescatesolicitado"?
                          totalbn(context)
                              :
                          totalbn(context),
                        ]
                    ),
                  ],
                ),
              ),
              //AQUI DIRECCION DE CLIENTE

            ],
          );
        }
    );
  }

  Future<void> _sheetAgregarProd(context, int folio) async {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return gerencia_home_sheet(folio);
        }
    );
  }


  bool _isChecked = false, _isChecked2 = false;
  List<String> text = ["Efectivo"];
  List<String> text2 = ["Tarjeta de Debito"];
  var tipodepago, category2;

  Future<void> _direccionPedidoNegocio(context) async {

    showModalBottomSheet(
        shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(30)
        ),
        context: context,
        builder: (BuildContext bc){
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                Text("Direccion de cliente", style: TextStyle(fontSize: 30)),
                Text(widget.product.numextNegocio.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ]
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width, 50.0)),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: InkWell(
          onTap:(){

            //_direccionPedidoNegocio(context);

          },
          child: Column(
            children: [
              Text("Pedido #"+widget.product.folio.toString(), style: TextStyle(color: Colors.white)),
              Text(widget.product.fecha, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[SizedBox(height:15),
                widget.product.nombreProveedor == "rescatesolicitado"?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Tipo de Servicio", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
                        Container(
                            color: Colors.black,
                            child: Text(widget.product.estado, style: TextStyle(fontSize: 40, color: Colors.white))),

                        SizedBox(height: 20,),
                        Text("Costo", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
                        Container(
                            color: Colors.black,
                            child: Text("\$"+widget.product.costoProducto.toString(), style: TextStyle(fontSize: 40, color: Colors.white))),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ],
                )
                    :
                Expanded(
                  child: StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistaproduccion.where('folio', isEqualTo: widget.product.folio).snapshots(),
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

                              return Card(
                                elevation: 1.0,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[
                                          Row(
                                              children:[
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap:(){
                                                        //showDialog(context: context, builder: (BuildContext context) => _buildAboutDialoCam(context, foto),);
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: Container(
                                                          width: 70.0,
                                                          height: 100.0,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit.cover,
                                                                image: NetworkImage(documents["foto"])
                                                            ),
                                                            //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                            color: Colors.transparent,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width:10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children:[
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children:[
                                                            SizedBox(
                                                              width: 150.0,
                                                              child: Text(
                                                                documents["nombreProducto"],
                                                                maxLines: 1,
                                                                overflow: TextOverflow.fade,
                                                                softWrap: false,
                                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children:[
                                                              SizedBox(
                                                                  width: 150,
                                                                  child: Text("Cantidad : "+documents["cantidad"].toString(), textAlign: TextAlign.left, style: TextStyle(color: Colors.grey))),
                                                            ]
                                                        ),
                                                        SizedBox(height: 5),

                                                        //Row(
                                                        //  mainAxisAlignment: MainAxisAlignment.start,
                                                        //children:[
                                                        //Container(
                                                        //  width: 150,
                                                        //child: Text('Medida : '+medida, textAlign: TextAlign.left, style: TextStyle(color: Colors.grey))),
                                                        //]
                                                        //),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ]
                                          ),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(right:5.0, left: 5.0, top:15, bottom:10),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children:[
                                              Text("\$"+documents["costo"].toString(), textAlign: TextAlign.left,style: TextStyle(color: Colors.brown, fontSize: 15, fontWeight: FontWeight.bold)),

                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ) ,
                              );
                            }).toList(),
                          );
                        }
                      }
                  ),
                ),

                //Image.network(widget.product.foto),
              ],
            ),
          ),
          //ACOMODAR BIEN LA LISTA DE INGREDIENTES
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      widget.product.nombreProveedor == "CANCELADO"?
                      Container()
                          :
                      widget.product.nombreProveedor == "PAGADO"?
                      Container()
                          :
                      Container(),
                      //Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //                  children: [
    //                    Container(
    //                      child: SizedBox(
    //                        width: 200,
    //                        height: 50,
    //                        child: RaisedButton(
    //                          color: Colors.orange[900],
    //                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    //                          child: Text('Asignar', style: TextStyle(color: Colors.white,fontSize: 30.0),),
    //                          onPressed: () async {

    //                           _sheetCarrito(context);

                                  //                          },
    //                        ),
    //                      ),
    //                    ),
    //  ],
                      //),
                      SizedBox(height:20),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    child: SizedBox(
                      child: RaisedButton(
                        color: Colors.red[800],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        child: Text('Ver Total', style: TextStyle(color: Colors.white),),
                        onPressed: () async {


                          _sheetCarrito(context);

                          //METODO THANOSCOLECCION PARA BORRAR TOODA UNA COLECCION CON UNA CONDICION Y CON UN BOTON
                          //Firestore.instance.collection('Carrito').where('id', isEqualTo: '987').getDocuments().then((snapshot) {
                          //for (DocumentSnapshot doc in snapshot.documents) {
                          //doc.reference.delete();
                          //print('borrado');
                          //}
                          //})

                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}