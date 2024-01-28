import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';
import '../widgets/searchAppBar.dart';

class DetailScren extends StatefulWidget {
  const DetailScren({ Key? key }) : super(key: key);

  @override
  _DetailScrenState createState() => _DetailScrenState();
}

class _DetailScrenState extends State<DetailScren> {
  List<dynamic> dataCharacter = []; // Lista para almacenar los héroes
  String imageUrl="";
  
   String heroName = ''; 
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
      final String nameSelected = args['nameSelected'];

      // Llamar al servicio para obtener detalles del héroe
      final response = await SuperHeroeService().getSearchName1(nameSelected);

      // Procesar la respuesta del servicio y actualizar el estado
      setState(() {
         print(response);
        dataCharacter = response; // Actualizar el estado con el nombre del héroe
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
        child: Column(
          children: [
            if (imageUrl.isNotEmpty) // Verificar si imageUrl no está vacío
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Image.network(imageUrl),
            ),
          ],
        ),
      )
    );
  }
}