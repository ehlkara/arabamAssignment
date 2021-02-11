import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './car.dart';

class Cars with ChangeNotifier {
  List<Car> _items = [
    // Car(
    //   id: 'p1',
    //   brand: 'BMW 320d',
    //   description: 'It is amazing car!',
    //   price: 440.999,
    //   imageUrl:
    //       'https://www.bmw.com.tr/content/dam/bmw/common/all-models/3-series/sedan/2018/inform/bmw-3series-3er-inform-lines-02-01.jpg',
    // ),
    // Car(
    //   id: 'p2',
    //   brand: 'Mercedes C200',
    //   description: 'A mercedes car is wonderful!',
    //   price: 610.990,
    //   imageUrl:
    //       'https://www.mercedes-benz.com.au/passengercars/_jcr_content/image.MQ6.2.2x.20200812074529.png',
    // ),
    // Car(
    //   id: 'p3',
    //   brand: 'Audi A5',
    //   description: 'The Audi family continues to be renewed.',
    //   price: 750.990,
    //   imageUrl:
    //       'https://www.dogusoto.com.tr/Dosyalar/Model/Audi/galeri%20g%C3%B6rselleri/a5%20sportback/yeni/media-center-a5-sportback-2.jpg',
    // ),
    // Car(
    //   id: 'p4',
    //   brand: 'Honda Civic',
    //   description:
    //       'The Orange Edition and Black Pack enhance the visual appeal of the new Civic.',
    //   price: 300.000,
    //   imageUrl:
    //       'https://gaadiwaadi.com/wp-content/uploads/2017/05/Honda-Civic-Black-Pack-2.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Cars(this.authToken, this.userId, this._items);

  List<Car> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((crItem) => crItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Car> get favoriteItems {
    return _items.where((crItem) => crItem.isFavorite).toList();
  }

  Car findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetCars([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://arabam-com-default-rtdb.firebaseio.com/cars.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://arabam-com-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Car> loadedCar = [];
      extractedData.forEach((crId, crData) {
        loadedCar.add(Car(
          id: crId,
          brand: crData['brand'],
          description: crData['description'],
          price: crData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[crId] ?? false,
          imageUrl: crData['imageUrl'],
        ));
      });
      _items = loadedCar;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCar(Car car) async {
    final url =
        'https://arabam-com-default-rtdb.firebaseio.com/cars.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'brand': car.brand,
          'description': car.description,
          'imageUrl': car.imageUrl,
          'price': car.price,
          'creatorId': userId,
        }),
      );
      final newCar = Car(
        brand: car.brand,
        description: car.description,
        price: car.price,
        imageUrl: car.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newCar);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCar(String id, Car newCar) async {
    final crIndex = _items.indexWhere((cr) => cr.id == id);
    if (crIndex >= 0) {
      final url =
          'https://arabam-com-default-rtdb.firebaseio.com/cars/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'brand': newCar.brand,
            'description': newCar.description,
            'imageUrl': newCar.imageUrl,
            'price': newCar.price,
          }));
      _items[crIndex] = newCar;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteCar(String id) async {
    final url =
        'https://arabam-com-default-rtdb.firebaseio.com/cars/$id.json?auth=$authToken';
    final existingCarIndex = _items.indexWhere((cr) => cr.id == id);
    var existingCar = _items[existingCarIndex];
    _items.removeAt(existingCarIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingCarIndex, existingCar);
      notifyListeners();
      throw HttpException('Could not delete car.');
    }
    existingCar = null;
  }
}
