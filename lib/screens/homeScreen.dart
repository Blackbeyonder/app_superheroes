import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Llamar a tu método aquí
    SuperHeroeService().getNameAllSuperHeroes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Search character'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Contenido de la pantalla'),
      ),
    );
  }
}


class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  String? get searchFieldLabel => 'search...';

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
    // Implementa la lógica para mostrar sugerencias de búsqueda
    // Lista de sugerencias de búsqueda estáticas
  final List<String> suggestions = ['Sugerencia 1', 'Sugerencia 2', 'Sugerencia 3'];

  // Filtra las sugerencias basadas en el texto de búsqueda actual
  final filteredSuggestions = query.isEmpty
      ? suggestions // Si la consulta está vacía, muestra todas las sugerencias
      : suggestions.where((suggestion) => suggestion.toLowerCase().startsWith(query.toLowerCase())).toList();

  // Construye la lista de sugerencias
  return ListView.builder(
    itemCount: filteredSuggestions.length,
    itemBuilder: (context, index) {
      final suggestion = filteredSuggestions[index];
      return ListTile(
        title: Text(suggestion),
        onTap: () {
          // Acción cuando se selecciona una sugerencia
          close(context, suggestion);
        },
      );
    },
  );
  }
}
