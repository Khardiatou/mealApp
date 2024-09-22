import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpDeliveryScreen extends StatefulWidget {
  @override
  _SignUpDeliveryScreenState createState() => _SignUpDeliveryScreenState();
}

class _SignUpDeliveryScreenState extends State<SignUpDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String? _email, _password;

  void _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        // Si l'inscription est réussie, faites quelque chose, comme naviguer vers un autre écran
        print("Utilisateur créé: ${userCredential.user?.uid}");
      } catch (e) {
        // Gérez les erreurs
        print("Erreur: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription Livreur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value?.isEmpty == true ? 'Veuillez entrer votre email' : null,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mot de passe'),
                validator: (value) => value?.isEmpty == true ? 'Veuillez entrer votre mot de passe' : null,
                onSaved: (value) => _password = value,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
