import 'package:flutter/material.dart';

class DetailScreenMethods {


  reorganizeObj(dataCharacter) {
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
      if(key==key2){
        newValues[key2]= value;

      }
     
    
    }

    });
    print(newValues);

    return [];
  }


}
