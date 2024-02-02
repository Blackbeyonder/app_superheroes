import 'package:flutter/material.dart';

class CardModel extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [
    {'id': '1', 'title': 'Item 1', 'subtitle': 'Subtitle 1', 'isFavorite': true},
    {'id': '2', 'title': 'Item 2', 'subtitle': 'Subtitle 2', 'isFavorite': true},
    {'id': '3', 'title': 'Item 3', 'subtitle': 'Subtitle 3', 'isFavorite': true},
  ];

  List<Map<String, dynamic>> get items => _items;

  void toggleFavorite(String itemId) {
    final itemIndex = _items.indexWhere((item) => item['id'] == itemId);
    if (itemIndex != -1) {
      _items[itemIndex]['isFavorite'] = !_items[itemIndex]['isFavorite'];
      notifyListeners();
    }
  }

  void removeFavorite(String itemId) {
    _items.removeWhere((item) => item["id"] == itemId);
    notifyListeners(); // Notifica a los consumidores sobre el cambio en los datos
  }
}
