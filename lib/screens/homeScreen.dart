import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';
import '../widgets/searchAppBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(),
      body: Center(
        child: Text('Contenido de la pantalla'),
      ),
    );
  }
}

