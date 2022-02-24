import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/gerencia_home_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/gerencia_home.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/gerencia_home_sheet.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/producto_detalle2.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/producto_detalle2.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo2.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class carpinteria_producto_detalle extends StatefulWidget {

  cajas_modelo2 product;
  carpinteria_producto_detalle(this.product);

  @override
  carpinteria_producto_detalleState createState() => carpinteria_producto_detalleState();
}

class carpinteria_producto_detalleState extends State<carpinteria_producto_detalle> {

  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
  CollectionReference reflistacajas = FirebaseFirestore.instance.collection('Cajas');
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
  Widget total4   (BuildContext context){
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

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: (){
                      _igualarACero(context, widget.product.newid);
                    },
                    child: Text('\$'+resultadof.toString(), style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),)),
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

    FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos"+correoPersonal.toString()).set  ({'notificacion': _myDocCount2.length.toString()});

    //CREO QUE AQUI VA LA CREACION DE UNA RUTA PARA EL REPARTIDOR POR NEGOCIO CON EL FOLIO



  }

  @override
  void initState() {
    // TODO: implement initState
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

  void _msjTipoDePago (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Elige un tipo de pago', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sheetCarrito(context) async {

    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(30)
        ),
        context: context,
        builder: (BuildContext bc){
          return Stack(
            children: [
              StatefulBuilder(
                builder: (BuildContext context, setState) =>  Padding(
                  padding: const EdgeInsets.only(right:20.0, left: 20.0, top: 20.0, bottom: 30.0),
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 150.0, left: 150.0),
                          child: Container(

                            color: Colors.grey,
                            child: Column(
                              children: <Widget>[
                                Divider(color: Colors.grey[400], height: 5.0,),
                                //Divider(color: Colors.black26,),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              widget.product.fecha == "recoger"?
                              Column(
                                children: [
                                  Text('Para recoger', style: TextStyle(color: Colors.red[800],fontSize: 35, fontWeight: FontWeight.bold)),
                                  SizedBox(
                                      width: 350,
                                      child: Text(widget.product.nombreProducto, style: TextStyle(color: Colors.red[800], fontSize: 25), textAlign: TextAlign.center)),
                                ],
                              )
                                  :
                              Column(
                                children: [
                                  Text('Tu pedido', style: TextStyle(color: Colors.red[800],fontSize: 35, fontWeight: FontWeight.bold)),
                                  Text(widget.product.foto, style: TextStyle(color: Colors.red[800],fontSize: 20)),
                                ],
                              ),
                              //Icon(Icons.cancel_outlined, color: Colors.black,),
                            ]
                        ),

                        widget.product.codigoDeBarra != ""?
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(widget.product.codigoDeBarra, style: TextStyle(fontSize: 25, color: Colors.red[800])),
                        )
                            :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                (context as Element).markNeedsBuild();
                              },
                              child:  Column(
                                children: text
                                    .map((t) => CheckboxListTile(
                                  title: Text(t),
                                  value: _isChecked,
                                  onChanged: (val) async {

                                    //final prefs = await SharedPreferences.getInstance();
                                    //prefs.setString('servicio', text.toString());

                                    setState(() {
                                      print("no palomita");
                                      _isChecked = val!;
                                      if(_isChecked == true){
                                        setState(() {
                                          //_sheetCarrito(context);
                                          print("palomita");

                                          tipodepago = text;
                                          FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({'concepto': "Efectivo"});

                                          _isChecked2 = false;
                                        });
                                      }
                                    });
                                  },
                                ))
                                    .toList(),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                (context as Element).markNeedsBuild();
                              },
                              child:  Column(
                                children: text2
                                    .map((t) => CheckboxListTile(
                                  title: Text(t),
                                  value: _isChecked2,
                                  onChanged: (val) async {

                                    //final prefs = await SharedPreferences.getInstance();
                                    //prefs.setString('servicio', text.toString());

                                    setState(() {
                                      print("no palomita");
                                      _isChecked2 = val!;
                                      if(_isChecked2 == true){
                                        setState(() {
                                          //_sheetCarrito(context);
                                          print("palomita");
                                          tipodepago = text2;
                                          FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({'concepto': "Tarjeta de Debito"});

                                          _isChecked = false;
                                        });
                                      }
                                    });
                                  },
                                ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:20.0, left:20.0, top: 20.0, bottom: 20.0),
                          child: Column(
                            children: [
                              //Text(widget.product.codigoDeBarra, style: TextStyle(fontWeight: FontWeight.bold),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Text('Subtotal: ', style: TextStyle(color: Colors.red[800], fontSize: 20.0),),
                                  subtotal(context),
                                ],
                              ),
                              SizedBox(height:10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Text('Servicio A Dom.: ', style: TextStyle(color: Colors.red[800], fontSize: 20.0),),
                                  servicioADomi(context),
                                ],
                              ),
                              SizedBox(height:12),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Text('Total: ', style: TextStyle(color: Colors.red[800], fontSize: 40.0, fontWeight: FontWeight.bold),),
                                    total(context),
                                  ]
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  widget.product.nombreProveedor == "CANCELADO"?
                  Container()
                  :
                  widget.product.fecha == "recoger"?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            color: Colors.red[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            child: Text('Finalizar', style: TextStyle(color: Colors.white,fontSize: 30.0),),
                            onPressed: () async {

                              //_msjVentaRealizada();

                              print("NEWID QUE QUIERO"+widget.product.newid);
                              //Toast.show("¡Venta finalizada!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                              FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({
                                'estado': 'Pagado',
                                'estado2': 'PAGADO',
                                'estado3': "PAGADO"
                                    "",
                              });

                              final prefst = await SharedPreferences.getInstance();

                              prefst.remove('totalProducto');

                              Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                              Navigator.of(context).pop(); //Te regresa a la pantalla anterior

                              //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3, precio,5,"","",foto,descripcion, newid, costoproducto))),);

                            },
                          ),
                        ),
                      ),
                    ],
                  )
                      :
                  widget.product.nombreProveedor == "Preparando"?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            color: Colors.red[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            child: Text('Finalizar', style: TextStyle(color: Colors.white,fontSize: 30.0),),
                            onPressed: () async {

                              //_msjVentaRealizada();

                              print("NEWID QUE QUIERO"+widget.product.newid);
                              //Toast.show("¡Venta finalizada!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                              FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({
                                'estado': 'Pagado',
                                'estado2': 'ENTREGADO',
                                'estado3': "ENTREGADO"
                                    "",
                              });

                              final prefst = await SharedPreferences.getInstance();

                              prefst.remove('totalProducto');

                              Navigator.of(context).pop();
                              Navigator.of(context).pop();


                              //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3, precio,5,"","",foto,descripcion, newid, costoproducto))),);

                            },
                          ),
                        ),
                      ),
                    ],
                  )
                      :
                  widget.product.nombreProveedor == "PEDIDO A DOMICILIO"?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            color: Colors.red[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            child: Text('Preparar', style: TextStyle(color: Colors.white,fontSize: 30.0),),
                            onPressed: () async {

                              double total = 0;
                              int folio;

                              FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('folio', isEqualTo: widget.product.folio).snapshots().listen((data) async {
                                data.docs.forEach((doc) async {
                                  //doc.reference.delete();
                                  //CREO QUE LA CLAVE ES MANDAR ESTEEste: TOTAL A PEDIDOS_INICIO

                                  total = total + doc['total'];
                                  //total = total + doc['totalProducto'];
                                  folio = doc['folio'];

                                  //SharedPreferences paso #1
                                  final prefst = await SharedPreferences.getInstance();
                                  prefst.setDouble('totalProducto', total);

                                  //IOSink sink = file.openWrite(mode: FileMode.writeOnlyAppend);

                                  //sink.add(utf8.encode(total.toString())); //Use newline as the delimiter
                                  //sink.writeln();
                                  //await sink.flush();
                                  //await sink.close();

                                });
                                //var now = new DateTime.now();
                                final prefst = await SharedPreferences.getInstance();
                                var totalreal = prefst.getDouble('totalProducto') ?? "";
                                double tot = totalreal.hashCode.toDouble();
                                //TOTAL RARO

                                double flete = widget.product.precioVenta;
                                FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({
                                  'totalNota': tot+flete,
                                });

                              });


                              Navigator.pop(context);
                              Navigator.pop(context);

                              print("NEWID QUE QUIERO"+widget.product.newid);
                              //Toast.show("¡Venta finalizada!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                              FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({
                                'estado': 'Preparando',
                                'estado2': 'PENDIENTE',
                                'estado3': "Preparando",
                                'estadorepa': 'sinasignar',
                              });

                              final prefst = await SharedPreferences.getInstance();

                              prefst.remove('totalProducto');

                              //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3, precio,5,"","",foto,descripcion, newid, costoproducto))),);

                            },
                          ),
                        ),
                      ),
                    ],
                  )
                      :
                  Container(),
                  SizedBox(height:20),
                ],
              ),
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

  Widget direccion (BuildContext context){
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

            String calle = userDocument["calle"];
            String colonia = userDocument["colonia"];
            String nombreCliente = userDocument["nombrecliente"];
            String tel = userDocument["tel"];
            String numext = userDocument["numext"];
            return
              colonia == null?
              Container()
                  :
              Column(
                children: [
                  Text(nombreCliente+" - $tel", style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),),
                  Text(colonia+", "+calle+ " #$numext", style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),),
                ],
              );

          }
        }
    );
  }

  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController _descripcion = TextEditingController();

  Widget _buildAboutDialogTi(BuildContext context) {
    return Form(
      key: _formKey3,
      child: Column(
        children: <Widget>[
          AlertDialog(
            backgroundColor: Colors.black,
            title: Text("Reportar pedido a La Festa Pizzas", style: TextStyle(color: Colors.black)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //tiempoDeEspera(context),
                Container(
                  color: Colors.black,
                  child: Column(
                    children: const <Widget>[
                      Divider(color: Colors.black, height: 10.0,),
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
                      color: Colors.black,
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
                        return 'Ingresa la descripcion del evento';
                      }
                      return null;
                    },
                    controller: _descripcion,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.assignment_late_rounded,
                          color: Colors.white),
                      hintText: 'Descripcion del evento',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            child: RaisedButton(
                              color: Colors.red[800],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('ENVIAR REPORTE', style: TextStyle(color: Colors.white),),
                              onPressed: () async {


                                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Soporte').orderBy('folio').get();
                                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                                final collRef = FirebaseFirestore.instance.collection('Soporte');
                                DocumentReference docReference = collRef.doc();

                                DateTime now = DateTime.now();
                                String formattedDate = DateFormat('kk:mm:ss').format(now);

                                docReference.set({
                                  'empresa': widget.product.empresa,
                                  'latitud': widget.product.latitud,
                                  'longitud': widget.product.longitud,
                                  'nombreCliente': widget.product.nombreProducto,
                                  'telefono': widget.product.estado,
                                  'hora': formattedDate,
                                  'descripcion': _descripcion.text,
                                  'folio': _myDocCount.length+1,
                                  'newid': docReference.id,
                                  'id': "987",
                                  'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                                  'visto': "no",
                                });

                                Navigator.of(context).pop();

                                Toast.show("Tu reporte ha sido enviado\n¡Nos comunicaremos contigo a la brevedad!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

                                _descripcion.clear();

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
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.black,
                child: const Text('Salir'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutDialoCam(BuildContext context, String foto) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: NetworkImage(foto)
                  ),
                  //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  void _borrarElemento (BuildContext context, String newid) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas borrar este producto?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
              },
            ),
            FlatButton(
              child: Text("Si"),
              onPressed: () async {

                FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').doc(newid).delete();
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  //correr la app y ver esta pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SpeedDial( //Boton flotante animado
        // both default to 16

        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
        elevation: 1.0,
        shape: CircleBorder(),
        children: [
          //SpeedDialChild(
          //child: Icon(Icons.add, color: Colors.white,),
          //backgroundColor: Colors.black,
          //label: 'Agregar Producto Manualmente',
          //onTap: () {

          //  showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context),);

          //Navigator.of(context).pushNamed('/alta_promociones');
          //  }
          //),
          SpeedDialChild(
              child: Icon(Icons.add_circle_outline, color: Colors.white,),
              backgroundColor: Colors.red[800],
              label: 'Agregar Producto',
              onTap: () {

                _sheetAgregarProd(context, widget.product.folio);
                //showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context),);

                //Navigator.of(context).pushNamed('/lista_insumos');
              }
          ),

        ],
      ),
      //floatingActionButton: FloatingActionButton(
      //backgroundColor: Colors.red[900],
      //child: Icon(Icons.add),
      //onPressed: (){
      //showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context),);
      //},
      //),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width, 50.0)),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pedido #"+widget.product.folio.toString(), style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[SizedBox(height:15),
                widget.product.foto == "[A Domicilio]"?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        direccion(context),
                      ],
                    ),
                  ],
                )
                    :
                Container(),
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

                              return InkWell(
                                onTap: () async{


                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => carpinteria_producto_detalle(cajas_modelo2("", "nombreProducto", "estadoc",0, 2,2, 0,0, "concepto", "estado3", "servicio", "tel","newid", 0.0, 134.54, 131.09, "empresa"))),);

                                  FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(documents["newid"]).update({
                                    'visto': 'si',
                                    'estado': 'Recibido',
                                  });

                                },
                                child: Card(
                                  color: Colors.white,
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
                                                          showDialog(context: context, builder: (BuildContext context) => _buildAboutDialoCam(context, documents["foto"]),);
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(50.0),
                                                          child: Container(
                                                            width: 70.0,
                                                            height: 100.0,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  fit: BoxFit.cover,
                                                                  image: NetworkImage(documents["foto"]),
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
                                                          SizedBox(
                                                            width: 200.0,
                                                            child: Text(
                                                              documents["nombreProducto"],
                                                              maxLines: 2,
                                                              overflow: TextOverflow.fade,
                                                              softWrap: true,
                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                                                            ),
                                                          ),
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children:[
                                                                SizedBox(
                                                                    width: 150,
                                                                    child: Text("Cantidad : "+documents["cantidad"].toString(),
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow.fade,
                                                                        softWrap: true,
                                                                        textAlign: TextAlign.left, style: TextStyle(color: Colors.black))),
                                                              ]
                                                          ),
                                                          SizedBox(height: 5),


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
                                                Text("\$"+documents["costo"].toString(), textAlign: TextAlign.left,style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                                                InkWell(
                                                    onTap:(){
                                                      int totalex = 0, res;
                                                      String newidproducto, numero;

                                                      _borrarElemento(context, documents["newid"]);

                                                      //ESTE BLOQUE BORRA EL PRODUCTO CUANDO LA CONSULTA DE EXISTENCIA ARROJA QUE ES IGUAL A CERO.

                                                    },
                                                    child: Icon(Icons.delete, color: Colors.red[300])),

                                              ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ,
                                ),
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

                  Container(
                    child: SizedBox(
                      child: RaisedButton(
                        color: Colors.red[800],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        child: Text('Ver Total', style: TextStyle(color: Colors.white),),
                        onPressed: () async {

                          //countDocuments();
                          double total = 0;
                          int folio;

                          FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('folio', isEqualTo: widget.product.folio).snapshots().listen((data) async {
                            data.docs.forEach((doc) async {
                              //doc.reference.delete();
                              //CREO QUE LA CLAVE ES MANDAR ESTEEste: TOTAL A PEDIDOS_INICIO

                              total = total + doc['totalProducto'];
                              //total = total + doc['totalProducto'];
                              folio = doc['folio'];

                              //SharedPreferences paso #1
                              final prefst = await SharedPreferences.getInstance();
                              prefst.setDouble('totalProducto', total);

                              //IOSink sink = file.openWrite(mode: FileMode.writeOnlyAppend);

                              //sink.add(utf8.encode(total.toString())); //Use newline as the delimiter
                              //sink.writeln();
                              //await sink.flush();
                              //await sink.close();

                            });
                            //var now = new DateTime.now();
                            final prefst = await SharedPreferences.getInstance();
                            var totalreal = prefst.getDouble('totalProducto') ?? "";
                            double tot = totalreal.hashCode.toDouble();

                            FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(widget.product.newid).update({
                              'totalNota': tot
                            });

                          });

                          _sheetCarrito(context);

                          final prefnom = await SharedPreferences.getInstance();
                          prefnom.remove('totalProducto');
                          //Toast.show("¡Pagado!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

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
