import 'package:flutter/material.dart';

class CookiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Politique des cookies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Ici, vous pouvez décrire en détail la politique des cookies de votre application...',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
