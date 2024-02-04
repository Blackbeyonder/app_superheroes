import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:search_superheroes/widgets/favorite.dart';

import '../services/superHeroeService.dart';
import '../utils/detailScreenMethods.dart';
import '../widgets/searchAppBar.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic> dataCharacter = {}; // Lista para almacenar los héroes
  String imageUrl = "";

  String Name = '';
  String idSelected = '';
  @override
  void initState() {
    super.initState();
    // _getHeroDetails();
  }


  // Método asincrónico para obtener detalles del héroe
  Future _getHeroDetails() async {
    try {
      // print("AQUI");
      // Obtén los argumentos pasados desde la ruta anterior
      final Map<String, dynamic> args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      idSelected = args['idSelected'];
      Map<String, dynamic> info= await DetailScreenMethods.findInfo(context,idSelected);
      return info;

    } catch (error) {
      // Manejar errores si la solicitud falla
      print('Error en la solicitud: $error');
    }
  }

  PreferredSizeWidget? checkInfoAppBar(infoAppBar) {
    print(dataCharacter["infoAppBar"]);
  if (infoAppBar != null && infoAppBar.isNotEmpty) {
    return SearchAppBar(imageUrl: infoAppBar);
  } else {
    return SearchAppBar();
  }
}

  @override
  Widget build(BuildContext context) {
    // return Text("algo");
    return FutureBuilder(
    future: _getHeroDetails(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (snapshot.hasError) {
        return const Center(
          child: Text('Error al cargar los detalles'),
        );
      } else {
        Map<String, dynamic> dataCharacter = snapshot.data as Map<String, dynamic>;
        // Manipula los datos aquí 
        String characterName = dataCharacter["allInfo"]['name'];
        String imageUrl = dataCharacter["imageUrl"];
        Map<String, dynamic> toFavorite= dataCharacter["toFavorite"];

        // Puedes usar los datos manipulados para construir tus widgets
        return Scaffold(
          appBar: checkInfoAppBar(imageUrl),
          body: Container(
          color: Color.fromARGB(255, 240, 240, 240),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(characterName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Favorite(character: toFavorite, mode: "home")
                ],
              ),
              if (imageUrl.isNotEmpty) // Verificar si imageUrl no está vacío
                Center(
                  child: showImg(imageUrl: imageUrl, Name: characterName),
                ),
              if (imageUrl.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.10),
                    child: CircularProgressIndicator(),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      // color: Colors.blue,
                      child: DetailScreenMethods.buildInfo(dataCharacter["allInfo"])),
                ),
              ),
            ],
          ),
        )
        );
      }
    },
  );
    
  }
}

class showImg extends StatelessWidget {
  const showImg({
    Key? key,
    required this.imageUrl,
    required this.Name,
  }) : super(key: key);

  final String imageUrl;
  final String Name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5), // Define el radio de borde
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 65, 65, 65)
                    .withOpacity(0.5), // Color y opacidad de la sombra
                spreadRadius: 5, // Extensión de la sombra
                blurRadius: 10, // Difuminado de la sombra
                offset: Offset(
                    0, 4), // Desplazamiento de la sombra (horizontal, vertical)
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              // Acción que deseas realizar cuando se toca la imagen
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal:
                                  16), // Ajusta el espaciado del contenedor del texto
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 233, 233, 233),
                            borderRadius: BorderRadius.circular(
                                10), // Define el radio de borde del contenedor
                          ),
                          child: Text(
                            Name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 15), // Espacio entre la imagen y el texto
                        Container(
                          height: 500, // Altura de la imagen
                          width: double.infinity,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Devuelve un widget alternativo en caso de error
                              return const Text('Img not found');
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Image.network(
              imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) {
                // Devolver un widget alternativo en caso de error
                return const Text('Imagen no encontrada');
              },
            ),
          ),
        ),
      ),
    );
  }
}
