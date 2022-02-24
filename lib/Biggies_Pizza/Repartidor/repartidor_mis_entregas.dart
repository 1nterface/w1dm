import 'dart:math';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/nota_modelo.dart';
import 'package:w1dm/Biggies_Pizza/Repartidor/pedidos_detalles_repartidor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class repartidor_mis_entregas extends StatefulWidget {
  const repartidor_mis_entregas({Key? key}) : super(key: key);

  @override
  repartidor_mis_entregasState createState() => repartidor_mis_entregasState();
}

class repartidor_mis_entregasState extends State<repartidor_mis_entregas> {

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
    //pedidos(context);
    super.initState();
  }

  CollectionReference reparegistro = FirebaseFirestore.instance.collection('Repartidor_Registro');

  Widget nombre (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return FutureBuilder<DocumentSnapshot>(
      future: reparegistro.doc(correoPersonal.toString()).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {

          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          var userDocument = snapshot.data;
          var nombre = data['nombre'];
          var sucursal = data['sucursal'];
          var foto = data['foto'];

          return Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Container(
                  width: 70.0,
                  height: 70.0,
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
              //Text(nombre.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            ],
          );
        }

        return Text("loading");
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _buildAboutDialog(BuildContext context) {
    return ListView(
      children: <Widget>[
        AlertDialog(
          title: const Text('Alta de Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                  controller: _nombre,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.person,
                      color: Colors.red[900],
                    ),
                    hintText: 'Nombre de Cliente',
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
                          color: Colors.red,
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
                    icon: Icon(Icons.phone_android,
                      color: Colors.red[900],
                    ),
                    hintText: 'Numero de Celular',
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
                          color: Colors.red,
                          blurRadius: 5
                      )
                    ]
                ),
                child: TextField(
                  controller: _colonia,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.location_on,
                      color: Colors.red[900],
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
                          color: Colors.red,
                          blurRadius: 5
                      )
                    ]
                ),
                child: TextField(
                  controller: _calle,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.location_on,
                      color: Colors.red[900],
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
                          color: Colors.red,
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
                    icon: Icon(Icons.home,
                      color: Colors.red[900],
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
                        'repartidor': 'Nadie',
                      });

                      _colonia.clear();
                      _nombre.clear();
                      _calle.clear();
                      _celular.clear();
                      _numero.clear();

                      Navigator.pop(context);

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Registrar pedido', textAlign: TextAlign.center,),
                    ),
                    borderSide: BorderSide(color: Colors.red),
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20,),
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
    );
  }

  //CollectionReference promo = FirebaseFirestore.instance.collection('Notificaciones');

  //WIDGET LOKI , LISTA CONDICIONADA Y CON CORREO
  Widget listaPedidos (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Pedidos_Jimena').where("correorepa", isEqualTo: correoPersonal).where("estadorepa", isEqualTo: "terminado").orderBy('folio', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {

              //variables a la base de datos

              return Card(
                elevation: 1.0,
                color:
                document["visto"] == "no"?
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

                              //ICONO PARA MOSTRAR DIRECCION CON UN SHEET DIRECTAMENTE


                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                          width: 120,
                                          child: Text('Pedido #'+document["folio"].toString(), textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),)),

                                      SizedBox(
                                          width: 120,
                                          child: Text(document["estado3"], textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.purple[900]),)),
                                      SizedBox(
                                        width: 120,
                                        child: Text(document["concepto"], style: TextStyle(color:Colors.purple[900], fontSize: 15.0)),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text("Espera "+document["tiempodeespera"]+" min ", style: TextStyle(color:Colors.grey)),
                                      ),

                                    ],
                                  ),
                                  SizedBox(width: 25),
                                  Column(
                                    children: [
                                      Text(document["hora"], style: TextStyle(color:Colors.grey)),
                                      SizedBox(height: 10,),
                                      InkWell(
                                        child: SizedBox(
                                          height: 50,
                                          width: 60,
                                          child: Icon(Icons.phone_in_talk, color: Colors.green[700], size: 35,),
                                        ),
                                        onTap: (){

                                          var tel = document["tel"];
                                          launch('tel:+$tel');

                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 25),
                                  Column(
                                    children: [
                                      Text("\$"+document["totalNota"].toString(), style: TextStyle(color:Colors.purple[900])),
                                      SizedBox(height: 10,),
                                      InkWell(
                                        child: SizedBox(
                                          height: 50,
                                          width: 60,
                                          child: Icon(Icons.not_listed_location, color: Colors.red[700], size: 35,),
                                        ),
                                        onTap: (){

                                          showModalBottomSheet(
                                              shape : RoundedRectangleBorder(
                                                  borderRadius : BorderRadius.circular(30)
                                              ),
                                              context: context,
                                              builder: (BuildContext bc){
                                                return Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children:[
                                                      SizedBox(height:10),
                                                      Text("Colonia", style: TextStyle(fontSize: 20)),
                                                      Text(document["colonia"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                      Text("Calle", style: TextStyle(fontSize: 20)),
                                                      Text(document["calle"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                      Text("Numero Exterior", style: TextStyle(fontSize: 20)),
                                                      Text(document["numext"].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                    ]
                                                );
                                              }
                                          );                                              //launch('tel:+$celular');

                                        },
                                      ),
                                    ],
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
              );
            }).toList(),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SpeedDialChild(
      //child: Icon(Icons.library_books, color: Colors.white,),
      //7 backgroundColor: Colors.black38,
      //label: 'Lista de Insumos',
      //onTap: () {
      //  Navigator.of(context).pushNamed('/lista_insumos');
      //  }
      //),

      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0,),
            //nombre(context),


            Expanded(
                child: listaPedidos(context)
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
