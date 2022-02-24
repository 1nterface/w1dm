import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:w1dm/Biggies_Pizza/Direccion/carpinteria.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../authentication.dart';


class panel_registro extends StatefulWidget {

  //final LocationPermissionLevel permissionLevel;

  const panel_registro();

  @override
  panel_registroState createState() => panel_registroState();
}

class panel_registroState extends State<panel_registro> {
  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;

  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
  final TextEditingController _correoEmpresa = TextEditingController();
  final TextEditingController _num = TextEditingController();
  final TextEditingController _clave = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _nombreSucursal = TextEditingController();

  late bool _success;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _userEmail;


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
        Navigator.pop(context);
      } else {
        print("");
      }
    });


    var correo = _correo.text.toLowerCase();
    var contra = _contrasena.text.toLowerCase();

    //final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    //print(position.latitude.toDouble());
    //print(position.longitude.toDouble());
    //var lat = position.latitude.toDouble();
    //var lon = position.longitude.toDouble();
    //print("Lat: "+lat.toString());
    //print("Lon"+lon.toString());

    var now = DateTime.now();

    final collRef = FirebaseFirestore.instance.collection('Panel_Registro').doc(_correo.text);

    //ciudad == null?
    //_msjCiudad(context)
      //  :
    collRef.set({
      'cta': "1234123412341234",
      'estado': 'Pendiente',
      'correoNegocio': _correo.text,
      //'sexo': sexo,
      //'codigo': _clave.text,
      //'empresa': _nombreSucursal.text,
      //'correo': correo,
      'telefono': _tel.text,
      'contraseña': contra,
      //'newid': docReference.documentID,
      'id': "123",
      'nombre': _nombre.text,
      'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
    });

    //SE CREA LA COLECCION PARA QUE LAS NOTIFICACIONES EMPIECEN LEYENDO EN CERO
    FirebaseFirestore.instance.collection('Notificaciones').doc("Compras"+_correo.toString()).set({'notificacion': "0"});
    FirebaseFirestore.instance.collection('Notificaciones').doc("Pedidos_Jimena_Interna"+_correo.toString()).set({'notificacion': '0'});
    FirebaseFirestore.instance.collection('Notificaciones').doc("Carrito"+_correo.toString()).set({'notificacion': '0'});
    FirebaseFirestore.instance.collection('Notificaciones').doc("Promos").set({'notificacion': '0'});

    Navigator.of(context).pop();
    //Toast.show("¡Ahora puedes iniciar sesion!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: (AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("La Festa Pizzas"),
      )),
      backgroundColor: Palette.backgroundColor,
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
                color: Colors.black,
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
                          "PANEL DE CONTROL",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[300]),
                        ),
                        if (!isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            height: 2,
                            width: 55,
                            color: Colors.black,
                          )
                      ],
                    ),
                    if (isSignupScreen)
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        height: 2,
                        width: 55,
                        color: Colors.black,
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

  void _ventanaFlotante(BuildContext context){

    Alert(
        context: context,
        title: "ASEGURATE DE UBICARTE EN TU SUCURSAL O ALMACEN Y ENCENDER TU GPS PARA TOMAR LAS COORDENADAS CORRECTAS",
        //content: Icon(Icons.location_on, size: 40, color: Colors.red[900],),
        buttons: [
          DialogButton(
            color: Colors.black,
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
    LocationPermissions().checkServiceStatus().then(( serviceStatus) {

      //OFICIAL
      //
      //AQUI ES DONDE TENGO QUE HACER LA CONDICION PARA QUE PRENDA EL GPS O CONTINUE CON LA ACCION
      print("Status real: "+serviceStatus.toString());
      serviceStatus.toString() == "ServiceStatus.disabled"?
      _ventanaFlotante(context)
          :
      _startUploadTask();


    });
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.location_city, color: Colors.black),
                  SizedBox(width: 15),
                  //Text('Medidas: 5A'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa tu nombre';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,

                controller: _nombre,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person,
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
                  hintText: 'Nombre y apellido',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa tu numero de celular';
                  }
                  return null;
                },
                controller: _tel,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_android,
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
                  hintText: 'Numero de celular',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Ingresa tu correo personal';
                  }
                  return null;
                },
                controller: _correo,
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
                  hintText: 'Correo personal',
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
                  hintText: 'Contraseña',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0XFFA7BCC7)),

                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Row(
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
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: isMale
                                  ? Colors.black
                                  : Colors.transparent,
                              border: Border.all(
                                  width: 1,
                                  color: isMale
                                      ? Colors.transparent
                                      : Palette.textColor1),
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            MaterialCommunityIcons.account_outline,
                            color: isMale ? Colors.white : Palette.iconColor,
                          ),
                        ),
                        Text(
                          "Mujer",
                          style: TextStyle(color: Palette.textColor1),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
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
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              color: isMale
                                  ? Colors.transparent
                                  : Colors.black,
                              border: Border.all(
                                  width: 1,
                                  color: isMale
                                      ? Palette.textColor1
                                      : Colors.transparent),
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            MaterialCommunityIcons.account_outline,
                            color: isMale ? Palette.iconColor : Colors.white,
                          ),
                        ),
                        Text(
                          "Hombre",
                          style: TextStyle(color: Palette.textColor1),
                        )
                      ],
                    ),
                  ),
                ],
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
                        style: TextStyle(color: Colors.red[300]),
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


              if (_formKey.currentState!.validate()) {

                checkServiceStatusEfectivo(context);

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


class OnelookLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AssetImage assetImage = AssetImage('images/pizzeria.png');
    Image image = Image(image: assetImage, width: 200,);
    return Padding(
      padding: EdgeInsets.only(top:5),
      child: Container(child: image,),
    );
  }
}