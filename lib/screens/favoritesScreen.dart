import 'package:flutter/material.dart';

import '../widgets/searchAppBar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({ Key? key }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(),
      body: Text("test"),
      
    );
  }
}