import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  late List<Map<String, dynamic>> _itemsHome;

  HomeProvider() {
    _itemsHome=[];
     // Asignar un valor por defecto si initialData es null
  }

  List<Map<String, dynamic>> get itemsHome => _itemsHome;

  void updateItemsHome(List<Map<String, dynamic>> newData) {
    _itemsHome = newData;
    notifyListeners(); // Notificar a los consumidores sobre el cambio en los datos
  }

   void activerItem(newItem) {
    _itemsHome.forEach((element) => {
      if(element["id"]==newItem["id"]){
          element["isFavorite"]=true
      }
    });

    notifyListeners(); // Notificar a los consumidores sobre el cambio en los datos
  }

  void desactiveItem(itemId) {
    // print("desactiveItem");
    // print(itemId);
    _itemsHome.forEach((element) => {
      if(element["id"]==itemId){
          element["isFavorite"]=false
      }
    });
    // updateItemsHome(_itemsHome);
    // print("deacativate----itemhome");
    // print(_itemsHome);
    notifyListeners(); // Notificar a los consumidores sobre el cambio en los datos
  }







}
