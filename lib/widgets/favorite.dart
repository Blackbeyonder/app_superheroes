import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatefulWidget {
  const Favorite({ Key? key, required this.characterID }) : super(key: key);
  final String characterID;
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool _isFavorite = false; // Estado de favorito

  @override
  void initState() {
    super.initState();
    checkIsFavorite(); // Verificar si el personaje es favorito al inicializar el estado
  }

  @override
  Widget build(BuildContext context) {
   return IconButton(
        icon: _isFavorite
            ? const Icon(Icons.favorite_rounded, color: Colors.red) // Si es favorito, muestra el icono de favorito lleno
            : const Icon(Icons.favorite_border_rounded, color: Colors.black), // Si no es favorito, muestra el icono de favorito vacío
        onPressed: () {
          toggleFavorite(); // Alternar estado de favorito cuando se presiona el botón
   });
  }
  
  // Método para verificar si el personaje es favorito
  Future<void> checkIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];
    if (favorites.isNotEmpty) {
      List<int> favoriteIds = favorites.map((id) => int.parse(id)).toList();
      int numberToFind=int.parse(widget.characterID);
      setState(() {
        _isFavorite = favoriteIds.contains(numberToFind);
      });
    }
  }

  // Método para alternar el estado de favorito
  Future<void> toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      if (_isFavorite) {
        favorites.remove(widget.characterID); // Quitar el personaje de la lista de favoritos
        _isFavorite=false;
      } else {
        favorites.add(widget.characterID); // Agregar el personaje a la lista de favoritos
         _isFavorite=true;
      }
      prefs.setStringList('favorites', favorites); // Guardar la lista de favoritos actualizada en SharedPreferences
    });
  }
}