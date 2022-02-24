//@dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:w1dm/Biggies_Pizza/olvidecontra.dart';
import 'package:w1dm/inicio.dart';

import 'Biggies_Pizza/Clientes/clientes_login.dart';
import 'Biggies_Pizza/Clientes/lista_restaurantes.dart';
import 'Biggies_Pizza/Clientes/menu_cliente.dart';
import 'Biggies_Pizza/Clientes/registro.dart';
import 'Biggies_Pizza/Direccion/alta_costos_caja.dart';
import 'Biggies_Pizza/Direccion/alta_portada.dart';
import 'Biggies_Pizza/Direccion/alta_promociones.dart';
import 'Biggies_Pizza/Direccion/bottom_nav.dart';
import 'Biggies_Pizza/Direccion/catalogo_mujeres.dart';
import 'Biggies_Pizza/Direccion/direccion_registro_nuevo.dart';
import 'Biggies_Pizza/Direccion/gerencia_home.dart';
import 'Biggies_Pizza/Direccion/gerencia_login.dart';
import 'Biggies_Pizza/Direccion/historial.dart';
import 'Biggies_Pizza/Direccion/pedidos.dart';
import 'Biggies_Pizza/Direccion/promociones_direccion.dart';
import 'Biggies_Pizza/Direccion/repartidores_direccion.dart';
import 'Biggies_Pizza/Direccion/reporte_ventas_direccion.dart';
import 'Biggies_Pizza/Modelo/cajas_modelo.dart';
import 'Biggies_Pizza/Modelo/nota_modelo.dart';
import 'Biggies_Pizza/Modelo/panel_pedido_modelo.dart';
import 'Biggies_Pizza/Panel/alta_colonias.dart';
import 'Biggies_Pizza/Panel/alta_socios.dart';
import 'Biggies_Pizza/Panel/home_panel.dart';
import 'Biggies_Pizza/Panel/panel_de_control.dart';
import 'Biggies_Pizza/Panel/panel_de_control_detalle.dart';
import 'Biggies_Pizza/Panel/panel_login.dart';
import 'Biggies_Pizza/Panel/panel_registro.dart';
import 'Biggies_Pizza/Panel/soporte.dart';
import 'Biggies_Pizza/Repartidor/pedidos_detalles_repartidor.dart';
import 'Biggies_Pizza/Repartidor/repartidor_home.dart';
import 'Biggies_Pizza/Repartidor/repartidor_login.dart';
import 'Biggies_Pizza/Repartidor/repartidor_mis_entregas.dart';
import 'Biggies_Pizza/Repartidor/repartidor_pedidos.dart';
import 'Biggies_Pizza/Repartidor/repartidor_registro.dart';
import 'Biggies_Pizza/admin_inicio.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();
  // Initialize a new Firebase App instance
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder> {

        '/home': (BuildContext context) => inicio(),

        '/olvide_contra': (BuildContext context) => olvidecontra(),
        "/gerencia_login": (BuildContext context) => gerencia_login(),
        "/gerencia_home": (BuildContext context) => gerencia_home(),
        "/alta_costos_caja": (BuildContext context) => alta_costos_caja(cajas_modelo("","","",0,0, 0, 0, 0, "", "", "", "", "", 0)),
        '/pedidos': (BuildContext context) => pedidos(),
        '/catalogo_mujeres': (BuildContext context) => catalogo_mujeres(0, cajas_modelo("","","",0,0, 0, 0, 0, "", "", "", "", "", 0)),
        //'/catalogo_clientes': (BuildContext context) => Catalogo_Clientes(),
        '/alta_promociones': (BuildContext context) => alta_promociones(),
        //'/alta_tarjeta': (BuildContext context) => alta_tarjeta(),
        '/promociones_direccion': (BuildContext context) => promociones_direccion(cajas_modelo("","","",0,0, 0, 0, 0, "", "", "", "", "", 0)),
        '/reporte_ventas_direccion': (BuildContext context) => reporte_ventas_direccion(),
        '/repartidores_direccion': (BuildContext context) => repartidores_direccion(),
        '/olvide_contra': (BuildContext context) => olvidecontra(),
        '/historial': (BuildContext context) => historial(),
        '/bottom_nav': (BuildContext context) => bottom_nav(),

        '/repartidor_login': (BuildContext context) => repartidor_login(),
        '/repartidor_home': (BuildContext context) => repartidor_home("", ""),
        '/pedidos_detalles_repartidor': (BuildContext context) => pedidos_detalles_repartidor(nota_modelo("","",0,0,"","",0,"",0,0,"","","")),
        '/repartidor_mis_entregas': (BuildContext context) => repartidor_mis_entregas(),
        '/repartidor_pedidos': (BuildContext context) => repartidor_pedidos("", ""),
        '/repartidor_registro': (BuildContext context) => repartidor_registro(),


        '/clientes_login': (BuildContext context) => clientes_login(),
        '/menu_cliente': (BuildContext context) => menu_cliente("","","","","","",0,0),
        '/direccion_registro_nuevo': (BuildContext context) => direccion_registro_nuevo(),
        '/registro': (BuildContext context) => registro(),
        '/home': (BuildContext context) => inicio(),
        '/admin_inicio': (BuildContext context) => Admin_Inicio(),
        '/alta_promociones': (BuildContext context) => alta_promociones(),
        '/panel_de_control': (BuildContext context) => panel_de_control(),
        '/alta_colonias': (BuildContext context) => alta_colonias(),
        '/panel_login': (BuildContext context) => panel_login(),
        '/panel_de_control_detalle': (BuildContext context) => panel_de_control_detalle(panel_pedido_modelo("","","",0,0, 0, 0, 0, "", "", "", "", "", 0,"","",0,"","","")),
        '/lista_restaurantes': (BuildContext context) => lista_restaurantes(),
        '/alta_portada': (BuildContext context) => alta_portada(),
        '/home_panel': (BuildContext context) => home_panel(),
        '/soporte': (BuildContext context) => soporte(),
        '/alta_socios': (BuildContext context) => alta_socios(),
        '/panel_registro': (BuildContext context) => panel_registro(),

      },
      title: '1nterface De Mexico',
      theme: ThemeData(

      ),
      home:
      //Inicio(),
      inicio(),
      // <--- App Clientes


    );
  }
}
