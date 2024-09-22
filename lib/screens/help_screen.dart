import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aide'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Ici, vous pouvez fournir des informations d\'aide ou des FAQ pour vos utilisateurs...',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
