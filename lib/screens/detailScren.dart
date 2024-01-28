import 'package:flutter/material.dart';

import '../widgets/searchAppBar.dart';

class DetailScren extends StatefulWidget {
  const DetailScren({ Key? key }) : super(key: key);

  @override
  _DetailScrenState createState() => _DetailScrenState();
}

class _DetailScrenState extends State<DetailScren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(),
      body: Center(
        child: Text('Contenido de la pantalla2'),
      ),
    );
  }
}