import 'package:flutter/material.dart';

import '../services/superHeroeService.dart';
import '../utils/homeScreenMethods.dart';
import '../widgets/searchAppBar.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
     // Comienza a escuchar los eventos del acelerómetro
    // accelerometerEvents.listen((AccelerometerEvent event) {
    //   // Si el valor absoluto de cualquiera de las componentes supera 10, se considera una sacudida
    //   if (event.x.abs() > 10 || event.y.abs() > 10 || event.z.abs() > 10) {
    //     // Imprime un mensaje cuando se detecta una sacudida
    //     print('¡El dispositivo se está sacudiendo!');
    //     updateData();
    //   }
    // });
  }

  // Variable para controlar el estado de "refresh"
  bool _isRefreshing = false;

  // Función para manejar el "refresh"
  Future<void> _handleRefresh() async {
    // Marca que el "refresh" está en curso
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isRefreshing = true;
    });

    // Simula una espera de 2 segundos
    

    // Luego del "refresh", marca que ha terminado
    setState(() {
      _isRefreshing = false;
    });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Center(
          child: FutureBuilder(
            future: HomeScreenMethods.buildInfo(context),
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

  Future updateData(BuildContext context) async {
    // print("Refresh");
    await HomeScreenMethods.buildInfo(context);
    setState(() {});
  }
}
