import 'package:flutter/material.dart';

class Category_Item extends StatelessWidget {

  final String title;
  final Color color;

  const Category_Item(this.color, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20),)),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.purple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}
