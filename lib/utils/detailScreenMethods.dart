import 'package:flutter/material.dart';

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
}
