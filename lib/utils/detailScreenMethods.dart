import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/FavoriteProvider.dart';
import '../services/superHeroeService.dart';

class DetailScreenMethods {

  static Widget buildInfo(dataCharacter) {
    List<String> iWantIt = [
      "biography",
      "appearance",
      "work",
      "connections",
    ];

    Map<String, dynamic> newValues = {};

    dataCharacter.forEach((key, value) {
      // print('Clave: $key, Valor: $value');

      // Iterar sobre las claves que quieres conservar
      for (var key2 in iWantIt) {
        if (key == key2) {
          newValues[key2] = value;
        }
      }
    });


    List<Widget> infoLabels = [];
    
   newValues.forEach((key, value) {
      // print('Clave: $key, Valor: $value');
      value.forEach((key2, item) {
      
        if (item is List) {
            String numbersAsString = item.join(', ');
            item= numbersAsString;
          } 
          // capitalize(key2);
          String capitalizedKey = capitalize(key2);

          infoLabels.add(
             Container(
              child: Row(
                children:  [
                  Expanded(
                    flex: 3, // El primer Text toma el 20% del espacio disponible
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        capitalizedKey+":", // Texto de la etiqueta
                        style: TextStyle(
                          fontSize: 15, // Tamaño de fuente
                          fontWeight: FontWeight.bold, // Peso de la fuente
                          color: Color.fromARGB(255, 0, 0, 0), // Color del texto
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7, // El segundo Text toma el 80% del espacio disponible
                    child: Text(
                      item, // Texto de la etiqueta
                      style: TextStyle(
                        fontSize: 15, // Tamaño de fuente
                      ),
                    ),
                  ),
                ],
              ),
        ),
        
          );
      });
    });


    return Column(
      children: infoLabels,
    );
  }
 
 static String capitalize(String text) {
  return text.substring(0, 1).toUpperCase() + text.substring(1);
}

static Future<Map<String, dynamic>> findInfo(context,idSelected) async {

    try {
      Map<String, dynamic> response = {
        "imageUrl": {},
        "allInfo": {},
        "toFavorite": {},
      };
      // Llamar al servicio para obtener detalles del héroe
      final getSearchById1 = await SuperHeroeService().getSearchById1(idSelected);
      var img = getSearchById1["image"] != null ? getSearchById1["image"]["url"] : "";
      bool exist= await SuperHeroeService().checkImageExistence(img);
      getSearchById1["image"]["url"] = exist==true ? img : "not found";

      
      response["imageUrl"]=getSearchById1["image"]["url"];
      response["allInfo"]=getSearchById1;

      Map<String, dynamic> toFavorite={};

      toFavorite["id"]=getSearchById1["id"];
      toFavorite["name"]=getSearchById1["name"];
      toFavorite["img"]=getSearchById1["image"]["url"];
      toFavorite["publisher"]=getSearchById1["biography"]["publisher"];
      response["toFavorite"]=toFavorite;
      response["toFavorite"]["isFavorite"]=false;

      // {"id":"306","name":"Hal Jordan","img":"https://www.superherodb.com/pictures2/portraits/10/100/697.jpg","publisher":"DC Comics","isFavorite":true}

      // final storageData = Provider.of<FavoriteProvider>(context, listen: false).items;
      // var resultWhere = storageData.where((element) => element["id"] == getSearchById1["id"]);
      // print("resultWhere");
      // print(resultWhere);
      // if (resultWhere.isNotEmpty) {
      //   response["toFavorite"]["isFavorite"]=true;
      // } else {
      //   response["toFavorite"]["isFavorite"]=false;
      // }
      print("findInfo======");
      // print(storageData);
      print(response);
      
      return response;

      
    } catch (e) {
      Map<String, dynamic> response = {};
      print("error findInfo() = $e");
      return response;
      
    }
  
}


}
