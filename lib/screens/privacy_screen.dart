import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Politique de Confidentialité'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Ici, vous pouvez décrire en détail la politique de confidentialité de votre application...',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
