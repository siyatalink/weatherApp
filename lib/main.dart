import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'weather_service.dart';
import 'weather.dart';
import 'package:lottie/lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  Weather? _weather;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default weather on app launch
    _weather = Weather(
      description: 'Default Weather',
      icon: 'default_icon', // Placeholder icon, update as needed
      temperature: 20.0, // Default temperature
    );
  }

  void _getWeather() async {
    WeatherService service = WeatherService();
    Weather? fetchedWeather = await service.getWeather(_controller.text);
    setState(() {
      _weather = fetchedWeather;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.lightBlue[200]!,
              Colors.blue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          hintText: 'Enter city name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _getWeather,
                        child: Text('Get Weather'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_weather!.temperature}°C',
                              style: TextStyle(
                                  fontSize: 60, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _weather!.description,
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _getWeatherAnimation(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWeatherAnimation() {
    String animationPath;
    if (_weather!.description == 'Default Weather') {
      animationPath = 'assets/default.json'; // Show default animation
    } else {
      switch (_weather!.description.toLowerCase()) {
        case 'clear sky':
          animationPath = 'assets/sunny.json';
          break;
        case 'few clouds':
        case 'scattered clouds':
        case 'broken clouds':
          animationPath = 'assets/cloudy.json';
          break;
        case 'rain':
        case 'light rain':
          animationPath = 'assets/rainy.json';
          break;
        default:
          animationPath = 'assets/default.json'; // Fallback animation
          break;
      }
    }
    return Lottie.asset(animationPath, height: 150);
  }
}
