import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/car_detail_screen.dart';
import '../providers/car.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<Car>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              CarDetailScreen.routeName,
              arguments: car.id,
            );
          },
          child: Hero(
            tag: car.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/car-placeholder.png'),
              image: NetworkImage(car.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Car>(
            builder: (ctx, car, _) => IconButton(
              icon: Icon(
                car.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                car.toggleFavoriteStatus(
                  authData.token,
                  authData.userId,
                );
              },
            ),
          ),
          title: Text(
            car.brand,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
