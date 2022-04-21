import 'package:flutter/material.dart';

import '../../domain/entities/current_weather_data.dart';

class CardCarouselComponent extends StatelessWidget {
  final List<CurrentWeatherData> cardsContent;
  final pictogram = {
    'Clear': 'assets/images/clear-sky.jpeg',
    'Clouds': 'assets/images/clouds.jpeg',
    'Rain': 'assets/images/rain-cloud.png',
    'Thunderstorm': 'assets/images/thunder.jpeg',
    'Mist': 'assets/images/mist.png',
    'Drizzle': 'assets/images/rain-cloud.png',
  };
  CardCarouselComponent({
    required this.cardsContent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const VerticalDivider(
          color: Colors.transparent,
          width: 5,
        ),
        itemCount: cardsContent.length,
        itemBuilder: (context, index) {
          CurrentWeatherData? data;
          (cardsContent.isNotEmpty) ? data = cardsContent[index] : data = null;
          return SizedBox(
            width: 140,
            height: 150,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (data != null) ? data.name : '',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                          fontFamily: 'flutterfonts',
                        ),
                  ),
                  Text(
                    (data != null)
                        ? '${(data.main.temp - 273.15).round().toString()}\u2103'
                        : '',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                          fontFamily: 'flutterfonts',
                        ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(pictogram[data?.weather[0].main]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    (data != null) ? data.weather[0].description : '',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Colors.black45,
                          fontFamily: 'flutterfonts',
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
