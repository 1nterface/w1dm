import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class alta_tarjeta extends StatefulWidget {
  alta_tarjeta({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  alta_tarjetaState createState() => alta_tarjetaState();
}

class alta_tarjetaState extends State<alta_tarjeta> {
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  var alertStyle = AlertStyle(
    overlayColor: Colors.blue[400],
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Color.fromRGBO(91, 55, 185, 1.0),
    ),
  );

  Widget tarjetaRegistrada(BuildContext context){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final correoPanel = user!.email;

    return StreamBuilder<DocumentSnapshot<Object?>>(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Panel_Registro').doc(correoPanel).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data!.data() as Map<String, dynamic>;

            String cta = userDocument["cta"];
            String estado = userDocument["estado"];

            return
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: <Widget>[
                    Text("Cuenta registrada"),
                    Text("$cta", style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("Estado de cuenta"),
                    estado == "Activada"?
                    Text("$estado", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800]),)
                    :
                    Text("$estado", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[900])),
                  ],
                ),
              ],
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: Text("Alta de Tarjeta"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap:(){

                print("Mostrar cuenta guardada");
              },
              child: CreditCard(
                cardNumber: cardNumber,
                cardExpiry: expiryDate,
                cardHolderName: cardHolderName,
                cvv: cvv,
                bankName: 'Tarjeta de debito/credito',
                showBackSide: showBack,
                frontBackground: CardBackgrounds.black,
                backBackground: CardBackgrounds.white,
                showShadow: true,
                // mask: getCardTypeMask(cardType: CardType.americanExpress),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            tarjetaRegistrada(context),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Numero de Tarjeta'),
                    maxLength: 16,
                    onChanged: (value) {
                      setState(() {
                        cardNumber = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Expiracion de Tarjeta'),
                    maxLength: 4,
                    onChanged: (value) {
                      setState(() {
                        expiryDate = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Nombre del Titular'),
                    onChanged: (value) {
                      setState(() {
                        cardHolderName = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'CVV'),
                    maxLength: 3,
                    onChanged: (value) {
                      setState(() {
                        cvv = value;
                      });
                    },
                    focusNode: _focusNode,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Container(
                        child: SizedBox(
                          child: RaisedButton(
                            color: Colors.red[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            child: Text('Registrar', style: TextStyle(color: Colors.white),),
                            onPressed: () async {

                              final FirebaseAuth auth = FirebaseAuth.instance;
                              final User? user = auth.currentUser;
                              final correoPersonal = user!.email;

                              FirebaseFirestore.instance.collection('Panel_Registro').doc(correoPersonal.toString()).update({
                                'estado': "Pendiente",
                                'cta': cardNumber.toString(),
                                'titular': cardHolderName.toString(),
                                'expiracion': expiryDate.toString(),
                                'cvv': cvv.toString(),
                              });


                              print(cardNumber);
                              print(cardHolderName);
                              print(expiryDate);
                              print(cvv);

                              Alert(
                                context: context,
                                //style: alertStyle,
                                type: AlertType.success,
                                title: "¡REGISTRO EXITOSO!",
                                desc: "La cuenta será aprobada en un lapso de 24 a 48 hrs hábiles.\nTú información se encuentra encriptada y resguardada por 1nterface de México.",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "SALIR",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    color: Colors.red[800],
                                    radius: BorderRadius.circular(10.0),
                                  ),
                                ],
                              ).show();

                              //Alert(context: context, title: "¡REGISTRO EXITOSO!", desc: "Tu información se encuentra encriptada y resguardada por 1nterface de México")
                                  //.show();

                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}