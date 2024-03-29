import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/FavoriteProvider.dart';
import '../provider/homeProvider.dart';
import '../services/sharedPreference.dart';

class Favorite extends StatefulWidget {
  const Favorite({ Key? key, required this.character, required  this.mode }) : super(key: key);
  final Map<String, dynamic> character;
  final String mode;
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
        FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context, listen: true);
        final homeProvider = Provider.of<HomeProvider>(context,listen: true);
   return IconButton(
        icon: widget.character["isFavorite"]
            ? const Icon(Icons.favorite_rounded, color: Colors.red) // Si es favorito, muestra el icono de favorito lleno
            : const Icon(Icons.favorite_border_rounded, color: Colors.black), // Si no es favorito, muestra el icono de favorito vacío
        onPressed: () {
          checkMode(widget.mode,context, homeProvider, favoriteProvider);
        
   });
  }

  checkMode(mode, context, homeProvider, favoriteProvider) async {
    if(mode=="home"){
       toggleFavorite(context, homeProvider); // Alternar estado de favorito cuando se presiona el botón
          // Llamar al método updateData
          favoriteProvider.updateData();

    }
    if(mode=="favorite"){

      bool result = await showDialogDelete(context, '¿Do you want delete it?');
        // print(result);
        if (result) {
          favoriteProvider.removeItemById(widget.character["id"]);
          homeProvider.desactiveItem(widget.character["id"]);
        } 

    }

  }
  
  // Método para verificar si el personaje es favorito
  Future<void> checkIsFavorite() async {
    
    List<Map<String, dynamic>> storageData = await getfavorites();
   
    if (storageData.isNotEmpty) {
      List<int> favoriteIds = storageData.map((character) => int.parse(character["id"])).toList();
      int numberToFind=int.parse(widget.character["id"]);
      setState(() {
        
        if(favoriteIds.contains(numberToFind)){
            widget.character["isFavorite"] = true;
        }else{
            widget.character["isFavorite"] = false;
        }
        
      });
    }
  }

  // Método para alternar el estado de favorito
  Future<void> toggleFavorite(BuildContext context, homeProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> storageData = await getfavorites();

      if (widget.character["isFavorite"]) {
        // Remover el elemento con el id específico
        storageData.removeWhere((element) => element['id'] == widget.character["id"]);
        homeProvider.desactiveItem(widget.character["id"]);
        
      } else {
        storageData.add(widget.character); // Agregar el personaje a la lista de favoritos
        homeProvider.activerItem(widget.character);
      }
       String listaJSON = json.encode(storageData);
       prefs.setString('favorites', listaJSON); // Guardar la lista de favoritos actualizada en SharedPreferences
     
  }

  static Future<bool> showDialogDelete(BuildContext context, String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Retorna true si el usuario selecciona "Sí"
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Retorna false si el usuario selecciona "No"
              },
              child: Text('No'),
            ),
          ],
        );
      },
    ) ?? false; // Por defecto, retorna false si el diálogo se cierra sin seleccionar ninguna opción
  }
  


}

