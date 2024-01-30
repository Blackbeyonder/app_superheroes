import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';
import '../utils/homeScreenMethods.dart';
import '../widgets/searchAppBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: const SearchAppBar(),
  body: Center(
    child: Container(
      color: Color.fromARGB(255, 199, 199, 199),
      child: FutureBuilder(
        future: HomeScreenMethods.buildInfo(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return snapshot.data ?? Text('No hay datos');
          }
        },
      ),
    ),
  ),
);


  }
}

