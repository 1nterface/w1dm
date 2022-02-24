
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class soporte_detalles extends StatefulWidget {

  cajas_modelo2 product;
  soporte_detalles(this.product);

  @override
  soporte_detallesState createState() => soporte_detallesState();
}

class soporte_detallesState extends State<soporte_detalles> {

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

            return Text('Total: \$'+costo.toString(), style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),);

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

  Future<void> _sheetCarrito(context) async {
    void _asignar(BuildContext context, String id, String nombreProducto, String correo, List<String> tipodepago) async {
      var category;
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text('¿Deseas confirmar tu eleccion?', style: TextStyle(color: Colors.black)),
            actions: <Widget>[

              FlatButton(
                onPressed: (){

                  Navigator.of(context).pop();

                },
                child: Text('Cancelar'),
              ),
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Si"),
                onPressed: () {

                  //Firestore.instance.collection('Carrito').document(id).delete();

                  //REVISAR TMB ESTE NEWIDD
                  FirebaseFirestore.instance.collection('Pedidos_Jimena').doc("newidd").update({
                    'repartidor': nombreProducto,
                    'correorepa': correo,
                    'estado': 'sinentregar',
                    'tipodepago': tipodepago,
                  });

                  Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                  Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                  Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                },
              ),
            ],
          );
        },
      );
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Elige un Repartidor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Expanded(
                  child: StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistarepas.where("id", isEqualTo: '123').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading..");
                        }
                        //reference.where("title", isEqualTo: 'UID').snapshots(),

                        else
                        {
                          Map<String, dynamic> documents = snapshot.data! as Map<String, dynamic>;

                          double costo  = documents['costoFactura'];
                          String foto = documents['foto'].toString();
                          String fecha = documents['miembrodesde'].toString();
                          String nombreProducto = documents['nombreProducto'].toString();
                          //String precio = documents['precioVenta'].toString();
                          int folio = documents['folio'];
                          double precio = documents['precio'];
                          int cantidad = documents['cantidad'];
                          String newid = documents['newid'].toString();
                          int existencia = documents['existencia'];
                          int minimo = documents['minimo'];
                          int maximo = documents['maximo'];
                          double totalcosto = documents['totalcosto'];
                          String tipodeempaque = documents['tipodeempaque'];
                          double costomp = documents['costomp'];
                          String nombreInsumo = documents['nombreInsumo'].toString();
                          double total = documents['total'];

                          return ListTile(
                            title: Stack(
                              children: <Widget>[
                                Card(
                                  child: InkWell(
                                    onLongPress: (){

                                    },

                                    onTap:() async {

                                      //await Navigator.push(context, MaterialPageRoute(builder: (context) => Proveedor_Detalles(Proveedor_Modelo(null,nombreProveedor ,"2" ,nombreProveedor ,rfc ,"5" ,fecha ,correoProveedor))),);
                                      //VER DE DONDE TRAER ESE CORREO Y DE QUIEN ES
                                      _asignar(context, newid, nombreProducto, "correo", tipodepago);

                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Icon(Icons.motorcycle, size: 30, color: Colors.purple[900],)
                                              ],
                                            ),
                                            Text(nombreProducto, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                                            //Text("\$"+total.toString()),
                                            SizedBox(width: 30.0),
                                            //Text(telefonoProveedor),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  elevation: 5,
                                ),
                              ],
                            ),
                            //onTap: (){

                            //Firestore.instance.runTransaction((transaction) async {
                            //DocumentSnapshot snapshot = await transaction.get(documentsconfir[index].reference);
                            //Firestore.instance.collection('Citas').document(snapshot.documentID).updateData({'estado': 'VentaRealizada'});
                            //});

                            //Firestore.instance.runTransaction((transaction) async {
                            //DocumentSnapshot snapshot = await transaction.get(documentsconfir[index].reference);
                            //await transaction.delete(snapshot.reference);
                            //});

                            //_crearRegistro();
                            //}
                          );
                        }
                      }
                  ),
                ),
                total(context),
              ],
            ),
          );
        }
    );
  }

  Future<void> _sheetAgregarProd(context) async {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Elige un producto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Expanded(
                  child: StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistacajas.where("id", isEqualTo: '987').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading..");
                        }
                        //reference.where("title", isEqualTo: 'UID').snapshots(),

                        else
                        {
                          Map<String, dynamic> documents = snapshot.data! as Map<String, dynamic>;

                          int cantidad = documents['cantidad'];
                          String foto = documents['foto'].toString();
                          String fecha = documents['miembrodesde'].toString();
                          String nombreProducto = documents['nombreProducto'].toString();
                          double precio = documents['costo'];
                          int folio = documents['folio'];
                          String newid = documents['newid'].toString();
                          int existencia = documents['existencia'];
                          double costoproducto = documents['costoProducto'];
                          String descripcion = documents['descripcion'].toString();

                          int decimals = 2;
                          num fac = pow(10, decimals);
                          double costo = costoproducto;
                          costo = (costo * fac).round() / fac;

                          return ListTile(
                              title: Card(
                                elevation: 7.0,
                                color: Colors.white,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(foto)
                                                ),
                                                //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                color: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left:20),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: Text(nombreProducto, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black45),),
                                                      //height: 30,
                                                      width: 180,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: Text(descripcion, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black26),),
                                                      //height: 30,
                                                      width: 180,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top:20),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        child: Text("\$"+costoproducto.toString(), style: TextStyle(color: Colors.blue[900], fontSize: 20),),
                                                        //height: 30,
                                                        width: 180,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onLongPress: (){

                                //_borrarElemento(context, nombreProducto, existencia, newid);

                              },
                              onTap: () async{

                                //showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog2(context, nombreProducto, precio),);

                              }
                          );
                        }
                      }
                  ),
                ),
              ],
            ),
          );
        }
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
              mapType: MapType.satellite,
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
        backgroundColor: Colors.purple[900],
        title: Text("Soporte"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                margin: EdgeInsets.only(top: 15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Reporte de ",
                      style: TextStyle(fontSize: 20,color: Colors.black),
                      children: [
                        TextSpan(
                          //recognizer: ,
                          text: widget.product.empresa,
                          style: TextStyle(color: Colors.purple[900], fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:               Container(
              width: 200,
              margin: EdgeInsets.only(top: 15),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Usuario reportado ",
                    style: TextStyle(fontSize: 15,color: Colors.black),
                    children: [
                      TextSpan(
                        //recognizer: ,
                        text: widget.product.nombreProducto,
                        style: TextStyle(color: Colors.purple[900], fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("\""+widget.product.codigoDeBarra+"\"", textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("Ubicacion GPS del usuario", textAlign: TextAlign.center),
                InkWell(
                  onTap:(){
                    _sheetMapa(context);
                  },
                    child: Icon(Icons.location_pin, color: Colors.red[700], size: 40)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
