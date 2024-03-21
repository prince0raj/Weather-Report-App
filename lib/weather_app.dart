import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_information.dart';
import 'package:weather_app/hourupdates.dart';
import "package:http/http.dart" as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=8598e13dd8ea5768ded1c420bcc10bfa'));
      final data = jsonDecode(response.body);
      if (data['cod'] != '200') {
        throw 'an unexpected Error';
      }
      return data;
    } catch (e) {
      // ignore: avoid_print
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final heroweather = data['list'][0];
          final double temp = heroweather['main']['temp'];
          final String weatherType = heroweather['weather'][0]['main'];
          final int humidity = heroweather['main']['humidity'];
          final int pressure = heroweather['main']['pressure'];
          final double windSpeed = heroweather['wind']['speed'];
          final IconData icons;
          if (weatherType == "Clouds") {
            icons = Icons.cloud;
          } else if (weatherType == "Rain") {
            icons = Icons.sunny;
          } else {
            icons = Icons.water_damage;
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  '$temp K',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Icon(
                                  icons,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  weatherType,
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: data['cnt'],
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!;
                        final heroweather = data['list'][index + 1];
                        final double temp = heroweather['main']['temp'];
                        final IconData icons;
                        final String weatherType =
                            heroweather['weather'][0]['main'];
                        if (weatherType == "Clouds") {
                          icons = Icons.cloud;
                        } else if (weatherType == "Rain") {
                          icons = Icons.sunny;
                        } else {
                          icons = Icons.water_damage;
                        }
                        final dateTime = DateTime.parse(heroweather['dt_txt']);
                        final hourTime = DateFormat.jz().format(dateTime);
                        return HourForcast(
                          icons: icons,
                          time: hourTime,
                          temp: temp.toString(),
                        );
                      }),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Additional information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInfomation(
                      iconfav: Icons.water_drop,
                      value: humidity.toString(),
                      label: "humidity",
                    ),
                    AdditionalInfomation(
                      iconfav: Icons.air,
                      value: windSpeed.toString(),
                      label: "Wind Speed",
                    ),
                    AdditionalInfomation(
                      iconfav: Icons.beach_access,
                      value: pressure.toString(),
                      label: "Pressure",
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
