import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'package:toast/toast.dart';

class producto_detalle2 extends StatefulWidget {


  cajas_modelo product;
  producto_detalle2(this.product);

  @override
  producto_detalle2State createState() => producto_detalle2State();
}

class producto_detalle2State extends State<producto_detalle2> {

  CollectionReference reflistadeventas = FirebaseFirestore.instance.collection('Tipo');
  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController _cantidad6 = TextEditingController();

  Widget _buildAboutDialog3(BuildContext context) {
    return Form(
      key: _formKey3,
      child: ListView(
        children: <Widget>[
          AlertDialog(
            title: Text("Modificar precio"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.black45,
                  child: Column(
                    children: const <Widget>[
                      Divider(color: Colors.white10, height: 10.0,),
                      //Divider(color: Colors.black26,),
                    ],
                  ),
                ),

                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe el nuevo precio';
                      }
                      return null;
                    },
                    controller: _cantidad6,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Ingresar nuevo precio',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            child: RaisedButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Modificar', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                Navigator.pop(context);

                                print(widget.product.newid);
                                double cantidad4 = double.parse(_cantidad6.text);

                                FirebaseFirestore.instance.collection('Cajas').doc(widget.product.newid).update({
                                  'costoProducto': cantidad4,
                                });
                                Navigator.pop(context);

                                Toast.show("¡Existencia modificada!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3, precio,5,"","",foto,descripcion, newid, costoproducto))),);


                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    //Image.network(foto, height: 250,),
                  ],
                ),
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
      ),
    );
  }

  final _formKeyK = GlobalKey<FormState>();

  Widget _buildAboutDialogMedida(BuildContext context) {
    return Form(
      key: _formKeyK,
      child: ListView(
        children: <Widget>[
          AlertDialog(
            title: Text("Agregar medida"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.black45,
                  child: Column(
                    children: const <Widget>[
                      Divider(color: Colors.white10, height: 10.0,),
                      //Divider(color: Colors.black26,),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Ingresa la medida';
                      }
                      return null;
                    },
                    controller: _medida,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Medida',
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe la cantidad';
                      }
                      return null;
                    },
                    controller: _exis,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Existencia',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            child: RaisedButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Agregar medida', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                //FALTA EL NEWID DEL PRODUCTO Y YA
                                int existencia = int.parse(_exis.text);

                                final collRef = FirebaseFirestore.instance.collection('Medidas');
                                DocumentReference docReference = collRef.doc();

                                var now = DateTime.now();

                                docReference.set({
                                  'existencia': existencia,
                                  'numero': _medida.text,
                                  'newid': widget.product.newid,
                                  'newidpropio': docReference.id,
                                });

                                Navigator.pop(context);

                                _exis.clear();
                                Toast.show("¡Listo!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    //Image.network(foto, height: 250,),
                  ],
                ),
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
      ),
    );
  }

  CollectionReference proveedores = FirebaseFirestore.instance.collection('Medidas');
  final TextEditingController _exis = TextEditingController();
  final TextEditingController _medida = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButton: FloatingActionButton(
        //  onPressed: (){

      //showDialog(context: context, builder: (BuildContext context) =>  _buildAboutDialogMedida(context));

          //print(widget.product.newid);

          //   },
    //backgroundColor: Colors.orange[900],
        //  child: Icon(Icons.add),
      //),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width, 50.0)),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[800],
        title: Text(widget.product.nombreProducto, style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () async {

                print(widget.product.newid);
                //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Insumos_Otros(Cajas_Modelo(null, "nombreProducto","fecha",0,2,3, 0,0,"7501060327482","", widget.product.foto,"",widget.product.newid, 0))),);

              },
              child: SizedBox(
                child: Image.network(widget.product.foto),
                height: 300,
                width: 300,
              ),
            ),
            SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(widget.product.estado, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: (){
                          showDialog(context: context, builder: (BuildContext context) =>  _buildAboutDialog3(context));
                        },
                        child: Icon(Icons.edit, color: Colors.red[800])),
                    InkWell(
                      onTap: (){
                        showDialog(context: context, builder: (BuildContext context) =>  _buildAboutDialog3(context));
                      },
                      child:Text("\$"+widget.product.costoProducto.toString(), style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold, fontSize: 30),),
                    ),
                  ],
                ),
                //Text(widget.product.codigoDeBarra, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                Container(
                  color: Colors.black45,
                  child: Column(
                    children: const <Widget>[
                      Divider(color: Colors.white10, height: 2.0,),
                      //Divider(color: Colors.black26,),
                    ],
                  ),
                ),

              ],
            ),
            Expanded(
              child: StreamBuilder(
                //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                  stream: proveedores.where('newid', isEqualTo: widget.product.newid).snapshots(),
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
            ),
          ],
        ),
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
  final _formKeyg = GlobalKey<FormState>();
  final TextEditingController _cantidad3 = TextEditingController();

  Widget _buildAboutDialog3(BuildContext context, String nombre, double precio, int folio, String newid, int cantidad) {
    return Form(
      key: _formKeyg,
      child: ListView(
        children: <Widget>[
          AlertDialog(
            title: Text("Modificar existencia"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.black45,
                  child: Column(
                    children: const <Widget>[
                      Divider(color: Colors.white10, height: 10.0,),
                      //Divider(color: Colors.black26,),
                    ],
                  ),
                ),

                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe la cantidad';
                      }
                      return null;
                    },
                    controller: _cantidad3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Cantidad',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            child: RaisedButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Modificar', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                int existencia = int.parse(_cantidad3.text);

                                FirebaseFirestore.instance.collection('Medidas').doc(newid).update({
                                  'existencia': existencia,
                                });

                                Navigator.pop(context);

                                _cantidad3.clear();
                                Toast.show("¡Existencia modificada!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    //Image.network(foto, height: 250,),
                  ],
                ),
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
      ),
    );
  }

  void _borrarElemento (BuildContext context, String newid) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('¿Deseas borrar esta medida?', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Si"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior

                FirebaseFirestore.instance.collection('Medidas').doc(newid).delete();

              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.documents.length,
      itemExtent: 70.0, //Crea el espacio entre cada renglon
      itemBuilder: (BuildContext context, int index) {

        String cantidad = widget.documents[index]['cantidad'].toString();
        String foto = widget.documents[index]['foto'].toString();
        String fecha = widget.documents[index]['miembrodesde'].toString();
        String numero = widget.documents[index]['numero'].toString();
        String sucursal = widget.documents[index]['ciudad'].toString();
        //String precio = documents[index].data['precioVenta'].toString();
        int folio = widget.documents[index]['folio'];
        String newid = widget.documents[index]['newidpropio'].toString();
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
                  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Medida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            Text("Existencia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                          ],
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(5),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(numero, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                            Text(existencia.toString(), style: TextStyle(color: Colors.red[800], fontSize: 20.0),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onLongPress: (){

              _borrarElemento(context, newid);

            },
            onTap: () async{

              showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog3(context,"",0,0,newid,0));

              //_sheetCarrito(context, foto, nombreProducto);
              //await Navigator.push(context, MaterialPageRoute(builder: (context) => Proveedor_Detalle(Agentes_Modelo(null, nombre, newid, sucursal, correocliente, foto))),);

            }
        );
      },
    );
  }
}

class FirestoreListViewCarrito2 extends StatelessWidget {

  final List<DocumentSnapshot> documentsconfircarrito;
  FirestoreListViewCarrito2({required this.documentsconfircarrito});
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _cantidad3 = TextEditingController();

  Widget _buildAboutDialog3(BuildContext context, String nombre, double precio, int folio, String newid, int cantidad) {
    return Form(
      key: _formKey2,
      child: ListView(
        children: <Widget>[
          AlertDialog(
            title: Text("Modificar existencia"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.black45,
                  child: Column(
                    children: const <Widget>[
                      Divider(color: Colors.white10, height: 10.0,),
                      //Divider(color: Colors.black26,),
                    ],
                  ),
                ),

                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Escribe nueva existencia';
                      }
                      return null;
                    },
                    controller: _cantidad3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.add,
                        color: Colors.black,
                      ),
                      hintText: 'Ingresar nueva existencia',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: SizedBox(
                            child: RaisedButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Modificar', style: TextStyle(color: Colors.white),),
                              onPressed: () async {

                                int cantidad4 = int.parse(_cantidad3.text);

                                FirebaseFirestore.instance.collection('Tipo').doc(newid).update({
                                  'existencia': cantidad4,
                                });

                                Navigator.pop(context);
                                //await Navigator.push(context, MaterialPageRoute(builder: (context) => Carpinteria_Producto_Detalle(Cajas_Modelo(null, nombreProducto,fecha,folio,2,3, precio,5,"","",foto,descripcion, newid, costoproducto))),);


                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    //Image.network(foto, height: 250,),
                  ],
                ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documentsconfircarrito.length,
      itemExtent: 80.0, //Altura de cada renglon de la lista
      itemBuilder: (BuildContext context, int index) {
        String nombreProducto = documentsconfircarrito[index]['nombreProducto'].toString();
        String foto = documentsconfircarrito[index]['foto'].toString();
        String fecha = documentsconfircarrito[index]['fecha'].toString();
        String newid = documentsconfircarrito[index]['newid2'].toString();
        int folio = documentsconfircarrito[index]['folio'];
        int cantidad = documentsconfircarrito[index]['existencia'];
        String tipo = documentsconfircarrito[index]['medida'].toString();
        String medida = documentsconfircarrito[index]['tipo'].toString();

        return ListTile(
          title: Stack(
            children: <Widget>[
              Card(
                child: InkWell(
                  onLongPress: (){

                    //_borrarElemento(context, newid);

                  },

                  onTap:() async {

                    showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog3(context, nombreProducto, 0, folio, newid, cantidad),);
                    //FALTA MOSTRAR EN LA PESTAÑA "MIS COMPRAS"
                    //await Navigator.push(context, MaterialPageRoute(builder: (context) => Historial_Clientes_Detalles(Nota_Modelo(null, "",folio,cantidad, newid))),);

                    print("hi "+ newid);
                    print(tipo+ " "+ cantidad.toString());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(tipo, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                          Text(cantidad.toString()+" pzs.", style: TextStyle(fontWeight: FontWeight.bold),),
                          //Text(telefonoProveedor),
                        ],
                      ),
                    ],
                  ),
                ),
                elevation: 5,
              ),
            ],
          ),
          //onTap: (){

          //Firestore.instance.runTransaction((transaction) async {
          //DocumentSnapshot snapshot = await transaction.get(documentsconfir[index].reference);
          //Firestore.instance.collection('Citas').document(snapshot.documentID).updateData({'estado': 'VentaRealizada'});
          //});

          //Firestore.instance.runTransaction((transaction) async {
          //DocumentSnapshot snapshot = await transaction.get(documentsconfir[index].reference);
          //await transaction.delete(snapshot.reference);
          //});

          //_crearRegistro();
          //}
        );
      },
    );
  }
}
