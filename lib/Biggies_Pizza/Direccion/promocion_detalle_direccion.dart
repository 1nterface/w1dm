import 'package:flutter/material.dart';
import 'package:w1dm/Biggies_Pizza/Modelo/cajas_modelo.dart';

class promocion_detalle_direccion extends StatefulWidget {

  cajas_modelo product;
  promocion_detalle_direccion(this.product);

  @override
  _promocion_detalle_direccionState createState() => _promocion_detalle_direccionState();
}

class _promocion_detalle_direccionState extends State<promocion_detalle_direccion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow[700],
        title: Text('Alta Ofertas'),
      ),
      body: Center(
        child: Image.network(widget.product.foto)
      ),
    );
  }
}
