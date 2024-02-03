import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/sharedPreference.dart';

class FavoriteProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  late List<Map<String, dynamic>> _items;

  FavoriteProvider() {
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
  List<Map<String, dynamic>> storageData = await getfavorites();

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


  
}
