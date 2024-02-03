import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardModel extends ChangeNotifier {
  late SharedPreferences _prefs;
  late List<Map<String, dynamic>> _items;

  CardModel() {
    _items = [];
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadItemsFromPrefs();
  }

  List<Map<String, dynamic>> get items => _items;

  void _loadItemsFromPrefs() async {
  // Obtener la cadena JSON de SharedPreferences
  List<Map<String, dynamic>> storageData = await obtenerListaDesdeSharedPreferences();

    _items = storageData;
    notifyListeners();
}

 Future<void> removeItemById(String id) async {
    _items.removeWhere((element) => element['id'] == id);
    await _saveItemsToPrefs();
    notifyListeners();
  }

  Future<void> _saveItemsToPrefs() async {
    // Convertir la lista de mapas a una cadena JSON
    String listaJSON = json.encode(_items);

    // Guardar la cadena JSON en SharedPreferences
    await _prefs.setString('favorites', listaJSON);
    notifyListeners();
  }

  updateData(){
    _init();
    notifyListeners();

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
