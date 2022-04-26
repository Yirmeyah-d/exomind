import 'package:exomind/src/features/settings/presentation/views/settings_view.dart';
import 'package:exomind/src/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:exomind/src/features/weather/presentation/components/card_carousel_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({Key? key}) : super(key: key);
  static const routeName = '/weather';

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView>
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(SettingsView.routeName);
              },
            ),
          ),
        ],
        elevation: 0,
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
        if (state is WeatherLoading) {
          return Stack(
            children: [
              Center(
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(rotationController),
                  child: Icon(
                    Icons.wb_sunny,
                    color: Colors.yellow,
                    size: (width * 0.2),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: height * 0.15),
                  child: Text(state.loadingMessage),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  bottom: height * 0.10,
                ),
                child: Stack(
                  children: <Widget>[
                    // Je pourrais refactoriser ça en tant que component mais afin d'aller plus vite je ne l'ai pas fait.
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 300,
                        height: 20,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: state.percent.toDouble() / 100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue[400]!),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: Text(
                        state.percent.toString() + "%",
                        style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (state is WeatherLoaded) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(rotationController),
                  child: Icon(
                    Icons.wb_sunny,
                    color: Colors.yellow,
                    size: (width * 0.2),
                  ),
                ),
              ),
              Center(
                child: CardCarouselComponent(
                  cardsContent: state.currentWeatherDataList,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                      bottom: height * 0.10,
                    ),
                    child: ElevatedButton(
                      child: const Text("Recommencer"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[400]),
                      ),
                      onPressed: () {
                        BlocProvider.of<WeatherBloc>(context)
                            .add(GetCurrentWeather());
                      },
                    )),
              ),
            ],
          );
        } else if (state is WeatherError) {
          // Je pourrais faire un component dédier à l'affichage du message d'erreur mais afin d'aller plus vite je ne l'ai pas fait.
          return Center(child: Text(state.message));
        } else {
          BlocProvider.of<WeatherBloc>(context).add(GetCurrentWeather());
          return Stack(
            children: [
              Center(
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(rotationController),
                  child: Icon(
                    Icons.wb_sunny,
                    color: Colors.yellow,
                    size: (width * 0.2),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: height * 0.15),
                  child: const Text("Nous téléchargeons les données…"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  bottom: height * 0.10,
                ),
                child: Stack(
                  children: <Widget>[
                    // Je pourrais refactoriser ça en tant que component mais afin d'aller plus vite je ne l'ai pas fait.
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 300,
                        height: 20,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: 0.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue[400]!),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      child: Text(
                        "0%",
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
