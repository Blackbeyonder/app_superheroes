import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/cardModel.dart';
import '../widgets/favorite.dart';
import '../widgets/searchAppBar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({ Key? key }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

   @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
     final items = Provider.of<CardModel>(context).items;
     
    return Scaffold(
      appBar: const SearchAppBar(),
      body:  ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Card(
          child: ListTile(
            title: Text(item['title']),
            subtitle: Text(item['subtitle']),
            trailing: Favorite2(itemId: item['id']),
          ),
        );
      },
    ),
      
    );
  }

 
}