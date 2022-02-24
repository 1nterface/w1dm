import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:w1dm/Biggies_Pizza/Panel/panel_de_control_detalle.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/carpinteria_producto_detalle.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class alta_colonias extends StatefulWidget {
  @override
  alta_coloniasState createState() => alta_coloniasState();
}

class alta_coloniasState extends State<alta_colonias> {

  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Colonia');

  var category;
  //FOLIO, NOMBRE, CELULAR, COLONIA, CALLE, NUMERO
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _colonia = TextEditingController();
  final TextEditingController _calle = TextEditingController();
  final TextEditingController _numero = TextEditingController();

  void t(){
    Future.delayed(Duration(seconds: 5), () {
      print(" This line is execute after 5 seconds");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
                      color: Colors.red,
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
                      color: Colors.red,
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
                      color: Colors.red,
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
  Widget altaNuevaNota(BuildContext context) {
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
                      color: Colors.black,
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
                      color: Colors.black,
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
                      color: Colors.black,
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
                    icon: Icon(Icons.text_rotation_none,
                      color: Colors.black,
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
                      color: Colors.black,
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

                      docReference.set({

                        'visto': "no",
                        'correoNegocio': correoPersonal,
                        'hora': formattedDate,
                        'calle': _calle.text,
                        'colonia': _colonia.text,
                        'concepto': "",
                        'numero': numero,
                        'celular': celular,
                        'folio': _myDocCount.length+1,
                        'newid': docReference.id,
                        'id': "987",
                        'nombrecliente': _nombre.text,
                        'nombreProducto': _myDocCount.length+1,
                        'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                        'repartidor': 'Nadie',
                        'estado': 'enlinea',
                        'estado2': 'PENDIENTE',
                        'estado3': 'PEDIDO A DOMICILIO',
                        'totalNota': 0.00,
                        'total': 0.00,
                        'tipodepago': "Ninguno",
                        'transitopendiente': "",
                        'encamino': "",
                        'ensitio': "",
                        'finalizo': "",
                      });


                      Navigator.pop(context);

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Aceptar', textAlign: TextAlign.center,),
                    ),
                    borderSide: BorderSide(color: Colors.black),
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

  Widget _buildAboutDialog(BuildContext context) {
    return ListView(
      children: <Widget>[
        AlertDialog(
          title: const Text('Nuevo Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  OutlineButton(
                    onPressed: () async {

                      showDialog(context: context, builder: (BuildContext context) =>  altaNuevaNota(context));

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Confirmar nueva nota', textAlign: TextAlign.center,),
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

  var now = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }


  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController _cantidad6 = TextEditingController();

  Widget tiempoDeEspera (BuildContext context){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tiempo').doc("$correoPersonal+espera").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            String tiempo = userDocument["tiempo"];

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer),
                Text('Tiempo actual: '+tiempo+" min.", style: TextStyle(color: Colors.red[800], fontSize: 15.0, fontWeight: FontWeight.bold),),
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
                      hintText: 'Ingresar nuevo tiempo',
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

                                FirebaseFirestore.instance.collection('Tiempo').doc("$correo+espera").update({
                                  'tiempo': _cantidad6.text,
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


  late double fletes1 = 10.00;

  final List<double> accountType = [35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90 ,95, 100, 120, 130,140, 150,160,170,180,190,200];
  late double  val2 = 0.0;

  Widget fletes(BuildContext context){
    return DropdownButtonFormField<double?>(
      value: null,
      items: accountType.map((accountType) {
        return DropdownMenuItem(
          value: accountType,
          child: Text("\$"+accountType.toString()),
        );
      }).toList(),
      onChanged: (double? val) {
        setState(() {
          fletes1 = val!;
        });
      },
    );
  }

  Future<void> pedidos (BuildContext context)async{

    var now = DateTime.now();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('visto', isEqualTo: 'no').where('correoNegocio', isEqualTo: correoPersonal).get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Notificacion: "+_myDocCount2.length.toString());

    FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos"+correoPersonal.toString()).set  ({'notificacion': _myDocCount2.length.toString()});
  }

  void _borrarElemento (BuildContext context, String newid) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas eliminar esta colonia?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () {

                FirebaseFirestore.instance.collection('Colonia').doc(newid).delete();
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

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

  Widget listaColonia (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

     return StreamBuilder(
       //Asi encontraremos los negocios por ciudad y sin problemas con la BD
         stream: reflistaproduccion.where('correoNegocio', isEqualTo: correoPersonal).orderBy('colonia', descending: true).snapshots(),
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

                     _borrarElemento(context, documents["newid"]);

                   },
                   child: Card(
                     elevation: 1.0,
                     color: Colors.white,
                     child: Stack(
                       children: <Widget>[
                         Column(
                           children: [
                             SizedBox(
                                 width: 120,
                                 child: Text(documents["colonia"], textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),)),

                             documents["flete"] == null?
                             Container()
                                 :
                             SizedBox(
                                 width: 120,
                                 child: Text(documents["flete"].toString(), textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),)),

                           ],
                         ),
                       ],
                     ),
                   ),
                 );
               }).toList(),
             );
           }
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
        title: Text("Alta Colonias"),
      ),
      //floatingActionButton: FloatingActionButton(
      //backgroundColor: Colors.black,
      //child: Icon(Icons.add),
      //onPressed: (){

      //showDialog(context: context, builder: (BuildContext context) =>  altaNuevaNota(context));

      //_sheetCarrito(context);
      //},
      //),

      body: Column(
        children:[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
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
                  icon: Icon(Icons.text_rotation_none,
                    color: Colors.black,
                  ),
                  hintText: 'Colonia',
                ),
              ),
            ),
          ),

          fletes(context),
          SizedBox(height:20),

          Container(
            child: SizedBox(
              child: RaisedButton(
                color: Colors.red[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                child: Text('Guardar', style: TextStyle(color: Colors.white),),
                onPressed: () async {

                  QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Colonia').orderBy('folio').get();
                  List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                  final collRef = FirebaseFirestore.instance.collection('Colonia');
                  DocumentReference docReference = collRef.doc();

                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('kk:mm:ss').format(now);

                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final correoNegocio = user!.email;

                  docReference.set({
                    'correoNegocio': correoNegocio,
                    'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                    'colonia': _colonia.text,
                    'flete': fletes1,
                    'folio': _myDocCount.length+1,
                    'newid': docReference.id,
                  });

                  _colonia.clear();




                },
              ),
            ),
          ),

          SizedBox(height:20),

          Expanded(
            child: listaColonia(context),
          ),
        ]
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
