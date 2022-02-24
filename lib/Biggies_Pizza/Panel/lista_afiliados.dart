import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:w1dm/Biggies_Pizza/Clientes/home.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';


class lista_afiliados extends StatefulWidget {
  @override
  lista_afiliadosState createState() => lista_afiliadosState();
}

class lista_afiliadosState extends State<lista_afiliados> {

  CollectionReference reflistadecarrito = FirebaseFirestore.instance.collection('Socios_Registro');

  Widget ejem (){
    Widget horizontalList1 = Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(width: 160.0, color: Colors.red,),
            Container(width: 160.0, color: Colors.orange,),
            Container(width: 160.0, color: Colors.pink,),
            Container(width: 160.0, color: Colors.yellow,),
          ],
        )
    );
    return horizontalList1;
  }

  bool americana = false, italiana = false, sushi = false, mexicana = false, alitas = false, dish = false;


  var now = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
    Navigator.pop(context);

  }

  DateTime startTime = DateTime(2018, 6, 23, 10, 30);
  DateTime endTime = DateTime(2018, 6, 23, 13, 00);

  DateTime currentTime = DateTime.now();

  DateTime current = DateTime.now();

  void _borrarElemento (BuildContext context, correoRestaurante) async {
    var category;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas borrar esta sucursal de manera permanente?', style: TextStyle(color: Colors.black)),
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

  listaTodos(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('id', isEqualTo: "123").snapshots(),
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

                    onLongPress: () async{
                      _borrarElemento(context, documents["correo"]);
                      //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                    },
                    child: Card(
                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom:10.0),
                            child: InkWell(
                              onLongPress: () async{
                                _borrarElemento(context, documents["correo"]);

                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 250.0,
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
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
                                      //height: 30,
                                      width: 200,
                                    ),
                                    //SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

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
                }).toList(),
              );
            }
          }
      ),
    );
  }
  listaMariscos(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Mariscos").snapshots(),
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

                    onLongPress: () async{
                      _borrarElemento(context, documents["correo"]);
                      //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onLongPress: () async{
                                _borrarElemento(context, documents["correo"]);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
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
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
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
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

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
                }).toList(),
              );
            }
          }
      ),
    );
  }
  listaAmericana(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Americana").snapshots(),
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

                    onLongPress: () async{
                      _borrarElemento(context, documents["correo"]);
                      //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onLongPress: () async{
                                _borrarElemento(context, documents["correo"]);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
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
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
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
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

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
                }).toList(),
              );
            }
          }
      ),
    );
  }
  listaItaliana(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Italiana").snapshots(),
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

                    onLongPress: () async{
                      _borrarElemento(context, documents["correo"]);
                      //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onLongPress: () async{
                                _borrarElemento(context, documents["correo"]);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
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
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
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
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

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
                }).toList(),
              );
            }
          }
      ),
    );
  }
  listaSushi(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Sushi").snapshots(),
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

                    onLongPress: () async{
                      _borrarElemento(context, documents["correo"]);
                      //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onLongPress: () async{
                                _borrarElemento(context, documents["correo"]);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
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
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
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
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

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
                }).toList(),
              );
            }
          }
      ),
    );
  }
  listaMex(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correo = user!.email;
    return Expanded(
      child: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: reflistadecarrito.where('categoria', isEqualTo: "Mexicana").snapshots(),
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

                    onLongPress: () async{
                      _borrarElemento(context, documents["correo"]);
                      //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                    },
                    child: Card(

                      elevation: 7.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom:60.0),
                            child: InkWell(
                              onLongPress: () async{
                                _borrarElemento(context, documents["correo"]);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("", documents["empresa"],documents["miembrodesde"],documents["minutosSalida"],documents["entrada"], documents["salida"],4,5,documents["numero"],documents["correo"],documents["colonia"], documents["calle"], documents["empresa"], 0))),);

                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  height: 350.0,
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
                                    Container(
                                      child: Text(documents["empresa"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black45),),
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
                                    Container(
                                      child:
                                      documents["negocio"] =="cerrado"?
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),)
                                          :
                                      current.hour >= documents["entrada"] && current.hour < documents["salida"]?
                                      Text("ABIERTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.green[800]),)
                                          :
                                      Text("CERRADO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.red[800]),),
                                      width: 200,
                                    ),
                                    Container(
                                      child:
                                      documents["minutosSalida"] == null?
                                      Text(documents["entrada"].toString()+":00 a "+documents["minutosSalida"].toString()+":00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),)
                                          :
                                      Text(documents["entrada"].toString()+":00 a "+documents["salida"].toString()+":"+documents["minutosSalida"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.black45),),

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
                }).toList(),
              );
            }
          }
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
                content: Text('¿Deseas cerrar sesión?'),
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
                      Navigator.pop(context);
                      },
                  ),
                ],
              );
            }
        );

        return value == true;
      },
      child: Scaffold(
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
          foregroundColor: Colors.orange[100],
          elevation: 1.0,
          shape: CircleBorder(),
          children: [

            //SpeedDialChild(
            //    child: Icon(Icons.timer, color: Colors.white,),
            //  backgroundColor: Colors.black,
            //  label: 'Tiempo de Espera',
            //  onTap: () {

            //    showDialog(context: context, builder: (BuildContext context) =>  _buildAboutDialogTi(context));

            //        }
            //),

            SpeedDialChild(
                child: Icon(Icons.add, color: Colors.orange[100],),
                backgroundColor: Colors.red[800],
                label: 'Agregar sucursal',
                onTap: () async {

                  Navigator.of(context).pushNamed('/direccion_registro_nuevo');
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.credit_card_outlined, color: Colors.orange[100],),
                backgroundColor: Colors.red[800],
                label: 'Agregar tarjeta de debito',
                onTap: () async {

                  Navigator.of(context).pushNamed('/alta_tarjeta');
                }
            ),
            //  SpeedDialChild(
            //  child: Icon(Icons.add, color: Colors.white,),
            //  backgroundColor: Colors.orange[900],
            //  label: 'Agregar Oferta',
            //  onTap: () async {

            //    Navigator.of(context).pushNamed('/alta_promociones');

            //        }
            // ),
            //SpeedDialChild(
            //    child: Icon(Icons.add, color: Colors.white,),
            //  backgroundColor: Colors.orange[900],
            //  label: 'Agregar Extras',
            //  onTap: () async {

            //          _sheetExtras(context);

            //        }
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
        appBar: AppBar(
          centerTitle: true,
          title: Text("Panel La Festa Pizzas"),
          backgroundColor: Colors.red[800],
        ),
        body: Column(
          children: [
            listaTodos()
          ],
        ),
      ),
    );
  }
}