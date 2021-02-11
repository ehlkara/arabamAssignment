import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cars.dart';

class CarDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/car-detail';

  @override
  Widget build(BuildContext context) {
    final carId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedCar = Provider.of<Cars>(
      context,
      listen: false,
    ).findById(carId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedCar.brand),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedCar.brand),
              background: Hero(
                tag: loadedCar.id,
                child: Image.network(
                  loadedCar.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '\$${loadedCar.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedCar.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
