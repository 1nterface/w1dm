
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/nota_modelo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class pedidos_detalles_repartidor extends StatefulWidget {

  nota_modelo product;
  pedidos_detalles_repartidor(this.product);

  @override
  pedidos_detalles_repartidorState createState() => pedidos_detalles_repartidorState();
}

class pedidos_detalles_repartidorState extends State<pedidos_detalles_repartidor> {

  CollectionReference reflistaproduccionotros = FirebaseFirestore.instance.collection('Insumos_Otros');
  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
  CollectionReference reflistacajasinsumos = FirebaseFirestore.instance.collection('Cajas_Insumos');
  CollectionReference reflistacajas = FirebaseFirestore.instance.collection('Cajas');
  CollectionReference reflistadecarrito = FirebaseFirestore.instance.collection('Ingredientes');
  CollectionReference reflistarepas = FirebaseFirestore.instance.collection('Repartidor_Registro');

  final TextEditingController _producto = TextEditingController();
  final TextEditingController _cantidad = TextEditingController();
  final TextEditingController _precio = TextEditingController();


  Widget total (BuildContext context){
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
            double costo = userDocument["total"];
            costo = (costo * fac).round() / fac;

            return Text('Total: \$'+costo.toString(), style: const TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }

  @override
  void initState() {

    widget.product.latitud == null && widget.product.longitud == null?
        print('no hay')
        :
    allMarkers.add(Marker(
        markerId: MarkerId('Cliente'),
        draggable: true,
        onTap: () {
          print('');
        },
        position: LatLng(widget.product.latitud, widget.product.longitud)
    ),);

    // TODO: implement initState
    print("newid"+widget.product.newid);
    total(context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    total(context);
    super.dispose();
  }

  var category;
  final _formKey = GlobalKey<FormState>();

  Widget _buildAboutDialog(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          AlertDialog(
            title: Text("Agregar producto"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.black45,
                  child: Column(
                    children: const <Widget>[
                      Divider(color: Colors.white10, height: 10.0,),
                      //Divider(color: Colors.black26,),
                    ],
                  ),
                ),

                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe el producto';
                      }
                      return null;
                    },
                    controller: _producto,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.phone_android,
                        color: Colors.black,
                      ),
                      hintText: 'Producto',
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe la cantidad';
                      }
                      return null;
                    },
                    controller: _cantidad,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Cantidad',
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe el precio';
                      }
                      return null;
                    },
                    controller: _precio,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.attach_money,
                        color: Colors.black,
                      ),
                      hintText: 'Precio',
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            child: RaisedButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Agregar', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').orderBy('folio').get();
                                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                                final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
                                DocumentReference docReference = collRef.doc();

                                var now = DateTime.now();

                                double precio = double.parse(_precio.text);
                                int cantidad = int.parse(_cantidad.text);

                                double total = cantidad * precio;

                                docReference.set({
                                  'folio': widget.product.folio,
                                  'newid': docReference.id,
                                  'id': "987",
                                  'nombreProducto': _producto.text,
                                  'precio': precio,
                                  'cantidad': cantidad,
                                  'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                                  'total': total,
                                });

                                Navigator.pop(context);

                                _producto.clear();
                                _precio.clear();
                                _cantidad.clear();

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    //Image.network(foto, height: 250,),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Theme.of(context).primaryColor,
                child: const Text('Salir'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isChecked = false, _isChecked2 = false;
  List<String> text = ["Efectivo"];
  List<String> text2 = ["Tarjeta de Debito"];
  var tipodepago;
  List<Marker> allMarkers = [];
  late GoogleMapController _controller;



  void mapCreated(controller) {


    setState(() {
      _controller = controller;
    });
  }

  Future<void> _sheetMapa(context) async {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:
              CameraPosition(target: LatLng(widget.product.latitud, widget.product.longitud), zoom: 19.5),
              markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            ),
          );
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
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            int decimals = 2;
            num fac = pow(10, decimals);

            //HAY UN PEDO CON EL TOTAL DE LA NOTA, VERL QUE HACER
            // ENTRE RESCATE Y PEDIDO EN LINEA
            double flete2 = userDocument["flete"];
            double resultadof = 0;

            double costo = userDocument["totalNota"];
            costo = (costo * fac).round() / fac;
            resultadof = flete2 + costo;
            return Text('\$'+costo.toString(), style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),);

          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //floatingActionButton: FloatingActionButton(
      //backgroundColor: Colors.red[900],
      //child: Icon(Icons.location_pin),
      //onPressed: (){

        //print(widget.product.latitud);
        //print(widget.product.longitud);
        //_sheetCarrito2(context);
        //showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context),);
      //},
      //),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: Column(
          children: [
            Text("Pedido #"+widget.product.folio.toString()),
            totalbn(context),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.product.foto, style: TextStyle(color: Colors.red[800], fontSize: 30, fontWeight: FontWeight.bold),),

                        widget.product.latitud == null && widget.product.longitud == null?
                        Row(
                          children: [
                            Text(widget.product.direccion+" #"+widget.product.cantidad.toString()+", "+widget.product.formadepago, style: TextStyle(fontSize: 20),),
                            InkWell(
                              onTap: () async {
                                Clipboard.setData(ClipboardData(text: widget.product.direccion+" "+widget.product.cantidad.toString()+","+widget.product.formadepago));

                                const url = "https://goo.gl/maps/";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }

                              },
                              child: Icon(Icons.copy, color: Colors.red[800], size: 25,),
                            ),

                          ],
                        )
                            :
                        InkWell(
                          onTap: () async {

                            _sheetMapa(context);

                          },
                          child: Icon(Icons.location_pin, color: Colors.red[800], size: 25,),
                        ),
                      ],
                    ),
                  ],
                ),

                Text(widget.product.tel, style: TextStyle(fontWeight: FontWeight.bold),),
                //total(context),
                Container(
                  height: 30,
                  color: Colors.black12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const <Widget>[
                            Text('Articulo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            Text('Cantidad', style: TextStyle(fontSize:  15, fontWeight: FontWeight.bold),),
                            Text('Total', style: TextStyle(fontSize:  15, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
          widget.product.sucursal == "ENTREGADO"?

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  SwipingButton(
                    swipeButtonColor: Colors.red,
                    backgroundColor: Colors.black,
                    height: 60,
                    text: "TRANSITO PENDIENTE", onSwipeCallback:() {

                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('kk:mm:ss').format(now);

                    FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({
                      'estado3': 'TRANSITO PENDIENTE',
                      'transitopendiente': formattedDate,

                    });

                    Navigator.pop(context);
                  },
                  ),
                ],
              ),
              SizedBox(height: 30,),

            ],
          )
          :
          widget.product.sucursal == "TRANSITO PENDIENTE"?

          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SwipingButton(
                    swipeButtonColor: Colors.red,
                    backgroundColor: Colors.black,
                    height: 60,
                    text: "EN CAMINO", onSwipeCallback:() {

                    DateTime now = DateTime.now();
                    String formattedDate = DateFormat('kk:mm:ss').format(now);

                    FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({
                      'estado3': 'EN CAMINO',
                      'encamino': formattedDate,

                    });
                    Navigator.pop(context);
                  },
                  ),
                ],
              ),
                SizedBox(height: 30,),

              ]
          )
              :

          widget.product.sucursal == "EN CAMINO"?

          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      child: SizedBox(
                        child: SwipingButton(
                          swipeButtonColor: Colors.red
                          ,
                          backgroundColor: Colors.black,
                          height: 60,
                          text: "EN SITIO", onSwipeCallback:() {

                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat('kk:mm:ss').format(now);

                          FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({
                            'estado3': 'EN SITIO',
                            'ensitio': formattedDate,

                          });
                          Navigator.pop(context);

                        },
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30,),
              ]
          )
              :
          widget.product.sucursal == "PAGADO"?

        Container()
          :
          widget.product.sucursal == "Preparando"?
          Container()
              :
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      child: SizedBox(
                        child: SwipingButton(
                          swipeButtonColor: Colors.red,
                          backgroundColor: Colors.black,
                          height: 60,
                          text: "COMPLETADO", onSwipeCallback:() {

                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat('kk:mm:ss').format(now);

                          FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({
                            'estado3': 'PAGADO',
                            'estado2': 'PAGADO',
                            'finalizo': formattedDate,
                            'estadorepa': 'terminado',

                          });

                          Navigator.pop(context);

                        },
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30,),
              ]
          )
        ],
      ),
    );
  }
}