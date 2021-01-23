import 'package:dio/dio.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather/weather_model.dart';

class WeatherCotroller {
  get apiId => '0bdf5a69e08d6d6050a036249f824957';
  WeatherCotroller();
  Future<WeatherDetailsModel> getWeatherDetails() async {
    final city = await determinePosition();
    Response response = await Dio().get(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiId');
    final json = response.data;
    final weatherDetailsModel = WeatherDetailsModel.fromMap(json);
    return weatherDetailsModel;
  }

  Future<String> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    final position = await Geolocator.getCurrentPosition();
    final coordinates = new Coordinates(position.latitude, position.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    final first = addresses.first;

    return first.countryName;
  }
}
