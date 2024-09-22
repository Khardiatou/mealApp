import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termes et Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Ici, vous pouvez décrire en détail les termes et conditions d\'utilisation de votre application...',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
