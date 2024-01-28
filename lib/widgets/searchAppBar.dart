import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget{//PreferredSizeWidget to use Custom Appbar
  const SearchAppBar({ Key? key }) : super(key: key);

  //PreferredSizeWidget to use Custom Appbar
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  Future<List<String>>  charactersName = Future.value([]);

  @override
  void initState() {
    super.initState();
    // Llamar a tu método aquí
    charactersName= SuperHeroeService().getNameAllSuperHeroes();
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
              showSearch(context: context, delegate: CustomSearchDelegate(charactersName));
            },
          ),
        ],
      );
  }
}


class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  String? get searchFieldLabel => 'search...';

  final Future<List<String>> charactersName;
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
    return FutureBuilder<List<String>>(
      future: charactersName,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar los datos'),
          );
        } else {

          final List<String> suggestions = snapshot.data!;
          final filteredSuggestions = query.isEmpty
              ? suggestions
              : suggestions.where((suggestion) => suggestion.toLowerCase().startsWith(query.toLowerCase())).toList();
          
          return ListView.builder(
            itemCount: filteredSuggestions.length,
            itemBuilder: (context, index) {
              final suggestion = filteredSuggestions[index];
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  close(context, suggestion);
                  Navigator.pushNamed(context, '/detail');

                },
              );
            },
          );
        }
      },
    );
  }
}