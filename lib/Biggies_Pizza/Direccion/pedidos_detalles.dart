import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/nota_modelo.dart';
import 'package:flutter/material.dart';

class pago_detalles extends StatefulWidget {

  final nota_modelo product;
  const pago_detalles(this.product);

  @override
  pago_detallesState createState() => pago_detallesState();
}

class pago_detallesState extends State<pago_detalles> {

  CollectionReference reflistadeventas = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');

  Widget estadoPizza (BuildContext context){
    return StreamBuilder(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Ventas').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            return userDocument['estadoh'] != "horneando"?
            Column(
              children: <Widget>[
                Icon(Icons.check, color: Colors.red[900], size: 35,),
                Text('Levantando pedido')
              ],
            )
                :
            Column(
              children: <Widget>[
                Icon(Icons.check, color: Colors.green[700], size: 35,),
                Text('Levantando pedido')
              ],
            );
          }
        }
    );
  }

  Widget estadoHorno (BuildContext context){
    return StreamBuilder(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Ventas').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            return userDocument['estadoh'] == "horneando"?
            Column(
              children: <Widget>[
                Icon(Icons.kitchen, color: Colors.green[700], size: 35,),
                Text('Preparando')
              ],
            )
                :
            Column(
              children: <Widget>[
                Icon(Icons.kitchen, size: 35, color: Colors.red[900]),
                Text('Preparando')
              ],
            );

          }
        }
    );
  }

  Widget estadoEnCamino (BuildContext context){
    return StreamBuilder(
      //En esta linea ingresar el nombre de la coecci
        stream: FirebaseFirestore.instance.collection('Ventas').doc(widget.product.newid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          //reference.where("title", isEqualTo: 'UID').snapshots(),

          else
          {
            Map<String, dynamic> userDocument = snapshot.data! as Map<String, dynamic>;

            return userDocument['estado3'] == "encamino"?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.motorcycle, color: Colors.green[700], size: 35,),
                Text('En camino '),
                Text(userDocument['repartidor'], style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            )
                :
            userDocument['estado3'] == "entregahecha"?
            Column(
              children: <Widget>[
                Icon(Icons.thumb_up, size: 35, color: Colors.green[700]),
                Text('Entrega realizada'),
                userDocument['repartidor'] == null?
                Icon(Icons.motorcycle, color: Colors.red[900], size: 35,)
                    :
                Text(userDocument['repartidor'], style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            )
                :
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Icon(Icons.motorcycle, color: Colors.green[700], size: 35,),
                userDocument['repartidor'] == null?
                Column(
                  children: <Widget>[
                    Icon(Icons.motorcycle, color: Colors.red[900], size: 35,),
                    Text('En camino '),
                  ],
                )
                    :
                Text(userDocument['repartidor'], style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            );
            Column(
              children: <Widget>[
                Icon(Icons.motorcycle, size: 35, color: Colors.red[900]),
                Text('En camino')
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
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        title: Text('Reporte de Ventas'),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Ticket de compra #"+widget.product.folio.toString()),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:50),
            child: Column(
              children: <Widget>[
                Container(
                  //color: Colors.black12,
                  child: Column(
                    children: const <Widget>[
                      Divider(color: Colors.black45),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: StreamBuilder(
                    //Asi encontraremos los negocios por ciudad y sin problemas con la BD
                      stream: reflistadeventas.where("folio", isEqualTo: widget.product.folio).orderBy('miembrodesde', descending: true).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if (!snapshot.hasData) {
                          return Text("Loading..");
                        }
                        //reference.where("title", isEqualTo: 'UID').snapshots(),

                        else
                        {
                          return FirestoreListViewCarrito2(documentsconfircarrito: snapshot.data!.docs);
                        }
                      }
                  ),
                ) ,
                Text('TOTAL', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                Text('\$'+widget.product.totalNota.toString(), style: TextStyle(fontSize: 35),),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class FirestoreListViewCarrito2 extends StatelessWidget {

  final List<DocumentSnapshot> documentsconfircarrito;
  const FirestoreListViewCarrito2({required this.documentsconfircarrito});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documentsconfircarrito.length,
      itemExtent: 80.0, //Altura de cada renglon de la lista
      itemBuilder: (BuildContext context, int index) {
        String nombreProducto = documentsconfircarrito[index]['nombreProducto'].toString();
        String foto = documentsconfircarrito[index]['foto'].toString();
        String fecha = documentsconfircarrito[index]['fecha'].toString();
        String newid = documentsconfircarrito[index]['newid'].toString();
        int folio = documentsconfircarrito[index]['folio'];
        double precio = documentsconfircarrito[index]['precio'];
        int cantidad = documentsconfircarrito[index]['cantidad'];
        String tipo = documentsconfircarrito[index]['tipo'].toString();

        return ListTile(
          title: Stack(
            children: <Widget>[
              Card(
                child: InkWell(
                  onLongPress: (){

                    //_borrarElemento(context, newid);

                  },

                  onTap:() async {

                    //FALTA MOSTRAR EN LA PESTAÑA "MIS COMPRAS"
                    //await Navigator.push(context, MaterialPageRoute(builder: (context) => Historial_Clientes_Detalles(Nota_Modelo(null, "",folio,cantidad, newid))),);

                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(cantidad.toString()),
                          SizedBox(
                            width: 150,
                            child: Text(nombreProducto, style: TextStyle(fontSize: 15.0),),
                          ),
                          Text("\$"+precio.toString()),
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
