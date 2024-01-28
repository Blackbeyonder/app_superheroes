import 'package:flutter/material.dart';

class DetailScren extends StatefulWidget {
  const DetailScren({ Key? key }) : super(key: key);

  @override
  _DetailScrenState createState() => _DetailScrenState();
}

class _DetailScrenState extends State<DetailScren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Configurar el appBar como null para eliminarlo
      body: Center(
        child: Text('Contenido del cuerpo'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción cuando se presiona el botón flotante
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}