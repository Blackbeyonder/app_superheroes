import 'dart:convert';

import 'package:app_superheroes/utils/url.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;


class SuperHeroeService{
  void fetchData() async {
  final response = await http.get(Uri.parse(apiUrl+"/1"));
  if (response.statusCode == 200) {
    // La solicitud fue exitosa
    print('Respuesta del servidor: ${response.body}');
  } else {
    // Ocurrió un error al hacer la solicitud
    print('Error al hacer la solicitud: ${response.statusCode}');
  }
}

Future<List<String>> getNameAllSuperHeroes() async {
   List<String> charactersName = [];


  final response = await http.get(Uri.parse("https://superheroapi.com/ids.html"));
  //TEST PARA LLENAR EL ARRAY DE PERSONAJES

      if (response.statusCode == 200) {
        String contenido = response.body;
        // Analizar el contenido HTML
        var document = parser.parse(contenido);

        // Encuentra la etiqueta específica por su nombre
        var elementos = document.querySelectorAll('table tbody');

        // Itera sobre los elementos y haz algo con ellos
        for (var elemento in elementos) {
          // print('Contenido de la etiqueta:');
          // print(elemento.innerHtml);
          var trElements = elemento.getElementsByTagName('tr');

          // Itera sobre los elementos tr y accede a sus elementos td
          for (var tr in trElements) {

            var tdElements = tr.getElementsByTagName('td');
            for (var i = 0; i < tdElements.length; i++) {
              var td = tdElements[i];
              var td2 = td.innerHtml;
              if(i==1){
                charactersName.add(td2);

              }
              
              // Imprime el índice y el contenido del elemento td
              // print('Índice: $i, Contenido: $td2');
            }
           

            // Itera sobre los elementos td y accede a su contenido interno
           
          }
        }
         print(charactersName);
      } else {
    // Ocurrió un error al hacer la solicitud
    print('Error al hacer la solicitud: ${response.statusCode}');
  }

  return charactersName;
}


getSearchName1(String name) async {
  List<dynamic> results = []; // Lista para almacenar los resultados
  final response = await http.get(Uri.parse(apiUrl+"/search/$name"));
  if (response.statusCode == 200) {
     // Convierte la respuesta JSON en un objeto Dart
    final responseData = jsonDecode(response.body);
    // print(responseData);
    responseData.forEach((key, value) {
      print('Clave: $key, Valor: $value');
      if(key=="results"){
        results= value;
        return;
      }
    });
    return results;
   
  } else {
    // Ocurrió un error al hacer la solicitud
    print('Error al hacer la solicitud: ${response.statusCode}');
  }

}


}
