import 'package:exomind/src/features/weather/domain/entities/wind.dart';

class WindModel extends Wind {
  const WindModel({
    required double speed,
    required int deg,
  }) : super(
          speed: speed,
          deg: deg,
        );

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      speed: json["speed"].toDouble(),
      deg: json["deg"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'deg': deg,
    };
  }
}
