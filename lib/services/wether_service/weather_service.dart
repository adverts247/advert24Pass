import 'dart:convert';

import 'package:adverts247Pass/state/location_weather_state.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future getWeatherData(context) async {
    var lon = Provider.of<WeatherLocationState>(context, listen: false).long;
    var lat = Provider.of<WeatherLocationState>(context, listen: false).lat;

    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=db56a9ab41e8ab1ab95dcffa4f67f119'));
    //'https://api.openweathermap.org/data/3.0/onecall?lat=${lat}&lon=${lon}&exclude={part}&appid=db56a9ab41e8ab1ab95dcffa4f67f119'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      Provider.of<WeatherLocationState>(context, listen: false)
          .weatherApiResult = data;
      // setState(() {
      //   temperature = (data['main']['temp'] - 273.15).toString() + '°C';
      //   humidity = data['main']['humidity'].toString() + '%';
      //   chanceOfRain = (data['clouds']['all'] / 100).toString();
      //   wind = data['wind']['speed'].toString() + 'm/s';
      // });
    } else {
      print(response.reasonPhrase);
      print('Failed to load data');
    }
  }
}
