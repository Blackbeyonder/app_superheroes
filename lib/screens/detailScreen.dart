import 'package:flutter/material.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Llamar al método para obtener detalles de los héroes al cambiar las dependencias
    this._getHeroDetails();
  }

  // Método asincrónico para obtener detalles del héroe
  Future<void> _getHeroDetails() async {
    try {
      // print("AQUI");
      // Obtén los argumentos pasados desde la ruta anterior
      final Map<String, dynamic> args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      idSelected = args['idSelected'];

      // Llamar al servicio para obtener detalles del héroe
      final response = await SuperHeroeService().getSearchById1(idSelected);
      var img = response["image"] != null ? response["image"]["url"] : "";
        bool exist= await SuperHeroeService().checkImageExistence(img);
        response["image"]["url"] = exist==true ? img : "not found";

      // Procesar la respuesta del servicio y actualizar el estado
      setState(() {
        // print(response);
        dataCharacter =
            response; // Actualizar el estado con el nombre del héroe
        imageUrl = dataCharacter["image"]["url"];
        Name = dataCharacter["name"];
        // DetailScreenMethods().reorganizeObj(dataCharacter);
        // print(imageUrl);
      });
    } catch (error) {
      // Manejar errores si la solicitud falla
      print('Error en la solicitud: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: imageUrl.isNotEmpty
            ? SearchAppBar(imageUrl: imageUrl)
            : null, //Nose porque funciona con null
        body: Container(
          color: Color.fromARGB(255, 240, 240, 240),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(Name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              if (imageUrl.isNotEmpty) // Verificar si imageUrl no está vacío
                Center(
                  child: showImg(imageUrl: imageUrl, Name: Name),
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
                      child: DetailScreenMethods.buildInfo(dataCharacter)),
                ),
              ),
            ],
          ),
        ));
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
                          padding: EdgeInsets.symmetric(
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
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
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
