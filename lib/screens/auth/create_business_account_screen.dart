import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateBusinessAccountScreen extends StatefulWidget {
  @override
  _CreateBusinessAccountScreenState createState() => _CreateBusinessAccountScreenState();
}

class _CreateBusinessAccountScreenState extends State<CreateBusinessAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _businessName = '';
  String _email = '';
  String _password = '';
  String _contactNumber = '';
  String _address = '';

  bool _isLoading = false;

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        // Create user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Save business details to Firestore
        await _firestore.collection('business_accounts').doc(userCredential.user!.uid).set({
          'businessName': _businessName,
          'email': _email,
          'contactNumber': _contactNumber,
          'address': _address,
          'createdAt': Timestamp.now(),
        });

        // Navigate to another screen (e.g., Dashboard) after successful registration
        Navigator.pushReplacementNamed(context, '/dashboard');
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e.message ?? 'An error occurred. Please try again.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte professionnel'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informations sur l\'entreprise',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom de l\'entreprise'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer le nom de l\'entreprise';
                  }
                  return null;
                },
                onSaved: (value) {
                  _businessName = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse e-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Veuillez entrer une adresse e-mail valide';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Le mot de passe doit comporter au moins 6 caractères';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactNumber = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer l\'adresse de l\'entreprise';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              SizedBox(height: 32),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
  onPressed: _createAccount,
  child: Text('Créer un compte'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange, // Correction ici
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
