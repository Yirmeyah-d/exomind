import 'package:flutter/material.dart';

import '../../features/weather/presentation/views/weather_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController rotationController;

  @override
  void initState() {
    rotationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/images/cloud-in-blue-sky.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: (height / 2) - 100,
            child: Text(
              "Weather",
              style:
                  TextStyle(fontFamily: 'Billabong', fontSize: (width * 0.2)),
            ),
          ),
          Positioned(
            top: (height / 2),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
              child: IconButton(
                icon: const Icon(Icons.wb_sunny),
                color: Colors.yellow,
                iconSize: (width * 0.2),
                onPressed: () {
                  Navigator.of(context).pushNamed(WeatherView.routeName);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
