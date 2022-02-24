import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/carpinteria_producto_detalle.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/carpinteria_producto_detalle.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'gerencia_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class carpinteria extends StatefulWidget {
  @override
  carpinteriaState createState() => carpinteriaState();
}

class carpinteriaState extends State<carpinteria> {

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

  //METODO DE TIEMPO LIMITE
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

  Widget altaRescate(BuildContext context) {
    return ListView(
      children: <Widget>[
        AlertDialog(
          title: const Text('Alta de Rescate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa el nombre';
                    }
                    return null;
                  },
                  controller: _nombre,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red[900],
                    ),
                    hintText: 'Nombre del cliente',
                  ),
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("Servicios").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text("Please wait");
                    var length = snapshot.data!.docs.length;
                    DocumentSnapshot ds = snapshot.data!.docs[length - 1];
                    return DropdownButton(
                      items: snapshot.data!.docs.map((
                          DocumentSnapshot document) {
                        return DropdownMenuItem(
                          value: document["servicio"],
                          child: Text(document["servicio"], style: TextStyle(fontSize: 17.0),),);
                      }).toList(),
                      value: category,
                      onChanged: (value) {
                        //print(value);
                        setState(() {
                          category = value;
                        });

                      },
                      hint: Text("Tipo de rescate", style: TextStyle(fontSize: 18.0),),
                      style: TextStyle(color: Colors.black),
                    );
                  }
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
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa el numero celular';
                    }
                    return null;
                  },
                  controller: _celular,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red[900],
                    ),
                    hintText: 'Celular',
                  ),
                ),
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
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa la calle';
                    }
                    return null;
                  },
                  controller: _calle,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red,
                    ),
                    hintText: 'Calle',
                  ),
                ),
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
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa la colonia';
                    }
                    return null;
                  },
                  controller: _colonia,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red[900],
                    ),
                    hintText: 'Colonia',
                  ),
                ),
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
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa el numero de casa';
                    }
                    return null;
                  },
                  controller: _numero,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red[900],
                    ),
                    hintText: 'Numero',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  OutlineButton(
                    onPressed: () async {

                      QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                      List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                      final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena');
                      DocumentReference docReference = collRef.doc();

                      DateTime now = DateTime.now();
                      String formattedDate = DateFormat('kk:mm:ss').format(now);

                      int celular = int.parse(_celular.text);
                      int numero = int.parse(_numero.text);


                      docReference.set({

                        //AWEBO ABRIR VENTANA PARA PREGUNTAR
                        // SPINNER TIPO DE RESCATE, NOMBRE DE CLIENTE, DIRECCION, CELULAR
                        // TAMBIEN REVISAR POR QUE AL ASIGNAR UN RESCATE, VUELVES A ENTRAR A VER
                        // LA NOTA Y TE APARECE LA NOTA DE PEDIDO..QUITAR ESO POR QUE NO SIRVE.
                        'hora': formattedDate,
                        'calle': _calle.text,
                        'concepto': "",
                        'colonia': _colonia.text,
                        'numero': numero,
                        'celular': celular,
                        'servicio': category,
                        'folio': _myDocCount.length+1,
                        'newid': docReference.id,
                        'id': "987",
                        'nombreProducto': _myDocCount.length+1,
                        'nombrecliente': _nombre.text,
                        'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                        'repartidor': 'Nadie',
                        'estado': 'rescatesolicitado',
                        'estado3': 'PEDIDO LOCAL',
                        'estado2': 'pedidoEnEspera',
                        'totalNota': 0.00,
                        'tipodepago': "Ninguno",
                        'transitopendiente': "",
                        'encamino': "",
                        'ensitio': "",
                        'finalizo': "",
                        'visto': "no",
                      });

                      _calle.clear();
                      _colonia.clear();
                      _nombre.clear();
                      _celular.clear();
                      _numero.clear();

                      pedidos(context);

                      Navigator.pop(context);
                      Navigator.pop(context);

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Guardar RESCATE', textAlign: TextAlign.center,),
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

  var colonia;

  Widget coloniaSpinner(BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StatefulBuilder(
          builder: (BuildContext context, setState) =>  GestureDetector(
            onTap: (){
              (context as Element).markNeedsBuild();
            },
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Colonia").where('correoNegocio', isEqualTo: correo ).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  var length = snapshot.data!.docs.length;
                  DocumentSnapshot ds = snapshot.data!.docs[length - 1];
                  return DropdownButton(
                    items: snapshot.data!.docs.map((
                        DocumentSnapshot document) {
                      return DropdownMenuItem(
                        value: document["colonia"],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(document["colonia"]),
                            //Icon(Icons.arrow_right),
                            //new Text(document.data["existencia"].toString(), style: TextStyle(fontSize: 17.0, color: Colors.green[800]),),
                          ],
                        ),
                      );
                    }).toList(),
                    value: colonia,
                    onChanged: (value) {
                      //print(value);
                      setState(() {
                        colonia = value;

                        print(colonia);

                      });

                      FirebaseFirestore.instance.collection('Colonia').where('colonia', isEqualTo: colonia).snapshots().listen((data) async {
                        data.docs.forEach((doc) async {

                          double flete = doc['flete'];

                          print("Flete "+flete.toString());

                          final prefs = await SharedPreferences.getInstance();
                          prefs.setDouble('flete', flete);


                        }); //METODO THANOS FOR EACH

                      });

                    },
                    hint: Text("Colonia", style: TextStyle(fontSize: 18.0),),
                    style: TextStyle(color: Colors.black),
                  );
                }
            ),
          ),
        ),
        //Text('Medidas: 5A'),
      ],
    );

  }

  Widget altaNuevaNota(BuildContext context, String tiempo) {
    return ListView(
      children: <Widget>[
        AlertDialog(
          title: const Text('Alta de Nuevo Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
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
                      return 'Ingresa el nombre';
                    }
                    return null;
                  },
                  controller: _nombre,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.person,
                      color: Colors.brown,
                    ),
                    hintText: 'Nombre del cliente',
                  ),
                ),
              ),

              SizedBox(height: 20),
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
                      return 'Ingresa el numero celular';
                    }
                    return null;
                  },
                  controller: _celular,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.brown,
                    ),
                    hintText: 'Celular',
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                      return 'Ingresa la calle';
                    }
                    return null;
                  },
                  controller: _calle,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.text_rotation_none,
                      color: Colors.brown,
                    ),
                    hintText: 'Calle',
                  ),
                ),
              ),
              SizedBox(height: 20),
              coloniaSpinner(context),
              SizedBox(height: 20),
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
                      return 'Ingresa el numero de casa';
                    }
                    return null;
                  },
                  controller: _numero,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.house,
                      color: Colors.brown,
                    ),
                    hintText: 'Numero',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  OutlineButton(
                    onPressed: () async {

                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User? user = auth.currentUser;
                      final correoPersonal = user!.email;

                      QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                      List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                      final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena');
                      DocumentReference docReference = collRef.doc();

                      DateTime now = DateTime.now();
                      String formattedDate = DateFormat('kk:mm:ss').format(now);

                      int celular = int.parse(_celular.text);
                      int numero = int.parse(_numero.text);

                      final prefs = await SharedPreferences.getInstance();
                      String nombreempresa = prefs.getString('nombreempresa') ?? "";
                      Object flete = prefs.getDouble('flete') ?? "";
                      String tiempoo = prefs.getString('tiempo') ?? "";
                      String coloniaNegocio = prefs.getString('coloniaNegocio') ?? "";
                      String calleNegocio = prefs.getString('calleNegocio') ?? "";
                      String numextNegocio = prefs.getString('numextNegocio') ?? "";

                      docReference.set({
                        "numextNegocio":numextNegocio,
                        "coloniaNegocio":coloniaNegocio,
                        "calleNegocio": calleNegocio,
                        'nombreempresa': nombreempresa,
                        'tiempodeespera': tiempoo,
                        'flete': flete,
                        'visto': "no",
                        'correoNegocio': correoPersonal,
                        'hora': formattedDate,
                        'calle': _calle.text,
                        'colonia': colonia,
                        'concepto': "",
                        'numero': numero,
                        'celular': celular,
                        'folio': _myDocCount.length+1,
                        'newid': docReference.id,
                        'id': "987",
                        'nombrecliente': _nombre.text,
                        'nombreProducto': _myDocCount.length+1,
                        'miembrodesde': DateFormat("yyyy-MM-dd").format(now),
                        'repa': 'Nadie',
                        'estado': 'enlinea',
                        'estado2': 'PENDIENTERESTA',
                        'estado3': 'PEDIDO A DOMICILIO',
                        'totalNota': 0.00,
                        'total': 0.00,
                        'tipodepago': "Ninguno",
                        'transitopendiente': "",
                        'encamino': "",
                        'ensitio': "",
                        'finalizo': "",
                        'estadoc': "local",
                      });

                      pedidos(context);

                      Navigator.pop(context);

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Aceptar', textAlign: TextAlign.center,),
                    ),
                    borderSide: BorderSide(color: Colors.brown),
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
              child: Text('Salir', style: TextStyle(color: Colors.brown)),
            ),
          ],
        ),
      ],
    );
  }

  var now = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }

  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController _cantidad6 = TextEditingController();
  final TextEditingController _cantidadr = TextEditingController();

  Widget tiempoDeEspera (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection('Tiempo').doc(correo.toString()+"espera").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            String tiempo = data["tiempo"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer),
                Text('Tiempo a dom.: '+tiempo+" min.", style: TextStyle(color: Colors.red[800], fontSize: 15.0, fontWeight: FontWeight.bold),),
              ],
            );

          }
        }
    );
  }
  Widget tiempoDeEsperaR (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection('Tiempo').doc(correo.toString()+"espera").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            String tiempo = userDocument["tiempor"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer),
                Text('Tiempo de recoleccion: '+tiempo+" min.", style: TextStyle(color: Colors.red[800], fontSize: 15.0, fontWeight: FontWeight.bold),),
              ],
            );

          }
        }
    );
  }

  Widget _buildAboutDialogTi(BuildContext context) {
    return Form(
      key: _formKey3,
      child: Column(
        children: <Widget>[
          AlertDialog(
            title: Text("Modificar tiempo de espera"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tiempoDeEspera(context),
                Container(
                  color: Colors.black,
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
                        return 'Escribe el nuevo tiempo de espera';
                      }
                      return null;
                    },
                    controller: _cantidad6,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Entrega a domicilio',
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
                              color: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Modificar', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final User? user = auth.currentUser;
                                final correo = user!.email;

                                FirebaseFirestore.instance.collection('Tiempo').doc(correo.toString()+"espera").update({
                                  'tiempo': _cantidad6.text,
                                  "correoNegocio": correo,
                                });

                                Toast.show("¡Tiempo de espera modificado!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3, precio,5,"","",foto,descripcion, newid, costoproducto))),);
                                Navigator.pop(context);

                                _cantidad6.clear();

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                tiempoDeEsperaR(context),
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
                        return 'Escribe el nuevo tiempo de espera';
                      }
                      return null;
                    },
                    controller: _cantidadr,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Tiempo recoleccion',
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
                              color: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Modificar', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final User? user = auth.currentUser;
                                final correo = user!.email;

                                FirebaseFirestore.instance.collection('Tiempo').doc(correo.toString()+"espera").update({
                                  'tiempor': _cantidadr.text,
                                });

                                Toast.show("¡Tiempo de espera modificado!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3, precio,5,"","",foto,descripcion, newid, costoproducto))),);
                                Navigator.pop(context);

                                _cantidadr.clear();

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
    );
  }

  Future<void> _sheetExtras(context) async {
    CollectionReference reflistaextras = FirebaseFirestore.instance.collection('Extras');
    showModalBottomSheet(
        shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(30)
        ),
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20,),
                Expanded(
                  child: StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistaextras.where("id", isEqualTo: '987').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading..");
                        }
                        //reference.where("title", isEqualTo: 'UID').snapshots(),

                        else
                        {
                          return Text('hola');
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

  bool _isChecked = false, _isChecked2 = false, _isChecked3 = false;
  bool _isCheckedEfe = false, _isCheckedTar = false;
  List<String> text = ["Recoger en establecimiento"];
  List<String> text2 = ["A Domicilio"];
  List<String> textefe = ["Efectivo"];
  List<String> texttar = ["Pago con tarjeta"];

  Widget efectivoWidget (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoNegocio = user!.email;
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(correoNegocio).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            String efectivo = userDocument["efectivo"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                efectivo == "si"?
                Icon(Icons.check_circle, color: Colors.green[800])
                    :
                Icon(Icons.cancel, color: Colors.red[800]),
                //Text(efectivo, style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),),
                SizedBox(width: 15),

                efectivo == "si"?
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.red[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Cambiar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {

                        FirebaseFirestore.instance.collection('Socios_Registro').doc(correoNegocio).update({
                          'efectivo': "no",
                        });

                      },
                    ),
                  ),
                )
                    :
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.green[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Cambiar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        FirebaseFirestore.instance.collection('Socios_Registro').doc(correoNegocio).update({
                          'efectivo': "si",
                        });

                      },
                    ),
                  ),
                ),

              ],
            );

          }
        }
    );
  }
  Widget tarjetaWidget (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(correoPersonal).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            String efectivo = userDocument["tarjeta"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                efectivo == "si"?
                Icon(Icons.check_circle, color: Colors.green[800])
                    :
                Icon(Icons.cancel, color: Colors.red[800]),
                //Text(efectivo, style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),),
                SizedBox(width: 15),

                efectivo == "si"?
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.red[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Cambiar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {

                        FirebaseFirestore.instance.collection('Socios_Registro').doc(correoPersonal).update({
                          'tarjeta': "no",
                        });

                      },
                    ),
                  ),
                )
                    :
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.green[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Cambiar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        FirebaseFirestore.instance.collection('Socios_Registro').doc(correoPersonal).update({
                          'tarjeta': "si",
                        });

                      },
                    ),
                  ),
                ),

              ],
            );

          }
        }
    );
  }
  Widget recogerWidget (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;
    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(correoPersonal).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            String efectivo = userDocument["recoger"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                efectivo == "si"?
                Icon(Icons.check_circle, color: Colors.green[800])
                    :
                Icon(Icons.cancel, color: Colors.red[800]),
                //Text(efectivo, style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),),
                SizedBox(width: 15),

                efectivo == "si"?
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.red[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Cambiar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {

                        FirebaseFirestore.instance.collection('Socios_Registro').doc(correoPersonal).update({
                          'recoger': "no",
                        });

                      },
                    ),
                  ),
                )
                    :
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.green[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Cambiar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        FirebaseFirestore.instance.collection('Socios_Registro').doc(correoPersonal).update({
                          'recoger': "si",
                        });

                      },
                    ),
                  ),
                ),

              ],
            );

          }
        }
    );
  }
  Widget adomiWidget (BuildContext context){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;

    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(correo).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            String efectivo = userDocument["adomi"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                efectivo == "si"?
                Icon(Icons.check_circle, color: Colors.green[800])
                    :
                Icon(Icons.cancel, color: Colors.red[800]),
                //Text(efectivo, style: TextStyle(color: Colors.black, fontSize: 40.0, fontWeight: FontWeight.bold),),
                SizedBox(width: 15),

                efectivo == "si"?
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.red[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Cambiar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {

                        FirebaseFirestore.instance.collection('Socios_Registro').doc(correo).update({
                          'adomi': "no",
                        });

                      },
                    ),
                  ),
                )
                    :
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.green[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Cambiar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        FirebaseFirestore.instance.collection('Socios_Registro').doc(correo).update({
                          'adomi': "si",
                        });

                      },
                    ),
                  ),
                ),

              ],
            );

          }
        }
    );
  }
  void _borrarElemento (BuildContext context, String newid) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas cancelar este pedido?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () {
                pedidos(context);
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

                FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(newid).update({
                  'estado3':'CANCELADO',
                  'concepto':'Cancelado',
                  'totalNota': 0.0,
                });

                //Firestore.instance.collection('Pedidos_Jimena').document(newid).delete();

              },
            ),

            FlatButton(
              child: Text("No"),
              onPressed: () {
                pedidos(context);
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior


              },
            ),
          ],
        );
      },
    );
  }

  listaPedidos(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistaproduccion.where('correoNegocio', isEqualTo: correo).where("miembrodesde", isEqualTo: DateFormat("yyyy-MM-dd").format(now)).orderBy('folio', descending: true).snapshots(),
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

                      documents["estadoc"] == "recoger"?
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => carpinteria_producto_detalle(cajas_modelo2("", "nombreProducto", documents["estadoc"],documents["folio"], 2,2, 0,0, documents["concepto"], documents["estado3"], "Recoleccion", "tel", documents["newid"], 0.0, documents["latitud"], documents["longitud"], "empresa"))),)
                      :
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => carpinteria_producto_detalle(cajas_modelo2("", "nombreProducto", documents["estadoc"],documents["folio"], 2,2, 0,0, documents["concepto"], documents["estado3"], documents["calle"]+" #"+documents["numext"]+", "+documents["colonia"], "tel", documents["newid"], 0.0, documents["latitud"], documents["longitud"], "empresa"))),);

                      FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(documents["newid"]).update({
                        'visto': 'si',
                        'estado': 'Recibido',
                      });

                    },
                    child: Card(
                      elevation: 1.0,
                      color:
                      documents["visto"] == "no"?
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
                                    documents["estado"] == "enlinea"?

                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.motorcycle, color: Colors.white, size: 25,),
                                          //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black),
                                    )
                                        :
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              onTap: (){

                                                var tel = documents["tel"];
                                                launch('tel:+$tel');

                                              },
                                              child: Icon(Icons.phone, color: Colors.white, size: 25,)

                                          ),
                                          //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                          documents["repa"] == "Nadie"?
                                          Colors.red[800]
                                              :
                                          Colors.green[800]

                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                                width: 120,
                                                child: Text(documents["nombrecliente"].toString(), textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),)),
                                            //Text('ASIGNADO A: '+repa, style: TextStyle(fontSize: 15, color: Colors.black54),),
                                            SizedBox(
                                                width: 120,
                                                child: Text(documents["estado3"], textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),)),
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
                                                  style: TextStyle(color:Colors.black)),
                                              SizedBox(height: 10,),
                                              Text("Tiempo "+documents["tiempodeespera"]+" | "+documents["hora"],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(color:Colors.grey)),
                                              documents["repa"] != "Nadie"?
                                              Text(documents["repa"],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(color:Colors.black))
                                                  :
                                                  Container(),
                                            ],
                                          ),
                                        ),

                                      ],
                                    )
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

  Widget empresaNombre (BuildContext context){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Socios_Registro').doc(correoPersonal.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;
            String empresa = userDocument["empresa"];

            return Text(empresa);

          }
        }
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
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width, 50.0)),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[800],
          title: empresaNombre(context),
        ),
        //floatingActionButton: FloatingActionButton(
          //backgroundColor: Colors.black,
          //child: Icon(Icons.add),
          //onPressed: (){

            //showDialog(context: context, builder: (BuildContext context) =>  altaNuevaNota(context));

            //_sheetCarrito(context);
          //},
        //),
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


            SpeedDialChild(
                child: Icon(Icons.settings, color: Colors.white,),
                backgroundColor: Colors.red[800],
                label: 'Configuraciones',
                onTap: () {

                  showModalBottomSheet(
                      shape : RoundedRectangleBorder(
                          borderRadius : BorderRadius.circular(30)
                      ),
                      context: context,
                      builder: (BuildContext bc){
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: ListView(
                              children: [
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                        children: [
                                          Text('Configuraciones', style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold, fontSize: 20)),

                                        ]
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Card(
                                  elevation: 1,
                                  child: ListTile(
                                    onTap: (){
                                      Navigator.of(context).pushNamed('/repartidores_direccion');
                                    },
                                    leading: Icon(Icons.motorcycle, color: Colors.red[800]),
                                    title: Text('Repartidores'),
                                    subtitle: Text('Lista de repartidores'),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                                Card(
                                  elevation: 1,
                                  child: ListTile(
                                    onTap: (){
                                      Navigator.of(context).pushNamed('/alta_colonias');
                                    },
                                    leading: Icon(Icons.home, color: Colors.red[800]),
                                    title: Text('Alta colonias'),
                                    subtitle: Text('Aqui registras tus zonas de entrega'),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                                Card(
                                  elevation: 1,
                                  child: ListTile(
                                    onTap:(){
                                      showDialog(context: context, builder: (BuildContext context) =>  _buildAboutDialogTi(context));
                                    },//add_photo_alternate_outlined
                                    leading: Icon(Icons.access_time, color: Colors.red[800]),
                                    title: Text('Tiempo de espera'),
                                    subtitle: Text('Estableces el tiempo de espera de recoleccion y a domicilio'),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                                Card(
                                  elevation: 1,
                                  child: ListTile(
                                    onTap:(){
                                      Navigator.of(context).pushNamed('/alta_portada');
                                    },
                                    leading: Icon(Icons.add_photo_alternate_outlined, color: Colors.red[800]),
                                    title: Text('Cambiar portada'),
                                    subtitle: Text('Cambias la portada existente de tu negocio'),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                                Card(
                                  elevation: 1,
                                  child: ListTile(
                                    onTap:(){
                                      showModalBottomSheet<void>(
                                          shape : RoundedRectangleBorder(
                                              borderRadius : BorderRadius.circular(30)
                                          ),
                                          context: context,
                                          builder: (BuildContext bc){
                                            return Container(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 15.0),
                                                child: ListView(
                                                  children: [
                                                    SizedBox(height: 15),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: const [
                                                        SizedBox(width: 20),
                                                        SizedBox(width: 15),
                                                        Text('Elige tu tipo de pago', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),

                                                    //HACER YO MI PROPIA OPCION, UN BOTON QUE CAMBIE SI A NO



                                                    StatefulBuilder(
                                                      builder: (BuildContext context, setState) =>
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Icon(Icons.attach_money, color: Colors.black),
                                                              SizedBox(width: 15),
                                                              Text("Efectivo", style: TextStyle(fontSize: 14)),
                                                              SizedBox(width: 15),
                                                              efectivoWidget(context),
                                                              //Text("Efectivo", style: TextStyle(fontSize: 14)),
                                                            ],
                                                          ),
                                                    ),
                                                    SizedBox(height: 25),
                                                    StatefulBuilder(
                                                      builder: (BuildContext context, setState) =>
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Icon(Icons.credit_card, color: Colors.black),
                                                              SizedBox(width: 15),
                                                              Text("Pago con tarjeta", style: TextStyle(fontSize: 14)),
                                                              SizedBox(width: 15),
                                                              tarjetaWidget(context),
                                                            ],
                                                          ),
                                                    ),

                                                    SizedBox(height: 15),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: const [
                                                        SizedBox(width: 20),
                                                        SizedBox(width: 15),
                                                        Text('Elige tus servicios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                      ],
                                                    ),

                                                    StatefulBuilder(
                                                      builder: (BuildContext context, setState) =>
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Icon(Icons.directions_car, color: Colors.black),
                                                              SizedBox(width: 15),
                                                              Text("Recoleccion", style: TextStyle(fontSize: 14)),
                                                              SizedBox(width: 15),
                                                              recogerWidget(context),
                                                            ],
                                                          ),
                                                    ),

                                                    SizedBox(height: 15),
                                                    StatefulBuilder(
                                                      builder: (BuildContext context, setState) =>
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Icon(Icons.add_location_sharp, color: Colors.black),
                                                              SizedBox(width: 15),
                                                              Text("A Domicilio", style: TextStyle(fontSize: 14)),
                                                              SizedBox(width: 15),
                                                              adomiWidget(context),
                                                            ],
                                                          ),
                                                    ),

                                                    SizedBox(height: 15),

                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                      );                      },
                                    leading: Icon(Icons.monetization_on_outlined, color: Colors.red[800]),
                                    title: Text('Tipos de pago y servicios'),
                                    subtitle: Text('Eliges pagos en efectivo y/o con terminal inalambrica'),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                                Card(
                                  elevation: 1,
                                  child: ListTile(
                                    onTap: (){

                                      Navigator.of(context).pushNamed('/promociones_direccion');

                                    },
                                    leading: Icon(Icons.announcement, color: Colors.red[800]),
                                    title: Text('Subir ofertas'),
                                    subtitle: Text('Promocionas las ofertas de tu negocio'),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      }
                  );                  //Navigator.of(context).pushNamed('/alta_colonias');


                }
            ),

            //SpeedDialChild(
                //child: Icon(Icons.add, color: Colors.white,),
                //backgroundColor: Colors.brown,
                //label: 'Nueva orden',
                //onTap: () async {
                  //final FirebaseAuth auth = FirebaseAuth.instance;
                  //final User? user = auth.currentUser;
                  //final correoNegocio = user!.email;
                  //FirebaseFirestore.instance.collection('Tiempo').where('correoNegocio', isEqualTo: correoNegocio).get().then((snapshot) async {
                    //for (DocumentSnapshot doc in snapshot.docs) {
                      //tiempo = doc['tiempo'];
                      //print("tiempo "+tiempo);
                      //final prefs = await SharedPreferences.getInstance();
                      //prefs.setString('tiempo', tiempo);
                    //} //METODO THANOS FOR EACH
                  //});
                  //showDialog(context: context, builder: (BuildContext context) =>  altaNuevaNota(context, tiempo));
                  //FirebaseFirestore.instance.collection('Socios_Registro').where('correo', isEqualTo: correoNegocio).snapshots().listen((data) async {
                  //data.docs.forEach((doc) async {
                    //String numextNegocio = doc['numero'];
                    //empresa = doc['empresa'];
                    //coloniaNegocio = doc['colonia'];
                    //calleNegocio = doc['calle'];
                    //print("empresa "+empresa);
                    //print("coloniaNegocio "+coloniaNegocio);
                    //print("calleNegocio "+calleNegocio);
                    //print("numextNegocio "+numextNegocio);
                  //final prefs = await SharedPreferences.getInstance();
                    //prefs.setString('nombreempresa', empresa);
                    //prefs.setString('coloniaNegocio', coloniaNegocio);
                    //prefs.setString('calleNegocio', calleNegocio);
                    //prefs.setString('numextNegocio', numextNegocio);
                  //}); //METODO THANOS FOR EACH
                //  });
              //  }
            //),

            //SpeedDialChild(
            //  child: Icon(Icons.announcement, color: Colors.white,),
            //backgroundColor: Colors.blue[900],
            //label: 'Alta Promociones',
            //onTap: () {
            //Navigator.of(context).pushNamed('/promociones_direccion');
            //}
            // ),
          ],
        ),
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
