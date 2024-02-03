import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';
import '../utils/searchAppBarMethods.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  //PreferredSizeWidget to use Custom Appbar
  final String imageUrl;
  const SearchAppBar({Key? key, this.imageUrl = ""}) : super(key: key);

  //PreferredSizeWidget to use Custom Appbar
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  Future<List<Map<String, dynamic>>> charactersName = Future.value([]);
  Color predominateColor = Colors.orange;
  Color textColorAndIcon = Colors.white;

  @override
  void initState() {
    super.initState();
    // Llamar a tu método aquí

    charactersName = SuperHeroeService().getNameAllSuperHeroes();
    this.obtenerColor(widget.imageUrl);
    // print(charactersName);
    //  print(widget.imageUrl);
  }

  void obtenerColor(String img) async {
    // Actualizar el estado después de obtener el color

    // Esperar a que se complete el futuro y obtener el color predominante
    var response = await SearchAppBarMethods().findIMGColor(img);

    setState(() {
      predominateColor = response;
      final luminance = predominateColor.computeLuminance();
      textColorAndIcon = luminance > 0.5
          ? Colors.black
          : Colors
              .white; // Si es claro, usa texto negro; de lo contrario, usa texto blanco
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return AppBar(
      backgroundColor: predominateColor,
      title: Text(
        'Search character',
        style: TextStyle(
          color: textColorAndIcon, // Utiliza el color determinado para el texto
          fontSize: 16, // Tamaño de fuente
          fontWeight: FontWeight.bold, // Peso de la fuente
        ),
      ),
      iconTheme: IconThemeData(color: textColorAndIcon),
      actions: [
        IconButton(
          icon: Icon(
            currentRoute == '/favorites' ? Icons.favorite: Icons.favorite_outline_rounded,
            color: textColorAndIcon,
          ),
          onPressed: () {
            // Verificar si la ruta actual ya es la pantalla de favoritos
            if (currentRoute != '/favorites') {
              Navigator.pushNamed(context, '/favorites');
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.search, color: textColorAndIcon),
          onPressed: () {
            showSearch(
                context: context,
                delegate: CustomSearchDelegate(charactersName));
          },
        ),
      ],
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  String? get searchFieldLabel => 'search...';

  final Future<List<Map<String, dynamic>>> charactersName;
  CustomSearchDelegate(this.charactersName);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implementa la lógica para mostrar los resultados de la búsqueda
    return Center(
      child: Text('Resultados para "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: charactersName, // Tu Future<List<Map<String, dynamic>>>
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Si está esperando la carga, muestra un indicador de progreso
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Si hay un error, muestra un mensaje de error
          return Center(
            child: Text('Error al cargar los datos'),
          );
        } else {
          // Si la carga fue exitosa, puedes acceder a los datos en snapshot.data
          final List<Map<String, dynamic>> suggestions = snapshot.data!;
          final filteredSuggestions = query.isEmpty
              ? suggestions
              : suggestions
                  .where((character) => character['name']
                      .toLowerCase()
                      .startsWith(query.toLowerCase()))
                  .toList();

          return ListView.builder(
            itemCount: filteredSuggestions.length,
            itemBuilder: (context, index) {
              final suggestion = filteredSuggestions[index];
              return ListTile(
                title: Text(suggestion['name']),
                onTap: () {
                  close(context, suggestion['name']);
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: {
                      'idSelected': suggestion['id'],
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
