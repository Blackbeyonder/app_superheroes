import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/superHeroeService.dart';
import '../widgets/favorite.dart';

class FavoriteMethods extends StatefulWidget {
  const FavoriteMethods({Key? key}) : super(key: key);

  @override
  _FavoriteMethodsState createState() => _FavoriteMethodsState();
}

class _FavoriteMethodsState extends State<FavoriteMethods> {

  List<Map<String, dynamic>> favoritesWithDetail = [];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: buildCardsFavorites(), // El Future que se está esperando
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // Estado del futuro: 'none', 'waiting', 'done', 'error'
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras el Future está en espera
            return CircularProgressIndicator(); // Mostrar un indicador de carga
          } else if (snapshot.hasError) {
            // Si hay un error al completar el Future
            return Text('Error: ${snapshot.error}');
          } else {
            // Cuando el Future se completa exitosamente
            return snapshot.data ?? Text('No hay datos');
          }
        },
      ),
    );
  }

  Future<Widget> buildCardsFavorites() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? favorites = prefs.getStringList('favorites') ?? [];
      

      for (var id in favorites) {
        Map<String, dynamic> characterInfo = {};
        var detail = await SuperHeroeService().getSearchById1(id);
        characterInfo["id"] = detail["id"];
        characterInfo["name"] = detail["name"];
        characterInfo["publisher"] = detail["biography"]["publisher"];

        var img = detail["image"] != null ? detail["image"]["url"] : "";
        bool exist = await SuperHeroeService().checkImageExistence(img);
        characterInfo["img"] = exist == true ? img : "not found";
        favoritesWithDetail.add(characterInfo);
      }

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
                  favoritesWithDetail.length, // Número de elementos en la lista
              itemBuilder: (BuildContext context, int index) {
                // Función que construye y devuelve una tarjeta para cada elemento
                final character = favoritesWithDetail[index];
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
                                characterID: character['id'],
                                
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
  void removeFromFavorites(String characterID) {
    setState(() {
      // Actualizar la lista de favoritos eliminando el personaje con el ID especificado
      favoritesWithDetail.removeWhere((character) => character['id'] == characterID);
      print(favoritesWithDetail);
    });
    // Implementar lógica para eliminar el personaje de la lista de favoritos
  }
}
