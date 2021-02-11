import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cars.dart';
import './car_item.dart';

class CarsGrid extends StatelessWidget {
  final bool showFavs;

  CarsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final carsData = Provider.of<Cars>(context);
    final cars = showFavs ? carsData.favoriteItems : carsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: cars.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: cars[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
