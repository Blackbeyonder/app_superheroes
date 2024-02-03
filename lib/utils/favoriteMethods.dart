import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/FavoriteProvider.dart';
import '../services/superHeroeService.dart';
import '../widgets/favorite.dart';

class FavoriteMethods {



  Future<Widget> buildCardsFavorites(BuildContext context) async {
    try {
      //  List<Map<String, dynamic>> storageData = await obtenerListaDesdeSharedPreferences();
      final storageData = Provider.of<FavoriteProvider>(context).items;
      return Container(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text("Favorites",
                style: TextStyle(
                  fontSize: 30, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Peso de la fuente
                )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  storageData.length, // Número de elementos en la lista
              itemBuilder: (BuildContext context, int index) {
                // Función que construye y devuelve una tarjeta para cada elemento
                final character = storageData[index];
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
                    margin: const EdgeInsets.all(
                        8.0), // Margen alrededor de la tarjeta
                    child: Padding(
                      padding: const EdgeInsets.all(
                          8.0), // Espaciado interno de la tarjeta
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8.0), // Radio de la esquina
                            child: Image.network(
                              character["img"],
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text('Img no found');
                              },
                            ),
                          ),
                          const SizedBox(
                              height: 8), // Espacio entre la imagen y el texto
                          Row(
                            children: [
                              Text(
                                character["name"],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Favorite(
                                character: character,
                                mode:"favorite"
                                
                              ),
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
          ),
        ],
      ));
    } catch (e) {
      print(e);
      return Container(child: Text("error $e"));
    }
  }
  

 
}
