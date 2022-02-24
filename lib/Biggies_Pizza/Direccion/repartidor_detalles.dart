import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/agentes_modelo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'repartidor_detalles.dart';

class repartidor_detalles extends StatefulWidget {

  agentes_modelo product;
  repartidor_detalles(this.product);

  @override
  repartidor_detallesState createState() => repartidor_detallesState();
}

class repartidor_detallesState extends State<repartidor_detalles> {

  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Repartidores_Entregas');

  void calcular (BuildContext context, int resultadoshared) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Total a pagar: \$'+resultadoshared.toString(), style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Aceptar"),
              onPressed: () async {

                //SharedPreferences preferences = await SharedPreferences.getInstance();
                //await preferences.remove('resultado');

                //print(resultadoshared);

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

                //Firestore.instance.collection('Cajas').document(newid).delete();

              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          backgroundColor: Colors.green[900],
          centerTitle: true,
          title: Text('Repartidores')
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                  //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                    stream: reflistaproduccion.where("repartidor", isEqualTo: widget.product.nombreAgente).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if (!snapshot.hasData) {
                        return Text("Loading..");
                      }
                      //reference.where("title", isEqualTo: 'UID').snapshots(),

                      else
                      {
                        return FirestoreListViewProduccion(documents: snapshot.data!.docs);
                      }
                    }
                ),
              ),

              //Container(
                //child: SizedBox(
                  //child: RaisedButton(
                    //color: Colors.red[900],
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    //child: Column(
                      //children: <Widget>[
                        //Text('Calcular', style: TextStyle(color: Colors.white),),
                        //Icon(Icons.monetization_on, color: Colors.white,),
                      ////],
                    //),
                    //onPressed: () async {

                      //final prefs5 = await SharedPreferences.getInstance();
                      //final resultadoshared = prefs5.getInt('resultado') ?? "";

                      //calcular(context, resultadoshared);

                    //},
                  //),
                //),
              //),

            ],
          ),
        ],
      ),
    );
  }
}

class FirestoreListViewProduccion extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  const FirestoreListViewProduccion({required this.documents});

  void _borrarElemento (BuildContext context, String nombreProd, int existencia, String newid) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas borrar $nombreProd?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

                FirebaseFirestore.instance.collection('Cajas').doc(newid).delete();

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
      itemCount: documents.length,
      itemExtent: 120.0, //Crea el espacio entre cada renglon
      itemBuilder: (BuildContext context, int index) {

        String cantidad = documents[index]['cantidad'].toString();
        String foto = documents[index]['foto'].toString();
        String fecha = documents[index]['fecha'].toString();
        String nombre = documents[index]['repartidor'].toString();
        String precio = documents[index]['costo'].toString();
        int folio = documents[index]['folio'];
        String newid = documents[index]['newid'].toString();
        int totalentregas = documents[index]['total_entregas'];
        double costoproducto = documents[index]['costoProducto'];

        int costo = 5; //5 PESOS QUE PIZZA RING PAGA POR ENTREGA AL REPARTIDOR
        int resultado = costo * totalentregas;

        return ListTile(
            title: Card(
              elevation: 7.0,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          Text("Total de entregas: "+totalentregas.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(fecha, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: 90.0,
                              height: 90.0,
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

                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:10),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("Total en efectivo: ", style: TextStyle(fontSize: 25.0),),
                            Text("\$"+resultado.toString()+".00 m.n.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                            //SizedBox(height: 30.0,),Text('Costo'),
                            //Text(costo.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            //SizedBox(height: 30.0,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onLongPress: (){

              _borrarElemento(context, nombre, totalentregas, newid);
            },
            onTap: () async{

              //await Navigator.push(context, MaterialPageRoute(builder: (context) => Repartidor_Detalles(Agentes_Modelo(null, nombre,"", "","", foto))),);

              //SharedPreferences paso #1
              //final prefst = await SharedPreferences.getInstance();
              //prefst.setInt('resultado', resultado);

              //print(resultado);

            }
        );
      },
    );
  }
}