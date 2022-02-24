  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/pedidos_detalles.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/producto_detalle2.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/nota_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class pedidos extends StatefulWidget {
  @override
  pedidosState createState() => pedidosState();
}

class pedidosState extends State<pedidos> {

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference reflistamesas = FirebaseFirestore.instance.collection('Servicios');

  void _ventanaFlotante(BuildContext context){
    TextEditingController _numeroMovil = TextEditingController();

    void inputData() async{

      //Metodo Thanos para el folio de la nota completa
      FirebaseFirestore.instance.collection('Clave').where("id", isEqualTo: "12345").snapshots().listen((data) async {
        data.docs.forEach((doc) async {

          var clave = doc['clave'];

          print(clave);

          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final uid = user!.uid;

          var uri = 'sms:+ '+_numeroMovil.text+'?body='+clave;
          if (await canLaunch(uri))
          {
            await launch(uri);
          }
          else
          {
            final FirebaseAuth auth = FirebaseAuth.instance;
            final User? user = auth.currentUser;
            final uid = user!.uid;
            // iOS
            var uri = _numeroMovil.text+clave;
            if (await canLaunch(uri))
            {
              await launch(uri);
            }
            else
            {
              throw 'Could not launch $uri';
            }
          }

        }); //METODO THANOS FOR EACH

      });

    }

    Alert(
        context: context,
        title: "ENVIÓ DE CÓDIGO DE SEGURIDAD",
        content: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              controller: _numeroMovil,
              decoration: InputDecoration(
                icon: Icon(Icons.phone_android),
                labelText: 'Ingresa el número móvil',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              inputData();
              Navigator.pop(context);
            },
            child: Text(
              "Enviar código de seguridad",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
  final TextEditingController _tel = TextEditingController();

  Widget _buildAboutDialog(BuildContext context) {
    return ListView(
      children: <Widget>[
        AlertDialog(
          title: const Text('Cambiar codigo de seguridad'),
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
                      return 'Ingresa la nueva clave';
                    }
                    return null;
                  },
                  controller: _tel,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red[900],
                    ),
                    hintText: 'Clave nueva',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  OutlineButton(
                    onPressed: () async {

                      FirebaseFirestore.instance.collection('Clave').doc("clave").update({'clave': _tel.text});
                      //_crearCodigo(context);
                      Navigator.pop(context);

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Guardar clave nueva', textAlign: TextAlign.center,),
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

  CollectionReference reflistadeventas = FirebaseFirestore.instance.collection('Cajas');
  var sucursal;

  Future<void> pedidos (BuildContext context)async{

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Ventas').where('estado3', isEqualTo: "encamino").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Esto quiero: "+_myDocCount2.length.toString());

    FirebaseFirestore.instance.collection('Notificaciones').doc("Direccion_Pedidos").set({'notificacion': _myDocCount2.length.toString()});
  }

  @override
  void initState() {
    // TODO: implement initState
   pedidos(context);
    super.initState();
  }

  Widget nombre (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;
    return StreamBuilder(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Direccion_Registro').doc(correoPersonal).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {

            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;
            var nombre = userDocument['nombre'];
            var foto = userDocument['foto'];

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
                Text(nombre.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              ],
            );
          }
        }
    );
  }

  bool ropa = true, zapatos = true, bolsas = true, filtro = false, filtro2 = false;
  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Cajas');

  Future<void> _sheetMesas(context) async {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('S E R V I C I O S', style: TextStyle(color: Colors.green[900]),),
                      InkWell(
                        onTap: (){

                          showDialog(context: context, builder: (BuildContext context) => _altaServicio(context));

                        },
                          child: Icon(Icons.add)),
                    ]
                ),

                Expanded(
                  child: StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistamesas.where('id', isEqualTo: '987').orderBy('servicio', descending: false).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if (!snapshot.hasData) {
                          return Text("Loading..");
                        }
                        //reference.where("title", isEqualTo: 'UID').snapshots(),

                        else
                        {
                          return FirestoreListViewMesas(documentsm: snapshot.data!.docs);
                        }
                      }
                  ),
                ),
                //total(context),
              ],
            ),
          );
        }
    );
  }

  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController _cantidad6 = TextEditingController();

  Widget tiempoDeEspera (BuildContext context){
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Tiempo').doc("espera").snapshots(),
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

  Widget _buildAboutDialog3(BuildContext context) {
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

                                FirebaseFirestore.instance.collection('Tiempo').doc("espera").update({
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

  final TextEditingController _servicio = TextEditingController();
  final TextEditingController _costo = TextEditingController();

  Widget _altaServicio(BuildContext context) {
    return ListView(
      children: <Widget>[
        AlertDialog(
          title: const Text('Alta de Servicio'),
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
                  textCapitalization: TextCapitalization.words,
                  controller: _servicio,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red[900],
                    ),
                    hintText: 'Nombre del servicio',
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
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Ingresa el costo';
                    }
                    return null;
                  },
                  controller: _costo,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.phone_android,
                      color: Colors.red[900],
                    ),
                    hintText: 'Costo del servicio',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  OutlineButton(
                    onPressed: () async {


                      final collRef = FirebaseFirestore.instance.collection('Servicios');
                      DocumentReference docReference = collRef.doc();

                      var now = DateTime.now();
                      double costo = double.parse(_costo.text);

                      docReference.set({
                        'newid': docReference.id,
                        'id': "987",
                        "servicio" : _servicio.text,
                        "costoProducto": costo,
                      });
                      _servicio.clear();
                      _costo.clear();
                      //_crearCodigo(context);
                      Navigator.pop(context);

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Guardar servicio', textAlign: TextAlign.center,),
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

                                FirebaseFirestore.instance.collection('Tiempo').doc("espera").update({
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

  Widget listaPedidos(){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistaproduccion.where('correoNegocio', isEqualTo: correoPersonal).orderBy('nombreProducto', descending: false).snapshots(),
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
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.white,
        elevation: 1.0,
        shape: CircleBorder(),
        children: [

          SpeedDialChild(
              child: Icon(Icons.timer, color: Colors.white,),
              backgroundColor: Colors.yellow[700],
              label: 'Tiempo de Espera',
              onTap: () {

                showDialog(context: context, builder: (BuildContext context) =>  _buildAboutDialogTi(context));

              }
          ),


          SpeedDialChild(
              child: Icon(Icons.add, color: Colors.white,),
              backgroundColor: Colors.yellow[700],
              label: 'Agregar Servicio',
              onTap: () {

                _sheetMesas(context);
                //showDialog(context: context, builder: (BuildContext context) => _altaServicio(context));


              }
          ),

          SpeedDialChild(
              child: Icon(Icons.add, color: Colors.white,),
              backgroundColor: Colors.red[900],
              label: 'Agregar Producto',
              onTap: () {

                Navigator.of(context).pushNamed('/alta_costos_caja');
              }
          ),
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

            listaPedidos(),
            SizedBox(height: 20,)
          ],
        ),
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
      itemExtent: 150.0, //Crea el espacio entre cada renglon
      itemBuilder: (BuildContext context, int index) {

        String cantidad = documents[index]['cantidad'].toString();
        String foto = documents[index]['foto'].toString();
        String fecha = documents[index]['miembrodesde'].toString();
        String nombreProducto = documents[index]['nombreProducto'].toString();
        double precio = documents[index]['costoProducto'];
        int folio = documents[index]['folio'];
        String newid = documents[index]['newid'].toString();
        int existencia = documents[index]['existencia'];
        double costoproducto = documents[index]['costoProducto'];
        String descripcion = documents[index]['descripcion'].toString();

        return ListTile(
            title: Card(
              elevation: 7.0,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("\$"+costoproducto.toString(), style: TextStyle(color: Colors.red[900], fontSize: 20),),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
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
                          padding: EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(nombreProducto, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black45),),
                                    //height: 30,
                                    width: 160,
                                  ),
                                ],

                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(descripcion, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black26),),
                                    //height: 30,
                                    width: 160,
                                  ),
                                ],
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

              _borrarElemento(context, nombreProducto, existencia, newid);

            },
            onTap: () async{

              print("aqui"+ newid);
              await Navigator.push(context, MaterialPageRoute(builder: (context) => producto_detalle2(cajas_modelo("", nombreProducto,fecha,folio,2,3, precio,precio.toInt(),"7501060327482","",foto,descripcion, newid, costoproducto))),);

            }
        );
      },
    );
  }
}


class FirestoreListViewVentas extends StatelessWidget {

  final List<DocumentSnapshot> documentsconfircarrito;
  const FirestoreListViewVentas({required this.documentsconfircarrito});

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
        String nombre = documentsconfircarrito[index]['nombrecliente'].toString();
        String direccion = documentsconfircarrito[index]['direccion'].toString();
        String foto = documentsconfircarrito[index]['foto'].toString();
        String fecha = documentsconfircarrito[index]['fecha'].toString();
        String newid = documentsconfircarrito[index]['newid'].toString();
        int folio = documentsconfircarrito[index]['folio'];
        int cantidad = documentsconfircarrito[index]['cantidad'];
        String estado = documentsconfircarrito[index]['estado'].toString();
        String estado2 = documentsconfircarrito[index]['estado2'].toString();
        String estado3 = documentsconfircarrito[index]['estado3'].toString();
        String estadoh = documentsconfircarrito[index]['estadoh'].toString();
        String servicio = documentsconfircarrito[index]['servicio'].toString();
        double totalNota = documentsconfircarrito[index]['totalNota'];
        String sucursal = documentsconfircarrito[index]['sucursal'].toString();
        String repartidor = documentsconfircarrito[index]['repartidor'].toString();
        String tel = documentsconfircarrito[index]['tel'].toString();


        return ListTile(
          title: Stack(
            children: <Widget>[

              Card(
                color: estado3 == "entregahecha"?
                Colors.green[700]
                    :
                estado3 == "encamino"?
                Colors.grey[700]
                    :
                estadoh == "horneando"?
                Colors.green[700]
                    :
                Colors.green[900],
                child: InkWell(
                  onLongPress: (){

                    //_borrarElemento(context, newid);

                  },

                  onTap:() async {

                    //FALTA MOSTRAR EN LA PESTAÑA "MIS COMPRAS"
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => pago_detalles(nota_modelo("", nombre,folio,cantidad, newid,direccion, totalNota, sucursal,0,0, tel,"",""))),);

                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 15,),
                          Text("ID"+folio.toString(), style: TextStyle(fontSize: 15.0, color: Colors.white),),
                          //Text(telefonoProveedor),
                        ],
                      ),

                      estado3 == "entregahecha"?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('ENTREGADO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
                              Text(repartidor, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),)
                            ],
                          )                        ],
                      )
                          :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          estado3 == "encamino"?
                          Column(
                            children: <Widget>[
                              Text('EN CAMINO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
                              Text(repartidor, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),)
                            ],
                          )
                              :
                          estadoh == "horneando"?
                          Text('EN PROCESO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),)
                              :
                          Text('NUEVO PEDIDO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),)
                        ],
                      ),
                      Text(servicio, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
      },
    );
  }
}

class FirestoreListViewMesas extends StatelessWidget {
  final List<DocumentSnapshot> documentsm;

  const FirestoreListViewMesas({required this.documentsm});

  void _borrarElemento (BuildContext context, String newid) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas borrar este servicio?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

                FirebaseFirestore.instance.collection('Servicios').doc(newid).delete();

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
      itemCount: documentsm.length,
      itemExtent: 70.0, //Crea el espacio entre cada renglon
      itemBuilder: (BuildContext context, int index) {

        String cantidad = documentsm[index]['cantidad'].toString();
        String fecha = documentsm[index]['miembrodesde'].toString();
        String nombreProducto = documentsm[index]['nombreProducto'].toString();
        double costo = documentsm[index]['costoProducto'];
        String newid = documentsm[index]['newid'].toString();
        String colonia = documentsm[index]['colonia'].toString();
        String calle = documentsm[index]['calle'].toString();
        int numero = documentsm[index]['numeroext'];
        int celular = documentsm[index]['celular'];
        String repa = documentsm[index]['repartidor'].toString();
        String estado = documentsm[index]['estado'].toString();
        String tipodepago = documentsm[index]['tipodepago'].toString();
        String mesa = documentsm[index]['servicio'];

        return ListTile(
            title: Card(
              elevation: 7.0,
              child: Column(
                children: <Widget>[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 60,
                        child: Icon(Icons.build, color: Colors.green[700], size: 35,),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(mesa, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          Text(costo.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            onLongPress: (){

              _borrarElemento(context, newid);
            },

            onTap: () async{


              print("aqui");
            }
        );
      },
    );
  }
}