import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Map<String, String> restaurant;

  RestaurantDetailScreen({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['name'] ?? 'Restaurant Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(restaurant['logo'] ?? ''),
            SizedBox(height: 20),
            Text(
              restaurant['name'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Ajoutez plus de détails ici selon vos besoins
          ],
        ),
      ),
    );
  }
}
