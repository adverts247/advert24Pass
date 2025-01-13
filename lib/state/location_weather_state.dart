import 'package:flutter/foundation.dart';

class WeatherLocationState extends ChangeNotifier {
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

  // Reset error state
  void clearError() {
    error = null;
    notifyListeners();
  }
}
