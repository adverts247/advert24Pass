import 'package:adverts247Pass/model/api_response.dart';
import 'package:adverts247Pass/services/wether_service/weather_service.dart';
import 'package:flutter/foundation.dart';

class WeatherLocationState extends ChangeNotifier {
  late final WeatherService _weatherService;
  WeatherLocationState() {
    _weatherService = WeatherService();
  }
  dynamic _weatherApiResult;
  String? long = '3.406448';
  String? lat = '6.465422';
  bool isLoading = false;
  String? error;

  // Getter for weather data
  Map<String, dynamic>? get weatherApiResult => _weatherApiResult;

  // Setter for weather data
  void setWeatherData(Map<String, dynamic> data) {
    _weatherApiResult = data;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  //Reset error state
  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<APIResponse> getWeather() async {
    try {
      setLoading(true);
      final response = await _weatherService.getWeather(lat: lat, long: long);
      setWeatherData(response.data["data"]);
      setLoading(false);
      return response;
    } catch (e) {
      error = e.toString();
      return APIResponse(error: true, message: e.toString());
    }
  }
}
