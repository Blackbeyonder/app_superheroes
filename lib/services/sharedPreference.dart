import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getfavorites() async {
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
