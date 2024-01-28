import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  //PreferredSizeWidget to use Custom Appbar
  const SearchAppBar({Key? key}) : super(key: key);

  //PreferredSizeWidget to use Custom Appbar
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  Future<List<Map<String, dynamic>>> charactersName = Future.value([]);

  @override
  void initState() {
    super.initState();
    // Llamar a tu método aquí
    charactersName = SuperHeroeService().getNameAllSuperHeroes();
    // print(charactersName);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.orange,
      title: const Text('Search character'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
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
            : suggestions.where((character) =>
                character['name'].toLowerCase().startsWith(query.toLowerCase()))
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
