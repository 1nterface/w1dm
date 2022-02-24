import 'dart:math';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

    class alimentos_sheet extends StatefulWidget {

  int folio;

  alimentos_sheet(this.folio);

  @override
      _alimentos_sheetState createState() => _alimentos_sheetState();
    }

    class _alimentos_sheetState extends State<alimentos_sheet> {

      final _formKey = GlobalKey<FormState>();
      var category;
      String carrito = "sinelementos";
      final TextEditingController _cantidadDeProducto = TextEditingController();

      List<String> text = ["A domicilio"];
      bool _isChecked = false, _isChecked2 = false;
      late String _dropDownValue;

      int existencia = 0;

      var medida;
      int _itemCount = 1;

      void _agregarACarrito(categoria, correoNegocio, subcategoria, empresa, codigo, descripcion, foto, nombreProducto, costo, medida) async {

        QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('Pedidos_Jimena').orderBy('folio').get();
        List<DocumentSnapshot> _myDocCount = _myDoc.docs;

        final collRef = FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna');
        DocumentReference docReference = collRef.doc();

        var now = DateTime.now();

        //double precio = double.parse(_precio.text);
        //AQUI VA LA VARIABLE QUE ESTA ENTRE LOS BOTONES - Y +

        num resultado = _itemCount * costo;

        final FirebaseAuth auth = FirebaseAuth.instance;
        final User? user = auth.currentUser;
        final correoPersonal = user!.email;

        print("total: " + resultado.toString());

        //AQUI DESCONTAR DE MEDIDAS LA EXISTENCIA DEL PRODUCTO
        final prefs = await SharedPreferences.getInstance();
        String newidpropio = prefs.getString('newidpropio') ?? "";
        String newidproductoo = prefs.getString('newidproductoo') ?? "";
        String medidapr = prefs.getString('medida') ?? "";
        //int existencia = prefs.getInt('existencias') ?? "";

        print("newidpropio: "+newidpropio);
        //print("Existencia: "+existencia.toString());

        //int resultadoo = existencia - _itemCount;

        //_itemCount > existencia?
        //print('Cifra mayor')
        //:
        //_agregarExtra(context, costo, descripcion,  nombreProducto, foto, subcategoria, codigo);

        //print("Existencia correcto: "+resultadoo.toString());

        //SI LA CANTIDAD ES MAYOR A LA EXISTENCIA, MSJ - la cifra es mayor a la existencia
        docReference.set({
          'newidpropio': newidpropio,
          'categoria': categoria,
          'correoNegocio': correoNegocio,
          'subcategoria': subcategoria,
          'empresa': empresa,
          'newidproducto': newidproductoo,
          'medida': medidapr,
          'codigo': codigo,
          'correocliente': correoPersonal,
          'descripcion': descripcion,
          'totalProducto': resultado,
          'cantidad': _itemCount,
          //AQUI TRAER EL FOLIO DE LA NOTA
          'folio': widget.folio,
          'newid': docReference.id,
          //'precioVenta': precio,
          'foto': foto,
          'id': "987",
          'nombreProducto': nombreProducto,
          'miembrodesde': DateFormat("dd-MM-yyyy").format(now),
          'total': resultado,
          'precio': costo,
          'costoProducto': costo,
          'costo': costo,
        });

        Navigator.of(context).pop();
        Navigator.of(context).pop();

        //countDocuments();
        //Navigator.of(context).pop();
        _cantidadDeProducto.clear();

        QuerySnapshot _myDocE = await FirebaseFirestore.instance.collection('Pedidos_Jimena_Interna').where('correocliente', isEqualTo: correoPersonal).where('folio', isEqualTo: widget.folio).get();
        List<DocumentSnapshot> _myDocCountE = _myDocE.docs;
        //print('Weed: '+ _myDocCountE.length.toString() +1.toString());
        print('hey');
        var total = _myDocCountE.length;
        //Firestore.instance.collection('Notificaciones').document("Pedidos_Jimena"+correoPersonal).updateData({'notificacion': total.toString()});

        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('totalProducto');

        ///////////////////////

        //ESTE BLOQUE BORRA EL PRODUCTO CUANDO LA CONSULTA DE EXISTENCIA ARROJA QUE ES IGUAL A CERO.
        //ESTE BLOQUE BORRA EL PRODUCTO CUANDO LA CONSULTA DE EXISTENCIA ARROJA QUE ES IGUAL A CERO.
        //_itemCount > existencia?
        //print('jggf')
        //  :
        //Toast.show("¡Agregado exitosamente!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);



      }

      Widget _buildAboutDialog(BuildContext context, String foto, String nombreProducto, double costo, String descripcion, String empresa, String subcategoria, String newid, String codigo, String categoria, String correoNegocio) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) =>  ListView(
            children: <Widget>[
              AlertDialog(
                title: Row(children:[Text(empresa, style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))]),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.end,

                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {

                            //await Navigator.push(context, MaterialPageRoute(builder: (context) => Producto_Detalle2(Cajas_Modelo(null, nombreProducto,"fecha",0,2,3,4,5,descripcion, empresa,foto,"f", newid, costo))),);

                            print("Precio: "+costo.toString());
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: 230.0,
                              height: 230.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(foto)
                                ),
                                //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:10),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 200.0,
                              child: Text(
                                nombreProducto,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('\$$costo', style: TextStyle(fontSize: 25, color: Colors.red[300], fontStyle: FontStyle.italic),),
                          ],
                        ),
                        SizedBox(height:5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //spinnerMedida(newid),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:[
                                  InkWell(
                                    onTap:(){

                                      setState(()=>_itemCount--);

                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text('-', style: TextStyle(fontSize: 25, color: Colors.white))
                                          //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red[800]),
                                    ),
                                  ),
                                  SizedBox(width:10),
                                  Text(_itemCount.toString(), style: TextStyle(fontSize: 25, color: Colors.black),),
                                  SizedBox(width:10),
                                  InkWell(
                                    onTap:(){

                                      setState(()=>_itemCount++);

                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text('+', style: TextStyle(fontSize: 25, color: Colors.white))
                                          //Text("ID"+folio.toString(), style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red[800]),
                                    ),
                                  ),                            ]
                            )
                          ],
                        ),
                      ],
                    ),

                    //MEDIDAS
                    //AQUI HACER LA CONDICION DE SUBCATEGORIA PARA MOSTRAR MEDIDAS O NUMEROS O NADA
                    //AL MOMENTO DE COBRAR
                    //medidaNumero(context, newid),
                    SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(descripcion),
                      ],
                    ),
                    SizedBox(height: 20.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              child: SizedBox(
                                child: RaisedButton(
                                  color: Colors.red[800],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                  child: Text('Agregar a carrito', style: TextStyle(color: Colors.white),),
                                  onPressed: () async {


                                    _agregarACarrito(categoria, correoNegocio, subcategoria, empresa, codigo, descripcion, foto, nombreProducto, costo, medida);

                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {


                      setState(() {

                        medida = null;

                      });

                      Navigator.of(context).pop();
                    },
                    textColor: Colors.black,
                    child: const Text('Salir'),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      CollectionReference reflistacajas = FirebaseFirestore.instance.collection('Cajas');

      @override
      Widget build(BuildContext context) {

        final FirebaseAuth auth = FirebaseAuth.instance;
        final User? user = auth.currentUser;
        final correoPersonal = user!.email;

        return StreamBuilder(
          //CLONAR ARCHIVO Y HACER AQUI LA MAGIA DE LA CONSULTA
          //Y ASI  CON TODOS
            stream: reflistacajas.where('correoNegocio', isEqualTo: correoPersonal).where('categoria', isEqualTo: "Alimentos").orderBy('nombreProducto', descending: false).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData) {
                return Text("Loading..");
              }
              //reference.where("title", isEqualTo: 'UID').snapshots(),

              else
              {
                //ESTE SI FUNCIONA, VOLVER A HACER TODO COM ESTE WIDGET
                return ListView(
                  children: snapshot.data!.docs.map((documents) {

                    double tot = documents["costo"];
                    //LAS VARIABLES QUE DELCARO AQUI HACEN EL BAD STATE!!!!!!!

                    return InkWell(

                      onTap: () async{


                        showDialog(context: context, builder: (BuildContext context) => _buildAboutDialog(context, documents["foto"], documents["nombreProducto"], documents["costo"], documents["descripcion"], documents["empresa"], "subcategoria", documents["newid"], "codigo", documents["categoria"], documents["correoNegocio"]),);

                      },
                      child: Card(
                        elevation: 1.0,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  InkWell(
                                    onTap: () async {

                                      //await Navigator.push(context, MaterialPageRoute(builder: (context) => Producto_Detalle2(Cajas_Modelo(null, nombreProducto,"",0,2,2,3,4,descripcion,empresa,foto,"f", "newid", 0))),);

                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(documents["foto"])
                                          ),
                                          //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(left:20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Text(documents["nombreProducto"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black45),),
                                              //height: 30,
                                              width: 150,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Text(documents["descripcion"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black26),),
                                              //height: 30,
                                              width: 150,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 15, bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text("\$"+documents["costo"].toString(), style: TextStyle(color: Colors.black, fontSize: 18),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            }
        );
      }
    }