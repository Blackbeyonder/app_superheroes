import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';

class SearchAppBarMethods {
  Future<Color> findIMGColor(String img) async {
    if (img != "") {
      try {
        // Cargar la imagen desde la URL
        final ByteData data = await NetworkAssetBundle(Uri.parse(img)).load('');
        final Uint8List bytes = data.buffer.asUint8List();

        // Generar la paleta de colores
        final PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImageProvider(
          MemoryImage(bytes),
          size: Size(100,
              100), // Tamaño de la imagen de muestra para el análisis de color
          maximumColorCount: 20, // Número máximo de colores en la paleta
        );

        // Obtener el color predominante de la paleta
        Color colorPredominante =
            paletteGenerator.dominantColor?.color ?? Colors.orange;
            
        // print(colorPredominante);
        return colorPredominante;
        
      } catch (e) {
        return Colors.orange;
      }
    }else{
      return Colors.orange;
    }
  }
}
