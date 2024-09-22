import 'package:flutter/material.dart';

class RestaurantReunionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('La Réunion'),
      ),
      body: Center(
        child: Text(
          'Bienvenue à La Réunion!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
