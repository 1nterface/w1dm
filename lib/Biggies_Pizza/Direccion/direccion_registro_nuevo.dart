import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/carpinteria.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../authentication.dart';
import 'gerencia_login.dart';

class direccion_registro_nuevo extends StatefulWidget {

  //final LocationPermissionLevel permissionLevel;

  const direccion_registro_nuevo();

  @override
  direccion_registro_nuevoState createState() => direccion_registro_nuevoState();
}

class direccion_registro_nuevoState extends State<direccion_registro_nuevo> {
  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;

  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
  final TextEditingController _contrasenav = TextEditingController();
  final TextEditingController _calle = TextEditingController();
  final TextEditingController _num = TextEditingController();
  final TextEditingController _colonia = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _rfc = TextEditingController();
  final TextEditingController _nombreSucursal = TextEditingController();
  final TextEditingController _ref = TextEditingController();

  late bool _success;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _userEmail;


  void _msjNoEsIgual (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Tu contraseña no es la misma', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  void _msjCiudad (BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Elige una ciudad', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  Future _startUploadTask() async {

    AuthenticationHelper()
        .signUp(email: _correo.text, password: _contrasena.text)
        .then((result) {
      if (result == null) {

        //CMBIA ESTA LINEA, VER SI JALA EN LA MANIANA.
        Navigator.pop(context);

      } else {
        print("");
      }
    });

    final prefst = await SharedPreferences.getInstance();
    String hrcola = prefst.getString('hrcola') ?? "";

    var correo = _correo.text.toLowerCase();
    var contra = _contrasena.text.toLowerCase();
    var contrav = _contrasenav.text.toLowerCase();

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    //print(position.latitude.toDouble());
    //print(position.longitude.toDouble());
    var lat = position.latitude.toDouble();
    var lon = position.longitude.toDouble();
    print("Lat: "+lat.toString());
    print("Lon"+lon.toString());

    var now = DateTime.now();
    final collRef = FirebaseFirestore.instance.collection('Socios_Registro').doc(correo);

    collRef.set({
      'cta': '1234123412341234',
      'estado': 'Pendiente',
      'adomi':_isChecked == false?"no":"si",
      'recoger':_isChecked2 == false?"no":"si",
      'efectivo':_isCheckedEfe == false?"no":"si",
      'tarjeta':_isCheckedTar == false?"no":"si",

      'minutosSalida': minutos,
      //'categoria': categorr,
      'entrada': entrada,
      'salida': salida,
      //'latitud': lat,
      //'longitud': lon,
      //'ciudad': ciudad2,
      'calle': _calle.text,
      'numero': _num.text,
      //'sexo': sexo,
      'colonia': _colonia.text,
      'empresa': _nombreSucursal.text,
      'horallamada': hrcola,
      'correo': correo,
      'telefono': _tel.text,
      'contraseña': contra,
      //'newid': docReference.documentID,
      'id': "123",
      'negocio': "abierto",
      //'nombre': _nombre.text,
      'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
      'foto': "https://firebasestorage.googleapis.com/v0/b/la-festa-pizzas.appspot.com/o/logo.jpg?alt=media&token=65b88db1-5e2b-4d9a-a83f-105d7274d96c",
    });

    final collRef5 = FirebaseFirestore.instance.collection('Colonia');
    DocumentReference docReference = collRef5.doc();
    
    //int celular = int.parse(_celular.text);
    
    docReference.set({
      'correoNegocio': correo,
      'flete': 35.00,
      'colonia': _colonia.text,
      'newid': docReference.id,
    });


    FirebaseFirestore.instance.collection('Tiempo').doc(correo.toString()+"espera").set({
      'tiempor': "0",
      'tiempo': "0",
      'correoNegocio': correo,
    });

    //SE CREA LA COLECCION PARA QUE LAS NOTIFICACIONES EMPIECEN LEYENDO EN CERO
    FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+correo.toString()).set({'notificacion': "0"});
    FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos_Jimena_Interna"+correo.toString()).set({'notificacion': '0'});
    FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+correo.toString()).set({'notificacion': '0'});
    FirebaseFirestore.instance.collection('Notificaciones').doc("Promos").set({'notificacion': '0'});

    FirebaseFirestore.instance.collection('Clave').doc(correo).set({
      'clave': "12345",
      'correo': correo,
    });


    //Navigator.of(context).pop();
    //Toast.show("¡Ahora puedes iniciar sesion!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("La Festa Pizzas"),
      )),
      backgroundColor: Colors.red[800],
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 300,
              child: Container(
                padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                color: Colors.red[800],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: OnelookLogo()),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the shadow for the submit button
          buildBottomHalfContainer(true),
          //Main Contianer for Login and Signup
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? 200 : 230,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isSignupScreen ? 380 : 250,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "ALTA DE SUCURSAL",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[800]),
                        ),
                        if (!isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            height: 2,
                            width: 55,
                            color: Colors.red[800],
                          )
                      ],
                    ),
                    if (isSignupScreen)
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        height: 2,
                        width: 55,
                        color: Colors.red[800],
                      ),
                    if (isSignupScreen) buildSignupSection(),
                    if (!isSignupScreen) buildSigninSection()
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the submit button
          buildBottomHalfContainer(false),
          // Bottom buttons

        ],
      ),
    );
  }

  late String sexo;

  Container buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(Icons.mail_outline, "ejemplo@tucorreo.com", false, true),
          buildTextField(
              MaterialCommunityIcons.lock_outline, "**********", true, false),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    activeColor: Palette.textColor2,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = !isRememberMe;
                      });
                    },
                  ),
                  Text("Remember me",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1))
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text("Forgot Password?",
                    style: TextStyle(fontSize: 12, color: Palette.textColor1)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _textInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextField(
        //controller: _emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email,
              color: Colors.red[800]
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFA7BCC7)),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFA7BCC7)),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          hintText: 'Correo',
          hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

        ),
      ),
    );
  }

  late String ciudad;
  void _ventanaFlotante(BuildContext context){

    Alert(
        context: context,
        title: "ASEGURATE DE UBICARTE EN TU SUCURSAL O ALMACEN Y ENCENDER TU GPS PARA TOMAR LAS COORDENADAS CORRECTAS",
        //content: Icon(Icons.location_on, size: 40, color: Colors.red[900],),
        buttons: [
          DialogButton(
            color: Colors.red[800],
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text("Salir", style: TextStyle(color: Colors.white, fontSize: 15),),
              ],
            ),
          )
        ]).show();
  }
  void checkServiceStatusEfectivo(BuildContext context) {

      _startUploadTask();

  }

  var entrada, salida, minutos;

  Widget horarioEntrada(BuildContext context){
    return DropdownButton<int>(
        hint: Text("Hr Entrada", style: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7))),
        value: entrada,
        items: <int>[5, 6, 7, 8, 9, 10, 11].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            entrada = newVal;
          });
        });
  }
  Widget horarioSalida(BuildContext context){
    return DropdownButton<int>(
        hint: Text("Hr Salida" , style: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7))),
        value: salida,
        items: <int>[12,13,14,15,16,17,18,19,20,21,22,23].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            salida = newVal;
          });
        });
  }

  Widget minutosSalida(BuildContext context){
    return DropdownButton<int>(
        hint: Text("Minutos" , style: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7))),
        value: minutos,
        items: <int>[00,05,10,15,20,25,30,35,40,45,50,55].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            minutos = newVal;
          });
        });
  }

  var categorr;
  Widget categoria(BuildContext context){
    return DropdownButton<String>(
        hint: Text("Elige tu categoria", style: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7))),
        value: categorr,
        items: <String>["Mariscos", "Americana", "Mexicana", "Sushi", "Italiana"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            categorr = newVal;
          });
        });
  }

  late List<String> tipodepago, pagopago;

  bool _isChecked = false, _isChecked2 = false, _isChecked3 = false;
  bool _isCheckedEfe = false, _isCheckedTar = false;
  List<String> text = ["Recoger en establecimiento"];
  List<String> text2 = ["A Domicilio"];
  List<String> textefe = ["Efectivo"];
  List<String> texttar = ["Pago con tarjeta"];


  //String? ciudad2 = "";


  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [

            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa el nombre de tu negocio';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                controller: _nombreSucursal,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.business,
                      color: Colors.red[800]
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  hintText: 'Nombre del negocio',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),

              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(width: 20),
                SizedBox(width: 15),
                Text('Elige tu horario', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;

                      isMale == true?
                      sexo = "Mujer"
                          :
                      sexo = "Hombre";

                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.more_time, color: Colors.red[800]),
                      SizedBox(width: 15),
                      horarioEntrada(context),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;

                      isMale == false?
                      sexo = "Hombre"
                          :
                      sexo = "Mujer";
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.more_time, color: Colors.red[800]),
                      SizedBox(width: 15),
                      horarioSalida(context),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;

                      isMale == false?
                      sexo = "Hombre"
                          :
                      sexo = "Mujer";
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.more_time, color: Colors.red[800]),
                      SizedBox(width: 15),
                      minutosSalida(context),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(width: 20),
                SizedBox(width: 15),
                Text('Elige tus servicios', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.directions_car_rounded, color: Colors.red[800]),
                Expanded(
                  child: Column(
                    children: text
                        .map((t) => CheckboxListTile(
                      title: Text(t, style: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7))),
                      value: _isChecked,
                      onChanged: (val) async {

                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('servicio', text.toString());

                        setState(() {
                          print("no palomita");
                          _isChecked = val!;
                          if(_isChecked == true){
                            setState(() {
                              //_sheetCarrito(context);
                              print("palomita");
                              tipodepago = text;
                              //_isChecked2 = false;
                              //_isChecked3 = false;

                            });
                          }
                        });
                      },
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.add_location_sharp, color: Colors.red[800]),
                Expanded(
                  child: Column(
                    children: text2
                        .map((t) => CheckboxListTile(
                      title: Text(t, style: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7))),
                      value: _isChecked2,
                      onChanged: (val) async {

                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('servicio', text2.toString());

                        setState(() {
                          print("no palomita");
                          _isChecked2 = val!;
                          if(_isChecked2 == true){
                            setState(() {
                              //_sheetCarrito(context);
                              print("palomita");
                              tipodepago = text2;
                              //_isChecked = false;

                            });
                          }
                        });
                      },
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(width: 20),
                SizedBox(width: 15),
                Text('Elige tu tipo de pago', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.attach_money, color: Colors.red[800]),
                Expanded(
                  child: Column(
                    children: textefe
                        .map((t) => CheckboxListTile(
                      title: Text(t, style: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7))),
                      value: _isCheckedEfe,
                      onChanged: (val) async {

                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('servicio', textefe.toString());

                        setState(() {
                          print("no palomita");
                          _isCheckedEfe = val!;
                          if(_isCheckedEfe == true){
                            setState(() {
                              //_sheetCarrito(context);
                              print("palomita");
                              pagopago = textefe;
                              //_isCheckedTar = false;
                              //_isChecked3 = false;

                            });
                          }
                        });
                      },
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.credit_card, color: Colors.red[800]),
                Expanded(
                  child: Column(
                    children: texttar
                        .map((t) => CheckboxListTile(
                      title: Text(t, style: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7))),
                      value: _isCheckedTar,
                      onChanged: (val) async {

                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('servicio', texttar.toString());

                        setState(() {
                          print("no palomita");
                          _isCheckedTar = val!;
                          if(_isCheckedTar == true){
                            setState(() {
                              //_sheetCarrito(context);
                              print("palomita");
                              pagopago = texttar;
                              //_isCheckedEfe = false;

                            });
                          }
                        });
                      },
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa la colonia de tu negocio';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,

                controller: _colonia,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.map_rounded,
                      color: Colors.red[800]
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  hintText: 'Colonia',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa la calle de tu negocio';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,

                controller: _calle,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.map_rounded,
                      color: Colors.red[800]
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  hintText: 'Calle',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa el numero ext. de tu negocio';
                  }
                  return null;
                },
                controller: _num,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.arrow_forward_outlined,
                      color: Colors.red[800]
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  hintText: 'Numero local',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa el numero de telefono de tu negocio';
                  }
                  return null;
                },
                controller: _tel,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_android,
                      color: Colors.red[800]
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  hintText: 'Telefono principal de sucursal',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa el correo de tu negocio';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
                ],
                textCapitalization: TextCapitalization.none,
                controller: _correo,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email,
                      color: Colors.red[800]
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  hintText: 'Correo empresa',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa una contraseña de mas de 6  digitos';
                  }
                  return null;
                },
                controller: _contrasena,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key,
                      color: Colors.red[800]
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  hintText: 'Contraseña',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Escribe de nuevo tu contraseña';
                  }
                  return null;
                },
                controller: _contrasenav,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key,
                      color: Colors.red[800]
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFA7BCC7)),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  hintText: 'Vuelve a escribir tu contraseña',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),

            Container(
              width: 200,
              margin: EdgeInsets.only(top: 15),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Al presionar el boton aceptas haber leido y aceptado nuestros ",
                    style: TextStyle(color: Palette.textColor2),
                    children: [
                      TextSpan(
                        //recognizer: ,
                        text: "terminos y condiciones",
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 535 : 430,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? InkWell(
            onTap: (){

              var contra = _contrasena.text.toLowerCase();
              var contrav = _contrasenav.text.toLowerCase();

              if (_formKey.currentState!.validate()) {

                contra == contrav?
                checkServiceStatusEfectivo(context)
                    :
                _msjNoEsIgual(context);

              }
              //AQUI VA TODOO EL REGISTRO
              //Navigator.of(context).pop(); //Te regresa a la pantalla anterior

            },
                child: Container(
            decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: const [Colors.black, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1))
                  ]),
            child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
            ),
          ),
              )
              : Center(),
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        //controller: _emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email,
              color: Colors.black
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFA7BCC7)),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFA7BCC7)),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          hintText: 'Correo',
          hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

        ),
      ),
    );
  }
}

class Palette {
  static const Color iconColor = Color(0xFFB6C7D1);
  static const Color activeColor = Color(0xFF09126C);
  static const Color textColor1 = Color(0XFFA7BCC7);
  static const Color textColor2 = Color(0XFF9BB3C0);
  static const Color facebookColor = Color(0xFF3B5999);
  static const Color googleColor = Color(0xFFDE4B39);
  static const Color backgroundColor = Color(0xFFECF3F9);
}