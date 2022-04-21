import 'package:exomind/src/features/weather/domain/entities/sys.dart';

class SysModel extends Sys {
  const SysModel({
    required int type,
    required int id,
    required String country,
    required int sunrise,
    required int sunset,
  }) : super(
          type: type,
          id: id,
          country: country,
          sunrise: sunrise,
          sunset: sunset,
        );

  factory SysModel.fromJson(Map<String, dynamic> json) {
    return SysModel(
      type: json['type'],
      id: json['id'],
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'country': country,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }
}
