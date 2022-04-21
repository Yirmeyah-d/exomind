import 'package:exomind/src/features/weather/domain/entities/coord.dart';

class CoordModel extends Coord {
  const CoordModel({
    required double lon,
    required double lat,
  }) : super(
          lon: lon,
          lat: lat,
        );

  factory CoordModel.fromJson(Map<String, dynamic> json) {
    return CoordModel(
      lon: json["lon"],
      lat: json["lat"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lon': lon,
      'lat': lat,
    };
  }
}
