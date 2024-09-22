import 'package:flutter/material.dart';

class RestaurantKoudougouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Les Délices de Koudougou'),
      ),
      body: Center(
        child: Text(
          'Bienvenue à Les Délices de Koudougou!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
