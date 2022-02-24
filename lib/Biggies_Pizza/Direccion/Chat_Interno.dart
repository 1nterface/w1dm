import 'package:flutter/material.dart';

class Chat_Interno extends StatefulWidget {
  @override
  Chat_InternoState createState() => Chat_InternoState();
}

class Chat_InternoState extends State<Chat_Interno> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset('images/perfil.png'),
                    ),
                    Text('Independencia'),
                    SizedBox(width: 10,),
                  ],
                ),
                SizedBox(width: 10,),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset('images/perfil4.png'),
                    ),
                    Text('Independencia'),
                    SizedBox(width: 10,),
                  ],
                ),
                SizedBox(width: 10,),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset('images/perfil5.png'),
                    ),
                    Text('Jardines'),
                    SizedBox(width: 10,),
                  ],
                ),
                SizedBox(width: 10,),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset('images/perfil6.png'),
                    ),
                    Text('Nvo Mxli'),
                    SizedBox(width: 10,),
                  ],
                ),
                SizedBox(width: 10,),
              ],
            ),
          ),
          Container(
            color: Colors.black12,
            child: Column(
              children: const <Widget>[
                Divider(color: Colors.white10, height: 10.0,),
                //Divider(color: Colors.black26,),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Column(
            children: <Widget>[

              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.asset('images/perfil3.png'),
                  ),
                  Card(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: const <Widget>[
                            Text('Museo del Valle', style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(width: 40,),
                            Text('Fecha: 09/03/2020'),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Text('Gracias por el aviso Melissa, mañana ire al local.')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
