import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/pedidos_detalles.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/nota_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class reporte_ventas_direccion extends StatefulWidget {
  @override
  reporte_ventas_direccionState createState() => reporte_ventas_direccionState();
}

class reporte_ventas_direccionState extends State<reporte_ventas_direccion> {

  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference reflistadeventas = FirebaseFirestore.instance.collection('Pedidos_Jimena');
  CollectionReference reflistadegastos = FirebaseFirestore.instance.collection('Gastos');

  final TextEditingController _total = TextEditingController();
  final TextEditingController _concepto = TextEditingController();

  var sucursal;

  var category2;
  final _formKeyf = GlobalKey<FormState>();

  Widget _buildAboutDialog(BuildContext context) {
    return Form(
      key: _formKeyf,
      child: StatefulBuilder(
        builder: (BuildContext context, setState) =>  ListView(
          children: <Widget>[
            AlertDialog(
              title: Text("Alta de Gastos"),
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
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red,
                              blurRadius: 5
                          )
                        ]
                    ),
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: _concepto,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.person,
                          color: Colors.red[900],
                        ),
                        hintText: 'Concepto del Gasto',
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
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red,
                              blurRadius: 5
                          )
                        ]
                    ),
                    child: TextField(
                      controller: _total,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.person,
                          color: Colors.red[900],
                        ),
                        hintText: 'Total de Factura',
                      ),
                    ),
                  ),

                  SizedBox(height: 15.0,),
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
                                child: Text('Agregar Gasto', style: TextStyle(color: Colors.white),),
                                onPressed: () async {

                                  if (_formKeyf.currentState!.validate()) {
                                    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Gastos').orderBy('folio').get();
                                    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                                    final collRef = FirebaseFirestore.instance.collection('Gastos');
                                    DocumentReference docReference = collRef.doc();

                                    var now = DateTime.now();

                                    double total = double.parse(_total.text);
                                    //int cantidad = int.parse(_cantidadDeProducto.text);

                                    //double resultado = cantidad * costo;



                                    docReference.set({
                                      'total': total,
                                      'concepto': _concepto.text,
                                      'folio': _myDocCount.length+1,
                                      'newid': docReference.id,
                                      'id': "987",
                                      //'nombreProducto': nombreProducto,
                                      'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                                    });
                                    //countDocuments();
                                    //Navigator.of(context).pop();
                                    //_cantidadDeProducto.clear();
                                    //Toast.show("¡Agregado exitosamente!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

                                    _concepto.clear();
                                    _total.clear();
                                    Navigator.of(context).pop();

                                  }

                                  //DESPUES PONER LOS EXTRAS
                                  //_sheetExtras(context);

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
                  textColor: Theme.of(context).primaryColor,
                  child: const Text('Salir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
      category2 == "Gastos"?
      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red[900],
        onPressed: (){

          showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context),);

          print("Alta gastos");

        },
      )
      :
          Container(),
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        centerTitle: true,
        title: Text('Reportes')
      ),
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Expanded(
              child: StreamBuilder(
                //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                  stream: reflistadegastos.where("id", isEqualTo: "987").orderBy('miembrodesde', descending: true).orderBy('folio', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading..");
                    }
                    //reference.where("title", isEqualTo: 'UID').snapshots(),

                    else
                    {

                      Map<String, dynamic> documentsconfircarrito = snapshot.data! as Map<String, dynamic>;

                      String nombreProducto = documentsconfircarrito['nombreProducto'].toString();
                      String foto = documentsconfircarrito['foto'].toString();
                      String fecha = documentsconfircarrito['miembrodesde'].toString();
                      String newid = documentsconfircarrito['newid'].toString();
                      int folio = documentsconfircarrito['folio'];
                      int cantidad = documentsconfircarrito['cantidad'];
                      String sucursal = documentsconfircarrito['sucursal'].toString();
                      String concepto = documentsconfircarrito['concepto'].toString();
                      double totalNota = documentsconfircarrito['total'];

                      return ListTile(
                        title: Stack(
                          children: <Widget>[

                            Card(
                              color: Colors.green[700],
                              child: InkWell(
                                onLongPress: () async {

                                  //_borrarElemento(context, newid);

                                  _sheetTotalGasto(context, fecha, sucursal);

                                },

                                onTap:() async {

                                  //FALTA MOSTRAR EN LA PESTAÑA "MIS COMPRAS"
                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) => Pago_Detalles(Nota_Modelo(null, nombre,folio,cantidad, newid,direccion, totalNota, sucursal,0,0,"","",""))),);

                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text(fecha, style: TextStyle(color: Colors.white),)
                                      ],
                                    ),
                                    Text(concepto, style: TextStyle(color: Colors.white),),
                                    //Text(servicio, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                    Text('\$'+totalNota.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
                                  ],
                                ),
                              ),
                              elevation: 1.0,
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
            )

          ],
        ),
      ),
    );
  }
}

Future<void> _sheetTotalGasto(context, fecha, sucursal) async {

  double total = 0;

  FirebaseFirestore.instance.collection('Gastos').where('miembrodesde', isEqualTo: fecha).snapshots().listen((data) async {
    data.docs.forEach((doc) async {
      //CREO QUE LA CLAVE ES MANDAR ESTE TOTAL A PEDIDOS_INICIO

      total = total + doc['total'];
      //print("Total: "+total.toString());

      //SharedPreferences paso #1
      final prefst = await SharedPreferences.getInstance();
      prefst.setDouble('totalNotag', total);

      //IOSink sink = file.openWrite(mode: FileMode.writeOnlyAppend);

      //sink.add(utf8.encode(total.toString())); //Use newline as the delimiter
      //sink.writeln();
      //await sink.flush();
      //await sink.close();

    }
    );//var now = new DateTime.now();
  });

  //SharedPreferences paso #2
  final prefst = await SharedPreferences.getInstance();
  final totalreal = prefst.getDouble('totalNotag') ?? "";

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //AQUI WIDGET CON EL TOTAL
              Text('Fecha: '+fecha, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text('GASTO TOTAL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text(totalreal.toString(), style: TextStyle(fontSize: 25),),
            ],
          ),
        );
      }
  );
}

Future<void> _sheetTotalVentaDiaria(context, fecha, sucursal) async {

  double total = 0;

  FirebaseFirestore.instance.collection('Pedidos_Jimena').where('miembrodesde', isEqualTo: fecha).snapshots().listen((data) async {
    data.docs.forEach((doc) async {
      //CREO QUE LA CLAVE ES MANDAR ESTE TOTAL A PEDIDOS_INICIO

      total = total + doc['total'];
      //print("Total: "+total.toString());

      //SharedPreferences paso #1
      final prefst = await SharedPreferences.getInstance();
      prefst.setDouble('totalNota', total);

      //IOSink sink = file.openWrite(mode: FileMode.writeOnlyAppend);

      //sink.add(utf8.encode(total.toString())); //Use newline as the delimiter
      //sink.writeln();
      //await sink.flush();
      //await sink.close();

    }
    ); //var now = new DateTime.now();
  });

  //SharedPreferences paso #2
  final prefst = await SharedPreferences.getInstance();
  final totalreal = prefst.getDouble('totalNota') ?? "";

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //AQUI WIDGET CON EL TOTAL
              Text('Fecha: '+fecha, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text('VENTA TOTAL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text(totalreal.toString(), style: TextStyle(fontSize: 25),),
            ],
          ),
        );
      }
  );
}

class FirestoreListViewGastos extends StatelessWidget {

  final List<DocumentSnapshot> documentsconfircarrito;
  const FirestoreListViewGastos({required this.documentsconfircarrito});

  void _borrarElemento (BuildContext context, String newid) async {
    var category;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Borrar del carrito?', style: TextStyle(color: Colors.black)),
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

                FirebaseFirestore.instance.collection('Ventas').doc(newid).delete();

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documentsconfircarrito.length,
      itemExtent: 90.0, //Altura de cada renglon de la lista
      itemBuilder: (BuildContext context, int index) {
        String nombreProducto = documentsconfircarrito[index]['nombreProducto'].toString();
        String foto = documentsconfircarrito[index]['foto'].toString();
        String fecha = documentsconfircarrito[index]['miembrodesde'].toString();
        String newid = documentsconfircarrito[index]['newid'].toString();
        int folio = documentsconfircarrito[index]['folio'];
        int cantidad = documentsconfircarrito[index]['cantidad'];
        String sucursal = documentsconfircarrito[index]['sucursal'].toString();
        String concepto = documentsconfircarrito[index]['concepto'].toString();
        double totalNota = documentsconfircarrito[index]['total'];

        return ListTile(
          title: Stack(
            children: <Widget>[

              Card(
                color: Colors.green[700],
                child: InkWell(
                  onLongPress: () async {

                    //_borrarElemento(context, newid);

                    _sheetTotalGasto(context, fecha, sucursal);

                  },

                  onTap:() async {

                    //FALTA MOSTRAR EN LA PESTAÑA "MIS COMPRAS"
                    //await Navigator.push(context, MaterialPageRoute(builder: (context) => Pago_Detalles(Nota_Modelo(null, nombre,folio,cantidad, newid,direccion, totalNota, sucursal,0,0,"","",""))),);

                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(fecha, style: TextStyle(color: Colors.white),)
                        ],
                      ),
                      Text(concepto, style: TextStyle(color: Colors.white),),
                      //Text(servicio, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      Text('\$'+totalNota.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
                    ],
                  ),
                ),
                elevation: 1.0,
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
      },
    );
  }
}


