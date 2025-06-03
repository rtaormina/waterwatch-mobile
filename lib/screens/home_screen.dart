import 'package:flutter/material.dart';
import 'package:waterwatch/screens/home_widgets/clear_button.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';
import 'package:waterwatch/screens/home_widgets/metrics/temperature_input.dart';
import 'package:waterwatch/screens/home_widgets/metrics_selector.dart';
import 'package:waterwatch/screens/home_widgets/submit_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'WATERWATCH',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        body: Center(
          child: ListView(
            children: const [
              LocationSelector(),
              MetricsSelector(),
              TemperatureInput(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [ClearButton(), SubmitButton()],
              )
            ],
          ),
        ),
      ),
    );
  }
}
