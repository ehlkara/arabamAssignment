import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cars.dart';
import '../widgets/user_car_item.dart';
import '../widgets/app_drawer.dart';
import './edit_car_screen.dart';

class UserCarsScreen extends StatelessWidget {
  static const routeName = '/user-cars';

  Future<void> _refreshCars(BuildContext context) async {
    await Provider.of<Cars>(context, listen: false).fetchAndSetCars(true);
  }

  @override
  Widget build(BuildContext context) {
    // final carsData = Provider.of<Cars>(context);
    print('rebuildings...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cars'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditCarScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshCars(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshCars(context),
                    child: Consumer<Cars>(
                      builder: (ctx, carsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: carsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserCarItem(
                                carsData.items[i].id,
                                carsData.items[i].brand,
                                carsData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
