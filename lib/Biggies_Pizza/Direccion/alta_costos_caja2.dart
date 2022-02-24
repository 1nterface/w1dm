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

class alta_costos_caja2 extends StatefulWidget {

  cajas_modelo product;
  alta_costos_caja2(this.product);

  @override
  alta_costos_caja2State createState() => alta_costos_caja2State();
}

class alta_costos_caja2State extends State<alta_costos_caja2> {

  double _progress = 0.0;

  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _precio = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: "gs://la-festa-pizzas.appspot.com");
  final formKey = GlobalKey<FormState>();
  late String imgUrl;
  File? _imageFile;
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
    String fileName = path.basename(_imageFile!.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => Navigator.pop(context));
    taskSnapshot.ref.getDownloadURL().then(
            (value) async {

              uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                _progress = snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble();
                print(_progress);
                //TENGO EL DATO PARA MOSTRARLO EN EL WIDGET PROGRESIVO
              });

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
            'categoria': "Bebidas",
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

  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: const Text('Alta Bebidas', style: TextStyle(color: Colors.white)),
      ),
      body:
        load == true?
        Center(child: CircularProgressIndicator(color: Colors.red[800]))
        :
      Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                    Container(
                      child: SizedBox(
                        child: RaisedButton(
                          color: Colors.red[800],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          child: Text('Galeria', style: TextStyle(color: Colors.white),),
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
                          color: Colors.red[800],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          child: Text('Camara', style: TextStyle(color: Colors.white),),
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
                  ]
                ),

                _imageFile == null?
                Container()
                    :
                Image.file(_imageFile!,
                  fit: BoxFit.cover,
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
                                    color: Colors.black,
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
                                color: Colors.red[800],
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
                                    color: Colors.black,
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
                                color: Colors.red[800],
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
                                    color: Colors.black,
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
                                color: Colors.red[800],
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
                      color: Colors.red[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Subir imagen', style: TextStyle(color: Colors.white),),
                      onPressed: () async {

                        setState(() {
                          load = true;

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