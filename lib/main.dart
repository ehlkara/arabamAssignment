import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/cars_overview_screen.dart';
import './providers/auth.dart';
import './screens/car_detail_screen.dart';
import './providers/cars.dart';
import './screens/user_cars_screen.dart';
import './screens/edit_car_screen.dart';
import './screens/auth_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Cars>(
          create: null,
          update: (ctx, auth, previousCars) => Cars(
            auth.token,
            auth.userId,
            previousCars == null ? [] : previousCars.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Arabam.com',
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.yellow,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          home: auth.isAuth
              ? CarsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            CarDetailScreen.routeName: (ctx) => CarDetailScreen(),
            UserCarsScreen.routeName: (ctx) => UserCarsScreen(),
            EditCarScreen.routeName: (ctx) => EditCarScreen(),
          },
        ),
      ),
    );
  }
}
