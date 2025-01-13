import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../state/location_weather_state.dart';

class WeatherService {
  Future<void> getWeatherData(BuildContext context) async {
    // Get the state
    final weatherState = Provider.of<WeatherLocationState>(context, listen: false);
    
    try {
      // Set loading state
      weatherState.isLoading = true;
      weatherState.clearError();
      weatherState.notifyListeners();

      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${weatherState.lat}&lon=${weatherState.long}&appid=db56a9ab41e8ab1ab95dcffa4f67f119'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print("Weather data:: $data");
        }
        weatherState.setWeatherData(data as Map<String, dynamic>);
      } else {
        weatherState.error = 'Failed to load weather data: ${response.reasonPhrase}';
        print(weatherState.error);
      }
    } catch (e) {
      weatherState.error = 'Error fetching weather data: $e';
      print(weatherState.error);
    } finally {
      weatherState.isLoading = false;
      weatherState.notifyListeners();
    }
  }
}
