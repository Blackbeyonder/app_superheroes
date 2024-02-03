import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/cardModel.dart';
import '../provider/homeProvider.dart';

class Favorite extends StatefulWidget {
  const Favorite({ Key? key, required this.character }) : super(key: key);
  final Map<String, dynamic> character;
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
     // Obtener una instancia del modelo de datos
        CardModel dataModel = Provider.of<CardModel>(context, listen: false);
        final homeProvider = Provider.of<HomeProvider>(context,listen: true);
   return IconButton(
        icon: widget.character["isFavorite"]
            ? const Icon(Icons.favorite_rounded, color: Colors.red) // Si es favorito, muestra el icono de favorito lleno
            : const Icon(Icons.favorite_border_rounded, color: Colors.black), // Si no es favorito, muestra el icono de favorito vacío
        onPressed: () {
          toggleFavorite(context, homeProvider); // Alternar estado de favorito cuando se presiona el botón
          // Llamar al método updateData
        dataModel.updateData();
        
   });
  }
  
  // Método para verificar si el personaje es favorito
  Future<void> checkIsFavorite() async {
    
    List<Map<String, dynamic>> storageData = await obtenerListaDesdeSharedPreferences();
   

    if (storageData.isNotEmpty) {
      List<int> favoriteIds = storageData.map((character) => int.parse(character["id"])).toList();
      int numberToFind=int.parse(widget.character["id"]);
      setState(() {
        widget.character["isFavorite"] = favoriteIds.contains(numberToFind);
        
      });
    }
  }

  // Método para alternar el estado de favorito
  Future<void> toggleFavorite(BuildContext context,homeProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> storageData = await obtenerListaDesdeSharedPreferences();

   
        
    
   
      if (widget.character["isFavorite"]) {
        // Remover el elemento con el id específico
        storageData.removeWhere((element) => element['id'] == widget.character["id"]);
        widget.character["isFavorite"]=false;
        homeProvider.desactiveItem(widget.character["id"]);
        
      } else {
        widget.character['isFavorite'] = true;
        storageData.add(widget.character); // Agregar el personaje a la lista de favoritos
        homeProvider.activerItem(widget.character);
      }
      print(storageData);
       String listaJSON = json.encode(storageData);
       prefs.setString('favorites', listaJSON); // Guardar la lista de favoritos actualizada en SharedPreferences
     
     setState(() {});
  }

  Future<List<Map<String, dynamic>>> obtenerListaDesdeSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  
    // Obtener la cadena JSON de SharedPreferences
    String? listaJSON = prefs.getString('favorites');
    print(listaJSON);
    // return [];
    // Convertir la cadena JSON a una lista de mapas
    if (listaJSON != null && listaJSON.isNotEmpty) {
      List<dynamic> listaDynamic = json.decode(listaJSON);
      List<Map<String, dynamic>> listaMap = List<Map<String, dynamic>>.from(listaDynamic);
      return listaMap;
    } else {
      return []; // O algún valor predeterminado si no se encuentra la lista
    }
}

}

class Favorite2 extends StatefulWidget {
  final String itemId;
  const Favorite2({ Key? key, required this.itemId }) : super(key: key);

  @override
  _FavoriteState2 createState() => _FavoriteState2();
}

class _FavoriteState2 extends State<Favorite2> {
  @override
  Widget build(BuildContext context) {
    final isFavorite = Provider.of<CardModel>(context)
        .items
        .firstWhere((item) => item['id'] == widget.itemId)['isFavorite'];
        print(isFavorite);
        final cardModel = Provider.of<CardModel>(context); // Obtiene la instancia de CardModel desde el context

    final homeProvider = Provider.of<HomeProvider>(context,listen: false);
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      onPressed: () {
        cardModel.removeItemById(widget.itemId);
         homeProvider.desactiveItem(widget.itemId);
        
      },
    );

  }
}
