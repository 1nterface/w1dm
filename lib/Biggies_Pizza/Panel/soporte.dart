import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:w1dm/Biggies_Pizza/Panel/soporte_detalles.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo2.dart';
//Pedidos_Detalles_Repartidor


class soporte extends StatefulWidget {
  @override
  _soporteState createState() => _soporteState();
}

class _soporteState extends State<soporte> {

  CollectionReference reflistadecarrito = FirebaseFirestore.instance.collection('Soporte');

  bool americana = false, italiana = false, sushi = false, mexicana = false, alitas = false;


  var now = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }

  void _borrarElemento (BuildContext context, correoRestaurante) async {
    var category;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas borrar a tu socio de manera permanente?', style: TextStyle(color: Colors.black)),
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
              onPressed: () async {
                FirebaseFirestore.instance.collection('Socios_Registro').doc(correoRestaurante).delete();

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
          ],
        );
      },
    );
  }

  Widget soporte(BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;
    return StreamBuilder(
      //Asi encontraremos los negocios por ciudad y sin problemas con la BD
        stream: reflistadecarrito.where('id', isEqualTo: "987").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading..");

          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {

            Map<String, dynamic> documentsconfircarrito = snapshot.data! as Map<String, dynamic>;

            String nombreCliente = documentsconfircarrito['nombreCliente'].toString();
            String foto = documentsconfircarrito['foto'].toString();
            String correoRestaurante = documentsconfircarrito['correo'].toString();
            String rfc = documentsconfircarrito['rfc'].toString();
            String fecha = documentsconfircarrito['fecha'].toString();
            String newid = documentsconfircarrito['newid'].toString();
            String cantidad = documentsconfircarrito['cantidad'].toString();
            double total = documentsconfircarrito['totalProducto'];
            String tipo = documentsconfircarrito['tipo'].toString();
            String empresa = documentsconfircarrito['empresa'].toString();
            String descripcion = documentsconfircarrito['descripcion'].toString();
            String codigodebarra = documentsconfircarrito['codigo'].toString();
            int entrada  = documentsconfircarrito['entrada'];
            int folio  = documentsconfircarrito['folio'];
            int salida  = documentsconfircarrito['salida'];
            int minutosSalida  = documentsconfircarrito['minutosSalida'];
            String colonia = documentsconfircarrito['colonia'].toString();
            String calle = documentsconfircarrito['calle'].toString();
            int numero = documentsconfircarrito['numero'];
            String visto = documentsconfircarrito['visto'].toString();
            double latitud = documentsconfircarrito['latitud'];
            double longitud = documentsconfircarrito['longitud'];
            String tel = documentsconfircarrito['tel'].toString();
            String estado3 = documentsconfircarrito['estado3'].toString();
            String servicio = documentsconfircarrito['servicio'].toString();
            String concepto = documentsconfircarrito['concepto'].toString();
            double flete = documentsconfircarrito['flete'];
            String nombreProducto = documentsconfircarrito['nombreProducto'].toString();
            String estadoc = documentsconfircarrito['estadoc'].toString();
            return ListTile(
                title: Card(
                  elevation: 1.0,
                  color:
                  visto == "no"?
                  Colors.grey[200]
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
                                                //_tiempoRecorrido(context, estado3, pendiente, transitopendiente, encamino, ensitio, finalizo, hora);
                                              }
                                          ),
                                          //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black

                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(width: 120, child: Text('Reporte # '+folio.toString(), textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),)),

                                        SizedBox(width: 140, child: Text(empresa, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),)),

                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 120.0,
                                      child: Column(
                                        children: const [
                                          //Text(tipodepago, maxLines: 1, overflow: TextOverflow.fade, softWrap: false, style: TextStyle(color:Colors.yellow[700])),
                                          SizedBox(height: 10,),
                                          //Text("Tiempo "+tiempo+" | "+hora, maxLines: 1, overflow: TextOverflow.fade, softWrap: false, style: TextStyle(color:Colors.grey)), //Text(repa, maxLines: 1, overflow: TextOverflow.fade, softWrap: false),

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

                onLongPress: (){

                  _borrarElemento(context, newid);
                },

                onTap: () async{

                  //PASAR LA INFO NECESARIA A OTRA CLASE QUE HAY QUE HACER NUEVA
                  //ME ACUERDO CUANDO PISTEABAMOS CON EL BOXIA EN LA MADRUGADA CON MI CARNAL JAJA
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => soporte_detalles(cajas_modelo2("", nombreCliente, estadoc,folio, 2,2, flete,numero, descripcion, estado3, servicio, tel,newid, total, latitud, longitud, empresa))),);

                  //Firestore.instance.collection('Pedidos_Jimena').document(newid).updateData({'visto': 'si'});

                  //YA REGISTRA CORRECTAMENTE LAS NOTIFICACIONES, TMB LAS BORRA AL DARLE CLIC
                  //FALTA MOSRTRARLO EN BADGE
                  print("aqui");
                }
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[900],
        child: Icon(Icons.business),
        onPressed: (){

          Navigator.of(context).pushNamed('/alta_socios');

          //showDialog(context: context, builder: (BuildContext context) =>  altaNuevaNota(context));

          //_sheetCarrito(context);
        },
      ),
      body: Column(
        children: [

          Expanded(
            child: soporte(context),
          ),
        ],
      ),
    );
  }
}