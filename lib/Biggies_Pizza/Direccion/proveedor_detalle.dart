import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/agentes_modelo.dart';

class proveedor_detalle extends StatefulWidget {

  final agentes_modelo product;
  const proveedor_detalle(this.product);

  @override
  proveedor_detalleState createState() => proveedor_detalleState();
}

class proveedor_detalleState extends State<proveedor_detalle> {
  @override

  final TextEditingController _nombre = TextEditingController();
  var category2;
  CollectionReference proveedores = FirebaseFirestore.instance.collection('Proveedores_Interno');

  Widget _buildAboutDialog(BuildContext context) {
    return ListView(
      children: <Widget>[
        AlertDialog(
          title: const Text('Alta de Proveedor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(50)
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red,
                          blurRadius: 5
                      )
                    ]
                ),
                child: TextField(
                  controller: _nombre,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.person,
                      color: Colors.red[800],
                    ),
                    hintText: 'Nombre de Proveedor',
                  ),
                ),
              ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        (context as Element).markNeedsBuild();
                      },
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection("Categorias").snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Text("Please wait");
                            var length = snapshot.data!.docs.length;
                            DocumentSnapshot ds = snapshot.data!.docs[length - 1];
                            return DropdownButton(
                              items: snapshot.data!.docs.map((
                                  DocumentSnapshot document) {
                                return DropdownMenuItem(
                                  value: document["categoria"],
                                  child: Text(document["categoria"], style: TextStyle(fontSize: 17.0),),);
                              }).toList(),
                              value: category2,
                              onChanged: (value) {
                                //print(value);
                                setState(() {
                                  category2 = value;
                                });

                              },
                              hint: Text("Elige una categoria", style: TextStyle(fontSize: 18.0),),
                              style: TextStyle(color: Colors.black),
                            );
                          }
                      ),
                    ),

                    //Text('Medidas: 5A'),
                  ],
                ),
              ),

              SizedBox(height: 20,),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  OutlineButton(
                    onPressed: () async {

                      QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Proveedores').orderBy('folio').get();
                      List<DocumentSnapshot> _myDocCount = _myDoc.docs;

                      final collRef = FirebaseFirestore.instance.collection('Proveedores');
                      DocumentReference docReference = collRef.doc();

                      var now = DateTime.now();

                      docReference.set({
                        'folio': _myDocCount.length+1,
                        'newid': docReference.id,
                        'id': "987",
                        'nombreProducto': _nombre.text,
                        'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
                        //'total': 0.00,
                      });

                      _nombre.clear();

                      Navigator.pop(context);

                    },
                    child: SizedBox(
                      width: 300,
                      child: Text('Registrar proveedor', textAlign: TextAlign.center,),
                    ),
                    borderSide: BorderSide(color: Colors.red),
                    shape: StadiumBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {

                Navigator.of(context).pop();

              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Salir'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        child: Icon(Icons.monetization_on),
        onPressed: (){

          //showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context));

          //_sheetCarrito(context);
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        centerTitle: true,
        title: Text(widget.product.nombreAgente),
      ),
      body: StreamBuilder(
        //Asi encontraremos los negocios por ciudad y sin problemas con la BD
          stream: proveedores.where('id', isEqualTo: "987").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (!snapshot.hasData) {
              return Text("Loading..");
            }

            //reference.where("title", isEqualTo: 'UID').snapshots(),
            else
            {

              return FirestoreListViewProduccion(documents: snapshot.data!.docs);
            }
          }
      ),
    );
  }
}


class FirestoreListViewProduccion extends StatefulWidget {

  final List<DocumentSnapshot> documents;
  const FirestoreListViewProduccion({required this.documents});


  @override
  _FirestoreListViewProduccionState createState() => _FirestoreListViewProduccionState();
}

class _FirestoreListViewProduccionState extends State<FirestoreListViewProduccion> {

  String carrito = "sinelementos";
  final TextEditingController _cantidadDeProducto = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.documents.length,
      itemExtent: 70.0, //Crea el espacio entre cada renglon
      itemBuilder: (BuildContext context, int index) {

        String cantidad = widget.documents[index]['cantidad'].toString();
        String foto = widget.documents[index]['foto'].toString();
        String fecha = widget.documents[index]['miembrodesde'].toString();
        String nombre = widget.documents[index]['nombreProducto'].toString();
        String sucursal = widget.documents[index]['ciudad'].toString();
        //String precio = documents[index].data['precioVenta'].toString();
        int folio = widget.documents[index]['folio'];
        String newid = widget.documents[index]['newid'].toString();
        int existencia = widget.documents[index]['existencia'];
        double costoproducto = widget.documents[index]['costoProducto'];
        double precio = widget.documents[index]['precioVenta'];
        int _like = widget.documents[index]['like'];
        String descripcion = widget.documents[index]['descripcion'].toString();
        String chat = widget.documents[index]['chat'].toString();
        String correocliente = widget.documents[index]['correocliente'].toString();
        String nombrecliente = widget.documents[index]['nombrecliente'].toString();
        String msg = widget.documents[index]['msg-dato_cliente'].toString();

        return ListTile(
            title: Card(
              elevation: 7.0,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(folio.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onLongPress: (){

            },
            onTap: () async{

              //_sheetCarrito(context, foto, nombreProducto);
              //await Navigator.push(context, MaterialPageRoute(builder: (context) => Chat_Detalles(Agentes_Modelo(null, nombrecliente, newid, sucursal, correocliente, foto))),);

            }
        );
      },
    );
  }
}