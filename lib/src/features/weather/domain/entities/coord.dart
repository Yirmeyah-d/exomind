import 'package:equatable/equatable.dart';

class Coord extends Equatable {
  final double lon;
  final double lat;

  const Coord({required this.lon, required this.lat});

  @override
  List<Object> get props => [
        lon,
        lat,
      ];
}
