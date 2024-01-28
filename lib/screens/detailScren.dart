import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';
import '../widgets/searchAppBar.dart';

class DetailScren extends StatefulWidget {
  const DetailScren({Key? key}) : super(key: key);

  @override
  _DetailScrenState createState() => _DetailScrenState();
}

class _DetailScrenState extends State<DetailScren> {
  List<dynamic> dataCharacter = []; // Lista para almacenar los héroes
  String imageUrl = "";

List<String> data = [
  'Superman',
  'Batman',
  'Wonder Woman',
  'Spider-Man',
  // Agrega más nombres de superhéroes según sea necesario
];

  String heroName = '';
  String nameSelected = '';
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
      print("AQUI");
      // Obtén los argumentos pasados desde la ruta anterior
      final Map<String, dynamic> args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      nameSelected = args['nameSelected'];

      // Llamar al servicio para obtener detalles del héroe
      final response = await SuperHeroeService().getSearchName1(nameSelected);

      // Procesar la respuesta del servicio y actualizar el estado
      setState(() {
        print(response);
        dataCharacter =
            response; // Actualizar el estado con el nombre del héroe
        imageUrl = dataCharacter[0]["image"]["url"];
        print(imageUrl);
      });
    } catch (error) {
      // Manejar errores si la solicitud falla
      print('Error en la solicitud: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SearchAppBar(),
        body: Container(
          color: Color.fromARGB(255, 240, 240, 240),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(nameSelected,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              if (imageUrl.isNotEmpty) // Verificar si imageUrl no está vacío
                Center(
                  child: showImg(imageUrl: imageUrl),
                ),
              if (imageUrl.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.10),
                    child: CircularProgressIndicator(),
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
  }) : super(key: key);

  final String imageUrl;

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
          child: Image.network(
            imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
