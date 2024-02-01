import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    checkIsFavorite(); // Verificar si el personaje es favorito al inicializar el estado
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(),
      body: Text("test"),
      
    );
  }

  // Método para verificar favoritos
  Future<void> checkIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];
    print(favorites);
  }
}