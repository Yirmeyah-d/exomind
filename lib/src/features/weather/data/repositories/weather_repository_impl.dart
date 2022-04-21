import 'package:fpdart/fpdart.dart';
import 'package:exomind/src/features/weather/data/data_sources/weather_local_data_source.dart';
import 'package:exomind/src/features/weather/data/data_sources/weather_remote_data_source.dart';
import 'package:exomind/src/features/weather/domain/entities/current_weather_data.dart';
import 'package:exomind/src/features/weather/domain/repositories/weather_repository.dart';
import 'package:exomind/src/core/error/exceptions.dart';
import 'package:exomind/src/core/error/failures.dart';
import 'package:exomind/src/core/network/network_info.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CurrentWeatherData>> getCurrentWeatherData(
      String city) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCurrentWeatherData =
            await remoteDataSource.getCurrentWeatherData(city);
        localDataSource.cacheCurrentWeatherData(remoteCurrentWeatherData);
        return Right(remoteCurrentWeatherData);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localCurrentWeatherData =
            await localDataSource.getLastCurrentWeatherData();
        return Right(localCurrentWeatherData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
