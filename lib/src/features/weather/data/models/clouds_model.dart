import 'package:exomind/src/features/weather/domain/entities/clouds.dart';

class CloudsModel extends Clouds {
  const CloudsModel({required int all}) : super(all: all);

  factory CloudsModel.fromJson(Map<String, dynamic> json) {
    return CloudsModel(
      all: json["all"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'all': all,
    };
  }
}
