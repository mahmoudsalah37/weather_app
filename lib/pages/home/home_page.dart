import 'package:flutter/material.dart';
import 'package:weather_app/controllers/weather_contoller.dart';
import 'package:weather_app/models/weather/weather_model.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    final weatherCotroller = WeatherCotroller();

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<WeatherDetailsModel>(
          future: weatherCotroller.getWeatherDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return Column(
                children: [
                  Container(
                    height: screenSize.height / 3,
                    width: screenSize.width,
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Currently in ${data.name}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${data.main.tempMin} - ${data.main.tempMax}\u212A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${data.weather.first.description}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: [
                          ListTile(
                            leading: Icon(Icons.thermostat_rounded),
                            title: Text('Temprature'),
                            trailing: Text('${data.main.temp}\u212A'),
                          ),
                          ListTile(
                            leading: Icon(Icons.cloud),
                            title: Text('Weather'),
                            trailing: Text('${data.weather.first.main}'),
                          ),
                          ListTile(
                            leading: Icon(Icons.wb_sunny),
                            title: Text('TemperaHumidityture'),
                            trailing: Text('${data.main.humidity}%'),
                          ),
                          ListTile(
                            leading: Icon(Icons.wine_bar_outlined),
                            title: Text('Wind Speed'),
                            trailing: Text('${data.wind.speed}m/s'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error'));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
