import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class alta_cipriana extends StatefulWidget {

  cajas_modelo product;
  alta_cipriana(this.product);

  @override
  alta_ciprianaState createState() => alta_ciprianaState();
}

class alta_ciprianaState extends State<alta_cipriana> {

  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _precio = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: "gs://la-festa-pizzas.appspot.com");
  final formKey = GlobalKey<FormState>();
  late String imgUrl;
  late File _imageFile;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future fotoGaleria() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery
    );

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }
  Future fotoCamara() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera
    );

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = path.basename(_imageFile.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => Navigator.pop(context));
    taskSnapshot.ref.getDownloadURL().then(
            (value) async {

          QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Cajas').orderBy(
              'folio').get();
          List<DocumentSnapshot> _myDocCount = _myDoc.docs;

          final collRef = FirebaseFirestore.instance.collection('Cajas');
          DocumentReference docReference = collRef.doc();

          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final correoPersonal = user!.email;

          var now = DateTime.now();

          double costo = double.parse(_precio.text);

          String nombre = _nombre.text;

          final prefst = await SharedPreferences.getInstance();
          String empresa = prefst.getString('empresa') ?? "";
          String ciudad = prefst.getString('ciudad') ?? "";

          Object lat = prefst.getDouble('lat') ?? "";
          Object lon = prefst.getDouble('lon') ?? "";

          print(empresa);
          print("lati "+lat.toString());
          print("longi "+lon.toString());

          docReference.set({
            'lat': lat,
            'lon': lon,
            'ciudad': ciudad,
            'empresa': empresa,
            //'subcategoria': widget.subcategoria,
            'correoNegocio': correoPersonal,
            'categoria': "Cipriana",
            //'categoriap': category2,
            'like': 0,
            'folio': _myDocCount.length + 1,
            'costoProducto': costo,
            'newid': docReference.id,
            'descripcion': _descripcion.text,
            'costo': costo,
            'id': "978",
            'nombreProducto': nombre,
            'foto': value,
            'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
          });

          //AQUI VA CODIGO PARA GUARDAR DATOS Y URL A CLOUD FIRESTORE

          print("Done: $value");
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange[100],
        title: const Text('Alta Cipriana', style: TextStyle(color: Colors.brown)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.orange[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Galeria', style: TextStyle(color: Colors.brown),),
                      onPressed: () async {

                        double lat = 0, lon = 0;

                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final User? user = auth.currentUser;
                        final correoPersonal = user!.email;

                        FirebaseFirestore.instance.collection('Socios_Registro').where("correo", isEqualTo: correoPersonal).get().then((snapshot) async {
                          for (DocumentSnapshot doc in snapshot.docs) {

                            var empresa = doc['empresa'];
                            var ciudad = doc['ciudad'];
                            lat = doc['latitud'];
                            lon = doc['longitud'];

                            print(empresa);
                            print(lat);
                            print(lon);

                            //SharedPreferences paso #1
                            final prefst = await SharedPreferences.getInstance();
                            prefst.setString('empresa', empresa);
                            prefst.setString('ciudad', ciudad);
                            prefst.setDouble('lat', lat);
                            prefst.setDouble('lon', lon);




                          } //METODO THANOS FOR EACH

                        });
                        fotoGaleria();
                      },
                    ),
                  ),
                ),

                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.orange[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Camara', style: TextStyle(color: Colors.brown),),
                      onPressed: () async {

                        double lat = 0, lon = 0;

                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final User? user = auth.currentUser;
                        final correoPersonal = user!.email;

                        FirebaseFirestore.instance.collection('Socios_Registro').where("correo", isEqualTo: correoPersonal).get().then((snapshot) async {
                          for (DocumentSnapshot doc in snapshot.docs) {

                            var empresa = doc['empresa'];
                            var ciudad = doc['ciudad'];
                            lat = doc['latitud'];
                            lon = doc['longitud'];

                            print(empresa);
                            print(lat);
                            print(lon);

                            //SharedPreferences paso #1
                            final prefst = await SharedPreferences.getInstance();
                            prefst.setString('empresa', empresa);
                            prefst.setString('ciudad', ciudad);
                            prefst.setDouble('lat', lat);
                            prefst.setDouble('lon', lon);




                          } //METODO THANOS FOR EACH

                        });

                        fotoCamara();

                      },
                    ),
                  ),
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //SizedBox(height: 20.0,),
                      const SizedBox(height: 30.0,),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 35.0, left: 35.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(50)
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.brown,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Escribe el correo';
                              }
                              return null;
                            },
                            controller: _nombre,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.arrow_forward_outlined,
                                color: Colors.brown,
                              ),
                              hintText: 'Nombre',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0,),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 35.0, left: 35.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(50)
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.brown,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Escribe el correo';
                              }
                              return null;
                            },
                            controller: _descripcion,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.announcement,
                                color: Colors.brown,
                              ),
                              hintText: 'Descripcion',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0,),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50)
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.brown,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: TextFormField(
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Ingresa el precio';
                              }
                              return null;
                            },
                            controller: _precio,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.monetization_on_outlined,
                                color: Colors.brown,
                              ),
                              hintText: 'Precio',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0,),
                    ],
                  ),
                ),
                Container(
                  child: SizedBox(
                    child: RaisedButton(
                      color: Colors.orange[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Subir imagen', style: TextStyle(color: Colors.brown),),
                      onPressed: () async {

                        setState(() {
                          uploadImageToFirebase(context);
                        });



                      },
                    ),
                  ),
                ),

              ],
            ),
            //Expanded(
            // child: Text('holas'),
            //),
          ],
        ),
      ),
    );
  }
}