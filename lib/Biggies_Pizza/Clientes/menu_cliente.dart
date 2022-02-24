import 'dart:math';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo2.dart';
import 'package:w1dm/Biggies_Pizza/Clientes/comprar_ahora.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/carpinteria_producto_detalle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/nota_modelo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class menu_cliente extends StatefulWidget {

  final String empresa, correoEmpresa, newid, colonia, calle, numero;
  final int entrada, salida;

  const menu_cliente(this.empresa, this.correoEmpresa, this.newid, this.colonia, this.calle, this.numero, this.entrada, this.salida,{Key? key}) : super(key: key);

  @override
  menu_clienteState createState() => menu_clienteState();
}

class menu_clienteState extends State<menu_cliente> {

  CollectionReference reflistaproduccion = FirebaseFirestore.instance.collection('Cajas');
  CollectionReference reflistadecarrito = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
  CollectionReference reflistadeclientes = FirebaseFirestore.instance.collection('Clientes');
  CollectionReference reflistaextras = FirebaseFirestore.instance.collection('Extras');
  String? category, categorytalla, categorytacon;
  String? category2, category3;

  Future<void> promoNotificacion (BuildContext)async{
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Promociones').where('estado', isEqualTo: "sinver").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("Esto quiero: "+_myDocCount.length.toString());

    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Promociones').where('estado', isEqualTo: "visto").get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;
    print("Esto quiero 2: "+_myDocCount2.length.toString());

    int total =   _myDocCount.length - _myDocCount2.length;
    FirebaseFirestore.instance.collection('Notificaciones').doc("Promos").set({'notificacion': total.toString()});

    print("Total: "+total.toString());
  }

  Future<int> comprasNotificacion (BuildContext context)async{

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').where('correopersonal', isEqualTo: correoPersonal).where('visto', isEqualTo: "no").get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("Esto quiero: "+_myDocCount.length.toString());

    int total =   _myDocCount.length;
    FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+correoPersonal.toString()).set({'notificacion': total.toString()});
    return total;
  }

  Widget notificacionesCarrito (BuildContext context){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;


            return
              data['notificacion'] != "0"?

              Badge(
                position: BadgePosition(left: 30, bottom: 35),
                badgeColor: Colors.red[700],
                badgeContent: Text(data["notificacion"], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                child: FloatingActionButton(
                  onPressed: (){
                    _sheetCarrito(context);
                  },
                  backgroundColor: Colors.red[800],
                  child: Icon(Icons.add_shopping_cart, color: Colors.white,),
                ),
              )
                  :
              FloatingActionButton(
                onPressed: (){
                  _sheetCarrito(context);
                },
                backgroundColor: Colors.red[800],
                child: Icon(Icons.add_shopping_cart, color: Colors.white),
              );

          }
        }
    );
  }

  void _borrarElemento (BuildContext context, String id) async {
    var category;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text('¿Borrar del carrito?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[



            FlatButton(
              onPressed: (){

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
              child: const Text('Cancelar'),
            ),
            // usually buttons at the bottom of the dialog
            // ignore: deprecated_member_use
            FlatButton(
              child: Text("Si"),
              onPressed: () async {

                FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').doc(id).delete();

                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final correoPersonal = user!.email;

                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                QuerySnapshot _myDocE = await FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('correocliente', isEqualTo: correoPersonal).where('folio', isEqualTo: _myDocCount.length+1).get();
                List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
                //print('Weed: '+ _myDocCountE.length.toString() +1.toString());

                var total = _myDocCountE.length;

                FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).update({'notificacion': total.toString()});

                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sheetCarrito(context) async {

    //BLOQUE DE CODIGO PARA OBTENER EL TOTAL

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPersonal = user!.email;

    double total = 0;
    QuerySnapshot _myDoc2 = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
    List<DocumentSnapshot> _myDocCount2 = _myDoc2.docs;

    FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('correocliente', isEqualTo: correoPersonal ).where('folio', isEqualTo: _myDocCount2.length+1).snapshots().listen((data) async {
      data.docs.forEach((doc) async {
        //doc.reference.delete();
        //CREO QUE LA CLAVE ES MANDAR ESTEEste: TOTAL A PEDIDOS_INICIO
        final prefs4 = await SharedPreferences.getInstance();

        total = total + doc['totalProducto'];
        //total = total + doc['totalProducto'];
        print("Este total hay que hacerlo individual: "+total.toString());
        var fotocarrito = doc['foto'];
        //SharedPreferences paso #1
        final prefst = await SharedPreferences.getInstance();
        prefst.setDouble('totalProducto', total);
        prefst.setString('fotocarrito', fotocarrito);

        //IOSink sink = file.openWrite(mode: FileMode.writeOnlyAppend);

        //sink.add(utf8.encode(total.toString())); //Use newline as the delimiter
        //sink.writeln();
        //await sink.flush();
        //await sink.close();

      });
      //var now = new DateTime.now();
    });

    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

    //SharedPreferences paso #2
    final prefst = await SharedPreferences.getInstance();
    final totalreal = prefst.getDouble('totalProducto') ?? 0.0;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Carrito de compra', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
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
                            Text('Cantidad', style: TextStyle(fontSize:  15, fontWeight: FontWeight.bold),),
                            Text('Articulo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            Text('Total', style: TextStyle(fontSize:  15, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistadecarrito.where('correocliente', isEqualTo: correoPersonal).where("folio", isEqualTo: _myDocCount.length+1).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if (!snapshot.hasData) {
                          return Text("Loading..");
                        }
                        //reference.where("title", isEqualTo: 'UID').snapshots(),

                        else
                        {
                          return ListView(
                            children: snapshot.data!.docs.map((documents) {

                              //LAS VARIABLES QUE DELCARO AQUI HACEN EL BAD STATE!!!!!!!

                              return InkWell(
                                onTap: () async{

                                  print("ibai");
                                  //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);


                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                  //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                  //),);

                                },
                                child: Card(
                                  child: Stack(
                                    children:[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              InkWell(
                                                  child: Icon(Icons.delete, color: Colors.red[800]),
                                                onTap: () async {
                                                  SharedPreferences preferences = await SharedPreferences.getInstance();
                                                  await preferences.remove('totalProducto');

                                                  Navigator.of(context).pop();

                                                  final String newid2 = documents["newid"];
                                                  _borrarElemento(context, newid2);
                                                },
                                              ),
                                              Text(documents["cantidad"].toString()),
                                              Column(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 180,
                                                      child: Text(documents["nombreProducto"], style: TextStyle(fontSize: 15.0),),
                                                    ),
                                                    //Text(codigodebarra, style: TextStyle(fontSize: 12)),
                                                  ]
                                              ),
                                              Text("\$"+documents["totalProducto"].toString()),
                                              //Text(telefonoProveedor),
                                            ],
                                          ),
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
                  ),
                ),
                Text('SUBTOTAL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text(totalreal.toString(), style: TextStyle(fontSize: 25),),
                totalreal == 0.0?
                    Container()
                :
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.red[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Pagar', style: TextStyle(color: Colors.white),),
                      onPressed: () async {

                        QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                        List<DocumentSnapshot> _myDocCount = _myDoc.docs;
                        int folio = _myDocCount.length;

                        final prefs4 = await SharedPreferences.getInstance();
                        final sucursal = prefs4.getString('sucursal') ?? "";
                        final servicio = prefs4.getString('servicio') ?? "";

                        await Navigator.push(context, MaterialPageRoute(builder: (context) => comprar_ahora(nota_modelo("", "", folio,0,"newid",widget.empresa, totalreal, "sucursal",0,0,servicio, widget.correoEmpresa,""))),);

                        print("Dr. House "+widget.empresa);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void borrar(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('totalProducto');
    await preferences.remove('sucursal');
  }

  @override
  void initState() {
    print(widget.empresa);
    borrar(context);
    // TODO: implement initState
    //promoNotificacion(context);
    comprasNotificacion(context);
    //comprasNotificacion(context);
    notificacionesCarrito(context);
    super.initState();
  }


  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }

  @override
  void dispose() {
    //_borrarElemento(context);
    // TODO: implement dispose
    super.dispose();
  }

  CollectionReference reflistadeclientes1 = FirebaseFirestore.instance.collection('Clientes');

  bool ropa = true, zapatos = true, bolsas = true, filtroropa = false, filtrozap = false, filtrobolsa = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cantidadDeProducto = TextEditingController();

  int _itemCount = 1;

  Widget _buildAboutDialog(BuildContext context, String foto, String nombreProducto, double costo, String descripcion, String empresa, String categoriap, String newid, String codigo) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) =>  ListView(
        children: <Widget>[
          AlertDialog(
            title: Row(children:[Text(empresa, style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))]),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.end,

              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {

                        //await Navigator.push(context, MaterialPageRoute(builder: (context) => Producto_Detalle2(Cajas_Modelo(null, nombreProducto,"fecha",0,2,3,4,5,descripcion, empresa,foto,"f", newid, costo))),);

                        print("Precio: "+costo.toString());
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 230.0,
                          height: 230.0,
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
                    ),
                  ],
                ),
                SizedBox(height:10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 200.0,
                          child: Text(
                            nombreProducto,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('\$$costo', style: TextStyle(fontSize: 25, color: Colors.red[300], fontStyle: FontStyle.italic),),
                      ],
                    ),
                    SizedBox(height:5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //spinnerMedida(newid),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              InkWell(
                                onTap:(){

                                  setState(()=>_itemCount--);

                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('-', style: TextStyle(fontSize: 25, color: Colors.white))
                                      //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red[800]),
                                ),
                              ),
                              SizedBox(width:10),
                              Text(_itemCount.toString(), style: TextStyle(fontSize: 25, color: Colors.black),),
                              SizedBox(width:10),
                              InkWell(
                                onTap:(){

                                  setState(()=>_itemCount++);

                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('+', style: TextStyle(fontSize: 25, color: Colors.white))
                                      //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red[800]),
                                ),
                              ),                            ]
                        )
                      ],
                    ),
                  ],
                ),

                //MEDIDAS
                //AQUI HACER LA CONDICION DE SUBCATEGORIA PARA MOSTRAR MEDIDAS O NUMEROS O NADA
                //AL MOMENTO DE COBRAR
                //medidaNumero(context, newid),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(descripcion),
                  ],
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
                              color: Colors.red[800],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Agregar a carrito', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                setState(() {
                                  _itemCount = 1;
                                  notificacionesCarrito(context);
                                });

                                QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
                                List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                                final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
                                DocumentReference docReference = collRef.doc();

                                var now = new DateTime.now();

                                //double precio = double.parse(_precio.text);

                                double resultado = _itemCount * costo;

                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final User? user2 = auth.currentUser;
                                final correoPersonal = user2!.email;

                                docReference.set({
                                  'costo': costo,
                                  'codigo': codigo,
                                  //'tipo': tipo,
                                  'correocliente': correoPersonal,
                                  'descripcion': descripcion,
                                  'totalProducto': resultado,
                                  'cantidad': _itemCount,
                                  'folio': _myDocCount.length+1,
                                  'newid': docReference.id,
                                  //'precioVenta': precio,
                                  'foto': foto,
                                  'id': "987",
                                  'nombreProducto': nombreProducto,
                                  'foto': foto,
                                  'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                                });
                                //countDocuments();
                                //Navigator.of(context).pop();
                                _cantidadDeProducto.clear();
                                Toast.show("¡Agregado exitosamente!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

                                Navigator.of(context).pop();

                                //BLOQUE DE CODIGO PARA NOTIFICACION PARA COMPRAS EN CARRITO
                                QuerySnapshot _myDocE = await FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('correocliente', isEqualTo: correoPersonal).where('folio', isEqualTo: _myDocCount.length+1).get();
                                List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
                                //print('Weed: '+ _myDocCountE.length.toString() +1.toString());
                                print('hey');
                                var total = _myDocCountE.length;
                                FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correoPersonal.toString()).update({
                                  'notificacion': total.toString(),
                                  'correo': correoPersonal,
                                });

                                SharedPreferences preferences = await SharedPreferences.getInstance();
                                await preferences.remove('totalProducto');
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


                  setState(() {

                    //medida = null;

                  });

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('¿Deseas salir de la compra?'),
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

                      //signOut();
                      //Navigator.of(context).pushNamed("/clientes_login");
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

        floatingActionButton: notificacionesCarrito(context),
        body: StreamBuilder(
          //YA QUE SE ABRA CANIRAC DEJARLA EN EL CEL PARA SCREENSHOTS, ABRIR ANCESTRAL Y REVISAR LA LISTA DE CLIENTES
          //DESPUES SUBIRLA RAPIDO A PLAY STORE.
            stream: reflistaproduccion.where('empresa', isEqualTo:  widget.empresa).orderBy('categoria', descending: false).orderBy('nombreProducto', descending: false).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData) {
                return Text("Loading..");
              }
              //reference.where("title", isEqualTo: 'UID').snapshots(),

              else
              {
                return ListView(
                  children: snapshot.data!.docs.map((documents) {

                    //LAS VARIABLES QUE DELCARO AQUI HACEN EL BAD STATE!!!!!!!

                    return InkWell(
                      onTap: () async{

                        var foto = documents["foto"];
                        var newid = documents["newid"];

                        showDialog(context: context, builder: (BuildContext context) =>  _buildAboutDialog(context,  documents["foto"],  documents["nombreProducto"],  documents["costoProducto"],  documents["descripcion"],  "",  "",  documents["newid"],  ""));

                        FirebaseFirestore.instance.collection('Pedidos_Jimena').doc(newid).update({
                          'visto': 'si',
                          'estado': 'Recibido',
                        });

                      },
                      child: Card(
                        child: Row(
                          children:[
                            Row(
                                children:[
                                  Container(
                                    width: 200.0,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(documents["foto"]),
                                      ),
                                      //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                      color: Colors.transparent,
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
                                            Container(
                                              child: Text(documents["nombreProducto"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black45),),
                                              //height: 30,
                                              width: 100,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(documents["descripcion"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black26),),
                                              //height: 30,
                                              width: 100,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              child: Text("\$"+documents["costoProducto"].toString(), style: TextStyle(color: Colors.red[800], fontSize: 25),),
                                              //height: 30,
                                              width: 100,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                ]
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            }
        ),
      ),
    );
  }
}

//ABRIR BAJAFOOD PARA IMPLEMENTAR BOTON DE CARRITO D COMPRASS Y CONTINUA CO EL PROCESO