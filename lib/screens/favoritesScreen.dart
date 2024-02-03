import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/cardModel.dart';
import '../utils/favoriteMethods.dart';
import '../widgets/favorite.dart';
import '../widgets/searchAppBar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({ Key? key }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

   @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: const SearchAppBar(),
      body:   Center(
      child: FutureBuilder(
        future: FavoriteMethods().buildCardsFavorites(context), // El Future que se está esperando
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // Estado del futuro: 'none', 'waiting', 'done', 'error'
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras el Future está en espera
            return CircularProgressIndicator(); // Mostrar un indicador de carga
          } else if (snapshot.hasError) {
            // Si hay un error al completar el Future
            return Text('Error: ${snapshot.error}');
          } else {
            // Cuando el Future se completa exitosamente
            return snapshot.data ?? Text('No hay datos');
          }
        },
      ),
    )
      
    );
  }

 
}