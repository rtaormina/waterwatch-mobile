import 'package:flutter/material.dart';
import 'package:waterwatch/screens/home_widgets/location_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Watch'),
      ),
      body: Center(
        child: ListView(
          children: const [LocationSelector()],
        ),
      ),
    );
  }
}
