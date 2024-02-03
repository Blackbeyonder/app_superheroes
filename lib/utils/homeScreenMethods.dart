import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../provider/homeProvider.dart';
import '../services/superHeroeService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/favorite.dart';

class HomeScreenMethods {
  static Future<Widget> buildInfo (BuildContext context) async {
    Set<int> randomNumbers = generate10Numbers();
    List<Map<String, dynamic>> list10Characters = [];

    for (var number in randomNumbers) {
      Map<String, dynamic> characterInfo = {};
      String numberAsString = number.toString();
      var searchById1 = await SuperHeroeService().getSearchById1(numberAsString);
      if (searchById1?.containsKey('response') &&
          searchById1["response"] == "success") {
          characterInfo["id"] = searchById1["id"];
          characterInfo["name"] = searchById1["name"];

          //Check img
          var img = searchById1["image"] != null ? searchById1["image"]["url"] : "";
          bool exist = await SuperHeroeService().checkImageExistence(img);
          characterInfo["img"] = exist == true ? img : "";

          characterInfo["publisher"] = searchById1["biography"]["publisher"];
          characterInfo["isFavorite"] = false;
          list10Characters.add(characterInfo);
      }
    }

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.updateItemsHome(list10Characters);
    final itemsHome = homeProvider.itemsHome;

    // print("HOME");
    // print(itemsHome);
    // print("HOME----");

    try {
      return Container(
        color: const Color.fromARGB(255, 199, 199, 199),
        child: ListView.builder(
          itemCount: itemsHome.length,
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
                          Favorite(character:character, mode:"home"),
                        ],
                      ),
                      
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





  
}
