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

Future<List<Map<String, dynamic>>> getNameAllSuperHeroes() async {
   List<Map<String, dynamic>> charactersName = [];


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
             Map<String, dynamic> character = {
                "id":"",
                "name":""
               };
           
            for (var i = 0; i < tdElements.length; i++) {
              var td = tdElements[i];
              var td2 = td.innerHtml;
              
               
              if(i==0){
                character["id"]=td2;
              }
              if(i==1){
                character["name"]=td2;
                charactersName.add(character);
              }
              
              
              // Imprime el índice y el contenido del elemento td
              // print('Índice: $i, Contenido: $td2');
            }
           

            // Itera sobre los elementos td y accede a su contenido interno
           
          }
        }
        //  print(charactersName);
      } else {
    // Ocurrió un error al hacer la solicitud
    print('Error al hacer la solicitud: ${response.statusCode}');
  }

  return charactersName;
}


getSearchById1(String id) async {
  try {
     Map<String, dynamic> results = {}; // Lista para almacenar los resultados
  final response = await http.get(Uri.parse(apiUrl+"/$id"));
  if (response.statusCode == 200) {
     // Convierte la respuesta JSON en un objeto Dart
    final responseData = jsonDecode(response.body);
    // print(responseData);
    responseData.forEach((key, value) {
      // print('Clave: $key, Valor: $value');
      if(key=="response" && value=="success"){
        results= responseData;
        return;
      }
    });
    // print(results);
    return results;
   
  } else {
    // Ocurrió un error al hacer la solicitud
    print('Error al hacer la solicitud: ${response.statusCode}');
  }
    
  } catch (e) {
    print(e);
    Map<String, dynamic> results = {};
    return results;
  }
 

}

Future<bool> checkImageExistence(String imageUrl) async {
  try {
    final response = await http.head(Uri.parse(imageUrl));
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
    
  } catch (e) {
    // Manejar errores, como conexión fallida, URL incorrecta, etc.
    return false;
  }
}



}
