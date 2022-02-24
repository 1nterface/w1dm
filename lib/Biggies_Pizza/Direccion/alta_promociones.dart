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

class alta_promociones extends StatefulWidget {

  @override
  alta_promocionesState createState() => alta_promocionesState();
}

class alta_promocionesState extends State<alta_promociones> {

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
      print("DIRECCION IMAGEN"+_imageFile.toString());

    });
  }
  Future fotoCamara() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera
    );

    setState(() {
      _imageFile = File(pickedFile!.path);
      print(_imageFile.toString());
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

          QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Promociones').orderBy(
              'folio').get();
          List<DocumentSnapshot> _myDocCount = _myDoc.docs;

          final collRef = FirebaseFirestore.instance.collection('Promociones');
          DocumentReference docReference = collRef.doc();

          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final correoPersonal = user!.email;

          var now = DateTime.now();



          final prefst = await SharedPreferences.getInstance();
          String empresa = prefst.getString('empresa') ?? "";
          String ciudad = prefst.getString('ciudad') ?? "";

          Object lat = prefst.getDouble('lat') ?? "";
          Object lon = prefst.getDouble('lon') ?? "";

          print(empresa);
          print("lati "+lat.toString());
          print("longi "+lon.toString());

          docReference.set({
            //'subcategoria': widget.subcategoria,
            'correoNegocio': correoPersonal,
            'categoria': "Oferta",
            //'categoriap': category2,
            'folio': _myDocCount.length + 1,
            //'costoProducto': costo,
            'newid': docReference.id,
            'id': "promo",
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: const Text('Alta Ofertas', style: TextStyle(color: Colors.white)),
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
                                lat = doc['latitud'];
                                lon = doc['longitud'];

                                print(empresa);
                                print(lat);
                                print(lon);

                                //SharedPreferences paso #1
                                final prefst = await SharedPreferences.getInstance();
                                prefst.setString('empresa', empresa);
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
                  ],
                ),

                _imageFile == null?
                Container()
                    :
                Image.file(_imageFile!,
                  fit: BoxFit.cover,
                ),
                _imageFile == null?
                Container()
                    :
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