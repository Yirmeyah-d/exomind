import 'package:exomind/src/core/views/home_view.dart';
import 'package:exomind/src/features/weather/presentation/views/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../injection_container.dart';
import 'core/styles/colors.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/views/settings_view.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiBlocProvider(
        providers: [
          BlocProvider<WeatherBloc>(
              create: (_) => serviceLocator<WeatherBloc>()),
          BlocProvider<SettingsBloc>(
              create: (_) => serviceLocator<SettingsBloc>()
                ..add(
                  const SettingsLoaded(),
                )),
        ],
        child:
            BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme:
                ThemeData(fontFamily: 'Circular', primaryColor: kPrimaryColor),
            darkTheme: ThemeData.dark(),
            themeMode: state.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return const SettingsView();
                    case WeatherView.routeName:
                      return const WeatherView();
                    case HomeView.routeName:
                      return const HomeView();
                    default:
                      return const HomeView();
                  }
                },
              );
            },
          );
        }));
  }
}
