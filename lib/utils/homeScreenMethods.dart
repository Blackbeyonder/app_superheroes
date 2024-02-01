import 'package:flutter/material.dart';
import 'dart:math';

import '../services/superHeroeService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/favorite.dart';

class HomeScreenMethods {
  static Future<Widget> buildInfo() async {
    Set<int> randomNumbers = generate10Numbers();
    List<Map<String, dynamic>> list10Characters = [];

    for (var number in randomNumbers) {
      Map<String, dynamic> characterInfo = {};
      String numberAsString = number.toString();
      var searchById1 =
          await SuperHeroeService().getSearchById1(numberAsString);
      if (searchById1?.containsKey('response') &&
          searchById1["response"] == "success") {
        characterInfo["id"] = searchById1["id"];
        characterInfo["name"] = searchById1["name"];

        //Check img
        var img =
            searchById1["image"] != null ? searchById1["image"]["url"] : "";
        bool exist = await SuperHeroeService().checkImageExistence(img);
        characterInfo["img"] = exist == true ? img : "";

        characterInfo["publisher"] = searchById1["biography"]["publisher"];

        list10Characters.add(characterInfo);
      }
    }

    try {
      return Container(
        color: const Color.fromARGB(255, 199, 199, 199),
        child: ListView.builder(
          itemCount: list10Characters.length,
          itemBuilder: (BuildContext context, int index) {
            final character = list10Characters[index];

            // Construir y devolver el elemento
            return GestureDetector(
              onTap: () {
                // Acción a realizar cuando se hace clic en la tarjeta
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: {
                    'idSelected': character['id'],
                  },
                );
                // Puedes llamar a una función aquí o ejecutar cualquier otra lógica
              },
              child: Card(
                margin: EdgeInsets.all(8.0), // Margen alrededor de la tarjeta
                child: Padding(
                  padding:
                      EdgeInsets.all(8.0), // Espaciado interno de la tarjeta
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(8.0), // Radio de la esquina
                        child: Image.network(
                          character["img"],
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Img no found');
                          },
                        ),
                      ),
                      SizedBox(height: 8), // Espacio entre la imagen y el texto
                      Row(
                        children: [
                          Text(
                            character["name"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Favorite(characterID:character['id']),
                        ],
                      ),
                      const SizedBox(
                          height: 4), // Espacio entre el nombre y el subtítulo
                      Text(
                        "Publisher: ${character["publisher"]}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    } catch (e) {
      print(e);
      return Text("mal");
    }
  }

  static String capitalize(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  static Set<int> generate10Numbers() {
    // Crear una instancia de Random
    Random random = Random();

    // Generar 10 números aleatorios únicos del 1 al 731
    Set<int> randomNumbers = {}; //Evita que se repita el numero
    while (randomNumbers.length < 10) {
      //IDS CHARACTERS
      int randomNumber = random.nextInt(731) + 1;
      randomNumbers.add(randomNumber);
    }
    return randomNumbers;
  }

  static Future<IconButton> isFavorite(context, String characterID) async {
    try {
      bool saved = await isSaved(characterID);

      if(saved==true){
        return IconButton(
        icon: const Icon(Icons.favorite_rounded, color: Colors.black),
        onPressed: () {
          selectAndDesselect("desSelect", characterID);
          // setState(() {});
        },
      );

      }else{
        return IconButton(
        icon: const Icon(Icons.favorite_outline_rounded, color: Colors.black),
        onPressed: () {
          selectAndDesselect("Select", characterID);
        },
      );

      }
      
    } catch (e) {
      print(e);
      return IconButton(
        icon: const Icon(Icons.heart_broken, color: Colors.black),
        onPressed: () {
          print("error");
        },
      );
    }
  }

  static Future<bool> isSaved(String characterID) async {
    
    // Recuperar una lista de enteros
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storageCharacters = prefs.getStringList('storageCharacters');
    if (storageCharacters != null) {
      List<int> getStorageList = storageCharacters.map((e) => int.parse(e)).toList();

      int numberToFind = int.parse(characterID);
      if (getStorageList.contains(numberToFind)) {
        print('Contiene');
        return true;
      } 
    }else{
      return false;
    } 

    return false;


  }

  static selectAndDesselect(String action, String characterID){
    if(action=="Select"){

    }

    if(action=="desSelect"){

    }
    

  }


  
}
