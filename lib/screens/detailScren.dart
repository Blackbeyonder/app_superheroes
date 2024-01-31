import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';
import '../utils/detailScreenMethods.dart';
import '../widgets/searchAppBar.dart';

class DetailScren extends StatefulWidget {
  const DetailScren({Key? key}) : super(key: key);

  @override
  _DetailScrenState createState() => _DetailScrenState();
}

class _DetailScrenState extends State<DetailScren> {
  Map<String, dynamic> dataCharacter = {}; // Lista para almacenar los héroes
  String imageUrl = "";
//[]  {}   "":""
 List<Map<String, dynamic>> characterTest =[
    {
      "id": "69",
      "name": "Batman",
      "powerstats": {
        "intelligence": "81",
        "strength": "40",
        "speed": "29",
        "durability": "55",
        "power": "63",
        "combat": "90"
      },
      "biography": {
        "full-name": "Terry McGinnis",
        "alter-egos": "No alter egos found.",
        "aliases": [
          "Batman II",
          "The Tomorrow Knight",
          "The second Dark Knight",
          "The Dark Knight of Tomorrow",
          "Batman Beyond"
        ],
        "place-of-birth": "Gotham City, 25th Century",
        "first-appearance": "Batman Beyond #1",
        "publisher": "DC Comics",
        "alignment": "good"
      },
      "appearance": {
        "gender": "Male",
        "race": "Human",
        "height": [
          "5'10",
          "178 cm"
        ],
        "weight": [
          "170 lb",
          "77 kg"
        ],
        "eye-color": "Blue",
        "hair-color": "Black"
      },
      "work": {
        "occupation": "-",
        "base": "21st Century Gotham City"
      },
      "connections": {
        "group-affiliation": "Batman Family, Justice League Unlimited",
        "relatives": "Bruce Wayne (biological father), Warren McGinnis (father, deceased), Mary McGinnis (mother), Matt McGinnis (brother)"
      },
      "image": {
        "url": "https://www.superherodb.com/pictures2/portraits/10/100/10441.jpg"
      }
    },
 ];


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
        appBar: imageUrl.isNotEmpty ? SearchAppBar(imageUrl: imageUrl) : null, //Nose porque funciona con null
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
                  child: showImg(imageUrl: imageUrl),
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
                    child: DetailScreenMethods.buildInfo(dataCharacter)

                  ),
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
            errorBuilder: (context, error, stackTrace) {
            // Devolver un widget alternativo en caso de error
            return const Text('Imagen no encontrada');
          },
          ),
        ),
      ),
    );
  }
}
