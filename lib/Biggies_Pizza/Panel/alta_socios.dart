import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:w1dm/Biggies_Pizza/Clientes/home.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';


class alta_socios extends StatefulWidget {
  const alta_socios({Key? key}) : super(key: key);

  @override
  _alta_sociosState createState() => _alta_sociosState();
}

class _alta_sociosState extends State<alta_socios> {

  CollectionReference reflistadecarrito = FirebaseFirestore.instance.collection('Socios_Registro');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    centerTitle: true,
    backgroundColor: Colors.purple[900],
    title: Text('Socios La Festa Pizzas'),
    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[900],
        child: Icon(Icons.add),
        onPressed: (){

          Navigator.of(context).pushNamed('/direccion_registro_nuevo');

          //showDialog(context: context, builder: (BuildContext context) =>  altaNuevaNota(context));

          //_sheetCarrito(context);
        },
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.all(20),
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Column(
                    children: [
                      InkWell(
                        onTap: (){

                          setState(() {
                            americana = false;
                            italiana = false;
                            sushi = false;
                            mexicana = false;
                            alitas = false;
                          });
                          print("americana");

                        },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
              child: SizedBox(
                height: 80,
                width: 80,
                          child: Image.asset('images/pizzeria.png'),
              ),
            ),
                      ),
                      Text('Todos'),
                    ],
                  ),
                  SizedBox(width: 25,),
                  Column(
                    children: [
                      InkWell(
                        onTap: (){

                          setState(() {
                            americana = true;
                            italiana = false;
                            sushi = false;
                            mexicana = false;
                            alitas = false;
                          });
                          print("americana");

                        },
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.asset('images/hamburguer.png'),
                        ),
                      ),
                      Text('Americana'),
                    ],
                  ),
                  SizedBox(width: 25,),
                  Column(
                    children: [
                      InkWell(
                        onTap: (){

                          print("hola");

                          setState(() {
                            americana = false;
                            italiana = true;
                            sushi = false;
                            mexicana = false;
                            alitas = false;
                          });

                        },
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.asset('images/pizza.png'),
                        ),
                      ),
                      Text('Italiana'),
                    ],
                  ),
                  SizedBox(width: 25,),
                  Column(
                    children: [
                      InkWell(
                        onTap: (){

                          print("hola");

                          setState(() {
                            americana = false;
                            italiana = false;
                            sushi = true;
                            mexicana = false;
                            alitas = false;
                          });

                        },
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Image.asset('images/sushi.png'),
                        ),
                      ),
                      Text('Sushi'),
                    ],
                  ),
                  SizedBox(width: 25,),
                  Column(
                    children: [
                      InkWell(
                        onTap: (){

                          print("hola");

                          setState(() {

                            americana = false;
                            italiana = false;
                            sushi = false;
                            mexicana = true;
                            alitas = false;
                          });
                        },
                        child: SizedBox(
                          child: Image.asset('images/taco.png'),
                          height: 80,
                          width: 80,),
                      ),
                      Text('Mexicana'),
                    ],
                  ),
                  SizedBox(width: 25,),
                  Column(
                    children: [
                      InkWell(
                        onTap: (){

                          setState(() {

                            americana = false;
                            italiana = false;
                            sushi = false;
                            mexicana = false;
                            alitas = true;
                          });
                          print("hola");
                        },
                        child: SizedBox(
                          child: Image.asset('images/wing.png'),
                          height: 80,
                          width: 80,),
                      ),
                      Text('Alitas'),
                    ],
                  ),
                ],
              )
          ),

          americana == true?
          Expanded(
            child: StreamBuilder(
              //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                stream: reflistadecarrito.where('categoria', isEqualTo: "Americana").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");

                  }
                  //reference.where("title", isEqualTo: 'UID').snapshots(),

                  else
                  {
                    Map<String, dynamic> documentsconfircarrito = snapshot.data! as Map<String, dynamic>;

                    var current = DateTime.now();

                    String nombreProducto = documentsconfircarrito['empresa'].toString();
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
                    int salida  = documentsconfircarrito['salida'];
                    int minutosSalida  = documentsconfircarrito['minutosSalida'];
                    String colonia = documentsconfircarrito['colonia'].toString();
                    String calle = documentsconfircarrito['calle'].toString();
                    String numero = documentsconfircarrito['numero'].toString();

                    return ListTile(
                      onLongPress: (){

                        _borrarElemento(context, correoRestaurante);
                        print("borrarlo");

                      },
                      onTap: () async{


                      },
                      title: Card(

                        elevation: 7.0,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom:60.0),
                              child: InkWell(
                                onTap: () async{

                                  //_sheetCarrito(context, foto, nombreProducto);
                                  //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                  //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('correoresta', correoRestaurante);

                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) => Home(Cajas_Modelo(null, nombreProducto,fecha,minutosSalida,entrada, salida,4,5,numero,correoRestaurante,colonia, calle, newid, 0))),);
                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                  //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                  //),);
                                  print("newid:"+newid);



                                  final startTime = DateTime(2018, 6, 23, 10, 30);
                                  final endTime = DateTime(2018, 6, 23, 13, 00);

                                  final currentTime = DateTime.now();

                                  if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                    print(currentTime);
                                    print("hora");
                                    // do something
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    //width: 100.0,
                                    //height: 100.0,
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
                            ),
                            //Container(color: Colors.black12,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(nombreProducto, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                        //height: 30,
                                        width: 300,
                                      ),
                                      //SizedBox(width: 5,),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child:
                                        current.hour >= entrada && current.hour < salida?
                                        Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                            :
                                        Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                        width: 200,
                                      ),
                                      SizedBox(
                                        child:
                                        minutosSalida == null?
                                        Text(entrada.toString()+":00 a "+salida.toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                            :
                                        Text(entrada.toString()+":00 a "+salida.toString()+":$minutosSalida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                        //height: 30,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    );
                  }
                }
            ),
          )
              :
          italiana == true?
          Expanded(
            child: StreamBuilder(
              //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                stream: reflistadecarrito.where('categoria', isEqualTo: "Italiana").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");

                  }
                  //reference.where("title", isEqualTo: 'UID').snapshots(),

                  else
                  {
                    Map<String, dynamic> documentsconfircarrito = snapshot.data! as Map<String, dynamic>;

                    var current = DateTime.now();

                    String nombreProducto = documentsconfircarrito['empresa'].toString();
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
                    int salida  = documentsconfircarrito['salida'];
                    int minutosSalida  = documentsconfircarrito['minutosSalida'];
                    String colonia = documentsconfircarrito['colonia'].toString();
                    String calle = documentsconfircarrito['calle'].toString();
                    String numero = documentsconfircarrito['numero'].toString();

                    return ListTile(
                      onLongPress: (){

                        _borrarElemento(context, correoRestaurante);
                        print("borrarlo");

                      },
                      onTap: () async{


                      },
                      title: Card(

                        elevation: 7.0,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom:60.0),
                              child: InkWell(
                                onTap: () async{

                                  //_sheetCarrito(context, foto, nombreProducto);
                                  //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                  //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('correoresta', correoRestaurante);

                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) => Home(Cajas_Modelo(null, nombreProducto,fecha,minutosSalida,entrada, salida,4,5,numero,correoRestaurante,colonia, calle, newid, 0))),);
                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                  //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                  //),);
                                  print("newid:"+newid);



                                  final startTime = DateTime(2018, 6, 23, 10, 30);
                                  final endTime = DateTime(2018, 6, 23, 13, 00);

                                  final currentTime = DateTime.now();

                                  if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                    print(currentTime);
                                    print("hora");
                                    // do something
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    //width: 100.0,
                                    //height: 100.0,
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
                            ),
                            //Container(color: Colors.black12,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(nombreProducto, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                        //height: 30,
                                        width: 300,
                                      ),
                                      //SizedBox(width: 5,),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child:
                                        current.hour >= entrada && current.hour < salida?
                                        Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                            :
                                        Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                        width: 200,
                                      ),
                                      SizedBox(
                                        child:
                                        minutosSalida == null?
                                        Text(entrada.toString()+":00 a "+salida.toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                            :
                                        Text(entrada.toString()+":00 a "+salida.toString()+":$minutosSalida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                        //height: 30,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    );
                  }
                }
            ),
          )
              :
          sushi == true?
          Expanded(
            child: StreamBuilder(
              //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                stream: reflistadecarrito.where('categoria', isEqualTo: "Sushi").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");

                  }
                  //reference.where("title", isEqualTo: 'UID').snapshots(),

                  else
                  {
                    Map<String, dynamic> documentsconfircarrito = snapshot.data! as Map<String, dynamic>;

                    var current = DateTime.now();

                    String nombreProducto = documentsconfircarrito['empresa'].toString();
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
                    int salida  = documentsconfircarrito['salida'];
                    int minutosSalida  = documentsconfircarrito['minutosSalida'];
                    String colonia = documentsconfircarrito['colonia'].toString();
                    String calle = documentsconfircarrito['calle'].toString();
                    String numero = documentsconfircarrito['numero'].toString();

                    return ListTile(
                      onLongPress: (){

                        _borrarElemento(context, correoRestaurante);
                        print("borrarlo");

                      },
                      onTap: () async{


                      },
                      title: Card(

                        elevation: 7.0,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom:60.0),
                              child: InkWell(
                                onTap: () async{

                                  //_sheetCarrito(context, foto, nombreProducto);
                                  //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                  //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('correoresta', correoRestaurante);

                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) => Home(Cajas_Modelo(null, nombreProducto,fecha,minutosSalida,entrada, salida,4,5,numero,correoRestaurante,colonia, calle, newid, 0))),);
                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                  //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                  //),);
                                  print("newid:"+newid);



                                  final startTime = DateTime(2018, 6, 23, 10, 30);
                                  final endTime = DateTime(2018, 6, 23, 13, 00);

                                  final currentTime = DateTime.now();

                                  if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                    print(currentTime);
                                    print("hora");
                                    // do something
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    //width: 100.0,
                                    //height: 100.0,
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
                            ),
                            //Container(color: Colors.black12,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(nombreProducto, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                        //height: 30,
                                        width: 300,
                                      ),
                                      //SizedBox(width: 5,),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child:
                                        current.hour >= entrada && current.hour < salida?
                                        Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                            :
                                        Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                        width: 200,
                                      ),
                                      SizedBox(
                                        child:
                                        minutosSalida == null?
                                        Text(entrada.toString()+":00 a "+salida.toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                            :
                                        Text(entrada.toString()+":00 a "+salida.toString()+":$minutosSalida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                        //height: 30,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    );
                  }
                }
            ),
          )
              :
          mexicana == true?
          Expanded(
            child: StreamBuilder(
              //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                stream: reflistadecarrito.where('categoria', isEqualTo: "Mexicana").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");

                  }
                  //reference.where("title", isEqualTo: 'UID').snapshots(),

                  else
                  {
                    Map<String, dynamic> documentsconfircarrito = snapshot.data! as Map<String, dynamic>;

                    var current = DateTime.now();

                    String nombreProducto = documentsconfircarrito['empresa'].toString();
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
                    int salida  = documentsconfircarrito['salida'];
                    int minutosSalida  = documentsconfircarrito['minutosSalida'];
                    String colonia = documentsconfircarrito['colonia'].toString();
                    String calle = documentsconfircarrito['calle'].toString();
                    String numero = documentsconfircarrito['numero'].toString();

                    return ListTile(
                      onLongPress: (){

                        _borrarElemento(context, correoRestaurante);
                        print("borrarlo");

                      },
                      onTap: () async{


                      },
                      title: Card(

                        elevation: 7.0,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom:60.0),
                              child: InkWell(
                                onTap: () async{

                                  //_sheetCarrito(context, foto, nombreProducto);
                                  //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                  //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('correoresta', correoRestaurante);

                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) => Home(Cajas_Modelo(null, nombreProducto,fecha,minutosSalida,entrada, salida,4,5,numero,correoRestaurante,colonia, calle, newid, 0))),);
                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                  //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                  //),);
                                  print("newid:"+newid);



                                  final startTime = DateTime(2018, 6, 23, 10, 30);
                                  final endTime = DateTime(2018, 6, 23, 13, 00);

                                  final currentTime = DateTime.now();

                                  if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                    print(currentTime);
                                    print("hora");
                                    // do something
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    //width: 100.0,
                                    //height: 100.0,
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
                            ),
                            //Container(color: Colors.black12,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(nombreProducto, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                        //height: 30,
                                        width: 300,
                                      ),
                                      //SizedBox(width: 5,),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child:
                                        current.hour >= entrada && current.hour < salida?
                                        Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                            :
                                        Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                        width: 200,
                                      ),
                                      SizedBox(
                                        child:
                                        minutosSalida == null?
                                        Text(entrada.toString()+":00 a "+salida.toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                            :
                                        Text(entrada.toString()+":00 a "+salida.toString()+":$minutosSalida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                        //height: 30,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    );
                  }
                }
            ),
          )
              :
          alitas == true?
          Expanded(
            child: StreamBuilder(
              //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                stream: reflistadecarrito.where('categoria', isEqualTo: "Alitas").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");

                  }
                  //reference.where("title", isEqualTo: 'UID').snapshots(),

                  else
                  {
                    Map<String, dynamic> documentsconfircarrito = snapshot.data! as Map<String, dynamic>;

                    var current = DateTime.now();

                    String nombreProducto = documentsconfircarrito['empresa'].toString();
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
                    int salida  = documentsconfircarrito['salida'];
                    int minutosSalida  = documentsconfircarrito['minutosSalida'];
                    String colonia = documentsconfircarrito['colonia'].toString();
                    String calle = documentsconfircarrito['calle'].toString();
                    String numero = documentsconfircarrito['numero'].toString();

                    return ListTile(
                      onLongPress: (){

                        _borrarElemento(context, correoRestaurante);
                        print("borrarlo");

                      },
                      onTap: () async{


                      },
                      title: Card(

                        elevation: 7.0,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom:60.0),
                              child: InkWell(
                                onTap: () async{

                                  //_sheetCarrito(context, foto, nombreProducto);
                                  //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                  //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('correoresta', correoRestaurante);

                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) => Home(Cajas_Modelo(null, nombreProducto,fecha,minutosSalida,entrada, salida,4,5,numero,correoRestaurante,colonia, calle, newid, 0))),);
                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                  //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                  //),);
                                  print("newid:"+newid);



                                  final startTime = DateTime(2018, 6, 23, 10, 30);
                                  final endTime = DateTime(2018, 6, 23, 13, 00);

                                  final currentTime = DateTime.now();

                                  if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                    print(currentTime);
                                    print("hora");
                                    // do something
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    //width: 100.0,
                                    //height: 100.0,
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
                            ),
                            //Container(color: Colors.black12,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(nombreProducto, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                        //height: 30,
                                        width: 300,
                                      ),
                                      //SizedBox(width: 5,),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child:
                                        current.hour >= entrada && current.hour < salida?
                                        Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                            :
                                        Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                        width: 200,
                                      ),
                                      SizedBox(
                                        child:
                                        minutosSalida == null?
                                        Text(entrada.toString()+":00 a "+salida.toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                            :
                                        Text(entrada.toString()+":00 a "+salida.toString()+":$minutosSalida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                        //height: 30,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    );
                  }
                }
            ),
          )
              :
          Expanded(
            child: StreamBuilder(
              //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                stream: reflistadecarrito.where('id', isEqualTo: "123").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");

                  }
                  //reference.where("title", isEqualTo: 'UID').snapshots(),

                  else
                  {
                    Map<String, dynamic> documentsconfircarrito = snapshot.data! as Map<String, dynamic>;

                    var current = DateTime.now();

                    String nombreProducto = documentsconfircarrito['empresa'].toString();
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
                    int salida  = documentsconfircarrito['salida'];
                    int minutosSalida  = documentsconfircarrito['minutosSalida'];
                    String colonia = documentsconfircarrito['colonia'].toString();
                    String calle = documentsconfircarrito['calle'].toString();
                    String numero = documentsconfircarrito['numero'].toString();

                    return ListTile(
                      onLongPress: (){

                        _borrarElemento(context, correoRestaurante);
                        print("borrarlo");

                      },
                      onTap: () async{


                      },
                      title: Card(

                        elevation: 7.0,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom:60.0),
                              child: InkWell(
                                onTap: () async{

                                  //_sheetCarrito(context, foto, nombreProducto);
                                  //   showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, foto, nombreProducto, costo, descripcion, empresa, categoriap, newid, codigo),);
                                  //_sheetComanda2(context, costo,  descripcion,  nombreProducto, foto);

                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('correoresta', correoRestaurante);

                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) => Home(Cajas_Modelo(null, nombreProducto,fecha,minutosSalida,entrada, salida,4,5,numero,correoRestaurante,colonia, calle, newid, 0))),);
                                  //await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  //AGREGAR EL TOTAL POARA PASARLO A LA SIGUIENTE PANTALLA
                                  //Carpitneria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3,4,5,"","","e","f", newid, costoproducto))
                                  //),);
                                  print("newid:"+newid);



                                  final startTime = DateTime(2018, 6, 23, 10, 30);
                                  final endTime = DateTime(2018, 6, 23, 13, 00);

                                  final currentTime = DateTime.now();

                                  if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {

                                    print(currentTime);
                                    print("hora");
                                    // do something
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    //width: 100.0,
                                    //height: 100.0,
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
                            ),
                            //Container(color: Colors.black12,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(nombreProducto, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                        //height: 30,
                                        width: 300,
                                      ),
                                      //SizedBox(width: 5,),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child:
                                        current.hour >= entrada && current.hour < salida?
                                        Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                            :
                                        Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                        width: 200,
                                      ),
                                      SizedBox(
                                        child:
                                        minutosSalida == null?
                                        Text(entrada.toString()+":00 a "+salida.toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                            :
                                        Text(entrada.toString()+":00 a "+salida.toString()+":$minutosSalida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

                                        //height: 30,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    );
                  }
                }
            ),
          ),
        ],
      ),
    );
  }
}