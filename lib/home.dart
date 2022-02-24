import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:html';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:w1dm/authentication.dart';//

class home extends StatefulWidget {

  var data;
  home({this.data});
  @override
  homeState createState() => homeState();
}

class homeState extends State<home> {

  homeState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombre = TextEditingController();

  String url = 'https://twitter.com/CryptoPlaymate';
  String urlD = 'https://discord.com';

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchURLDiscord(String urlD) async {
    if (await canLaunch(urlD)) {
      await launch(urlD, forceWebView: true);
    } else {
      throw 'Could not launch $urlD';
    }
  }

  final String imageUrl = "https://www.elcarrocolombiano.com/wp-content/uploads/2019/01/20190122-MPM-ERELIS-AUTO-DEPORTIVO-MAS-BARATO-01.jpg";


  Future<void> inicioSesion() async {
    // marked async
    AuthenticationHelper()
        .signIn(email: _emailController.text, password: _passwordController.text)
        .then((result) {
      if (result == null) {

        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/cryptactoe');

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home(cajas_modelo("","","",0,0,0,0,0,"","","","","",0))));
        //Toast.show("¡Has iniciado sesion!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

      } else {
        Toast.show("Incorrect password", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
      }
    });
  }

  Future _startUploadTask() async {

    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Players').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;

    AuthenticationHelper()
        .signUp(
        email: _emailController.text, password: _passwordController.text)
        .then((result) {
      if (result == null) {


        String nombre = _nombre.text;
        String correo = _emailController.text;


        final collRef = FirebaseFirestore.instance.collection('Players').doc(correo);

        //double costo = double.parse(_precio.text);
        var now = DateTime.now();

        collRef.set({
          'correo': _emailController.text,
          //'telefono': _tel.text,
          'contraseña': _passwordController.text,
          //'newid': docReference.documentID,
          'foto': "",
          'id': "123",
          //'colonia': _colonia.text,
          //'calle': _calle.text,
          //'numerocasa': _num.text,
          'nombre': "Crypto Playmate "+_myDocCount.toString(),
          //'foto': url,
          'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
        });

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).pushNamed('/cryptactoe');

      } else {
        print("");
      }
    });
  }

  void registro(){
    final FirebaseAuth auth = FirebaseAuth.instance;

    if(FirebaseAuth.instance.currentUser?.uid == null){
      // not logged
      Alert(
          context: context,
          title: "Sign Up",
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle, color: Color(0xFF815FD5)),
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: _passwordController,

                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Color(0xFF815FD5)),
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          buttons: [
            DialogButton(
              onPressed: () {

                _startUploadTask();
                //sinSesion2();
                //Navigator.of(context).pop();
                //Navigator.of(context).pop();

              },
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Color(0xFF815FD5),
            )
          ]).show();
    } else {
      // logged
      Navigator.of(context).pop();

    }

  }

  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }

  void sinSesion2(){
    final FirebaseAuth auth = FirebaseAuth.instance;

    if(FirebaseAuth.instance.currentUser?.uid == null){
      // not logged
      Alert(
          context: context,
          title: "Sign In",
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle, color: Colors.pinkAccent),
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: _passwordController,

                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Colors.pinkAccent),
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          buttons: [
            DialogButton(
              onPressed: () {

                inicioSesion();
                //signOut();

              },
              child: Text(
                "Sign In",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.pinkAccent,

            ),
            DialogButton(
              onPressed: () {

                registro();
                //Navigator.of(context).pushNamed('/registro');

              },
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.pinkAccent,
            )
          ]).show();
    } else {
      // logged
      Navigator.of(context).pushNamed("/cryptactoe_game");

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF293143),
          centerTitle: true,
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap:(){

                        Navigator.of(context).pushNamed('/whitepaper');


                      },
                      child: Row(
                          children: [
                            Icon(Icons.list, color: Color(0xFF815FD5)),
                            SizedBox(width:10),
                            Text('Whitepaper', style: TextStyle(color: Colors.white),),
                          ]
                      ),
                    ),
                    SizedBox(width: 15),

                    InkWell(
                      onTap:(){

                        Navigator.of(context).pushNamed("/roadmap");

                      },
                      child: Row(
                          children: [
                            Icon(Icons.account_tree, color: Colors.pinkAccent),
                            SizedBox(width:10),
                            Text('Roadmap', style: TextStyle(color: Colors.white),),
                          ]
                      ),
                    ),
                    SizedBox(width: 15),

                    InkWell(
                      onTap:(){
                        launchURL(url);
                      },
                      child: Row(
                          children: [
                            Icon(FontAwesomeIcons.twitter, color: Colors.lightBlueAccent),
                            SizedBox(width:10),
                            Text('Follow us', style: TextStyle(color: Colors.white),),
                          ]
                      ),
                    ),

                    SizedBox(width: 15),

                    InkWell(
                      onTap:(){
                        launchURLDiscord(urlD);
                      },
                      child: Row(
                          children: [
                            Icon(FontAwesomeIcons.discord, color: Color(0xFF815FD5)),
                            SizedBox(width:10),
                            Text('Join us', style: TextStyle(color: Colors.white),),
                          ]
                      ),
                    ),


                    SizedBox(width: 15),

                    InkWell(
                      onTap:(){
                        launchURLDiscord(urlD);
                      },
                      child: Row(
                          children: [
                            Icon(FontAwesomeIcons.linkedin, color: Colors.pinkAccent),
                            SizedBox(width:10),
                            Text('Contact us', style: TextStyle(color: Colors.white),),
                          ]
                      ),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap:(){
                        signOut();
                      },
                      child: Row(
                          children: [
                            Icon(Icons.exit_to_app, color: Colors.lightBlueAccent),
                            //SizedBox(width:10),
                            //Text('Contact us', style: TextStyle(color: Colors.white),),
                          ]
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: SpeedDial( //Boton flotante animado,
          //marginRight: 18,
          //marginBottom: 30,
          animatedIcon: AnimatedIcons.home_menu,
          animatedIconTheme: IconThemeData(size: 25.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: true,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Crypto Playmate',
          heroTag: 'Crypto Playmate',
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
          elevation: 1.0,
          shape: CircleBorder(),
          children: [

            SpeedDialChild(
                child: Icon(Icons.person, color: Colors.white,),
                backgroundColor: Color(0xFF815FD5),
                label: 'Team',
                onTap: () async {

                  Navigator.of(context).pushNamed('/team');
                  //Navigator.of(context).pushNamed('/admin_inicio');

                }
            ),

            SpeedDialChild(
                child: Icon(FontAwesomeIcons.networkWired, color: Colors.white,),
                backgroundColor: Colors.pinkAccent,
                label: 'NFT Power Cards',
                onTap: () async {

                  Navigator.of(context).pushNamed("/nft_power_cards");

                  //Navigator.of(context).pushNamed('/admin_inicio');

                }
            ),

            SpeedDialChild(
                child: Icon(FontAwesomeIcons.idCard, color: Colors.white),
                backgroundColor: Colors.lightBlueAccent,
                label: 'NFT Member',
                onTap: () async {

                  Navigator.of(context).pushNamed("/nft_members");

                  //Navigator.of(context).pushNamed('/admin_inicio');

                }
            ),


          ],
        ),
        backgroundColor: Color(0xFF171B26),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children:[
                    CarouselSlider(
                      items: [

                        //hola(),
                        InkWell(
                          onTap: () async {

                            bool sesion = false;

                            final FirebaseAuth auth = FirebaseAuth.instance;
                            if(FirebaseAuth.instance.currentUser?.email == null){
                              // not logged
                              setState(() {
                                sinSesion2();

                                sesion = false;
                                print("Sin pestania $sesion");
                              });

                            } else {
                              // logged
                              setState(() {
                                Navigator.of(context).pushNamed("/cryptactoe");

                                sesion = true;
                                print("Con pestania $sesion");
                              });
                            }

                            //sinSesion2();
                            //Navigator.of(context).pushNamed("/cryptactoe");
                          },
                          child: Container(
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("CRYPTACTOE", style: TextStyle(color: Colors.white, fontSize: 35), textAlign: TextAlign.center,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            color: Colors.pinkAccent,
                          ),
                        ),
                        InkWell(
                          onTap: () async {

                            bool sesion = false;

                            final FirebaseAuth auth = FirebaseAuth.instance;
                            if(FirebaseAuth.instance.currentUser?.email == null){
                              // not logged
                              setState(() {
                                sinSesion2();

                                sesion = false;
                                print("Sin pestania $sesion");
                              });

                            } else {
                              // logged
                              setState(() {
                                Navigator.of(context).pushNamed("/cryptactoe");

                                sesion = true;
                                print("Con pestania $sesion");
                              });
                            }

                            //sinSesion2();
                            //Navigator.of(context).pushNamed("/cryptactoe");
                          },
                          child: Container(
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("STONE, PAPER OR SCISSORS", style: TextStyle(color: Colors.white, fontSize: 35), textAlign: TextAlign.center,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            color: Colors.lightBlueAccent,

                          ),
                        ),
                        InkWell(
                          onTap: () async {

                            bool sesion = false;

                            final FirebaseAuth auth = FirebaseAuth.instance;
                            if(FirebaseAuth.instance.currentUser?.email == null){
                              // not logged
                              setState(() {
                                sinSesion2();

                                sesion = false;
                                print("Sin pestania $sesion");
                              });

                            } else {
                              // logged
                              setState(() {
                                Navigator.of(context).pushNamed("/cryptactoe");

                                sesion = true;
                                print("Con pestania $sesion");
                              });
                            }

                            //sinSesion2();
                            //Navigator.of(context).pushNamed("/cryptactoe");
                          },                        child: Container(
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("LOTTERY NFT", style: TextStyle(color: Colors.white, fontSize: 35), textAlign: TextAlign.center,)
                                  ],
                                )
                              ],
                            ),
                          ),
                          color: Color(0xFF815FD5),

                        ),
                        ),
                        InkWell(
                          onTap: () async {

                            bool sesion = false;

                            final FirebaseAuth auth = FirebaseAuth.instance;
                            if(FirebaseAuth.instance.currentUser?.email == null){
                              // not logged
                              setState(() {
                                sinSesion2();

                                sesion = false;
                                print("Sin  luca $sesion");
                              });

                            } else {
                              // logged
                              setState(() {
                                Navigator.of(context).pushNamed("/cryptactoe");

                                sesion = true;
                                print("Con pestania $sesion");
                              });
                            }

                            //sinSesion2();
                            //Navigator.of(context).pushNamed("/cryptactoe");
                          },
                          child: FittedBox(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("MEMORY NFT", style: TextStyle( color: Colors.white, fontSize: 35), textAlign: TextAlign.center,)
                                    ],
                                  )
                                ],
                              ),
                              color: Colors.pinkAccent,

                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        viewportFraction: 0.8,
                        height: 400,
                        autoPlay: true,
                        autoPlayCurve: Curves.easeInOut,
                        reverse: true,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.vertical,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Launch on Feb 13', style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}