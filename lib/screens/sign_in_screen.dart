import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealmagic/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

Future<void> _signIn() async {
  if (_formKey.currentState!.validate()) {
    try {
      User? user = await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        Navigator.pushNamed(context, '/dashboard');
      } else {
        _showSnackbar('Email ou mot de passe incorrect');
      }
    } catch (e) {
      _showSnackbar('Erreur: ${e.toString()}');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'MON COMPTE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Logique pour mot de passe oublié
                      Navigator.pushNamed(context, '/reset-password');
                    },
                    child: Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: _signIn, // Appel de la méthode _signIn
                  child: Text('SE CONNECTER'),
                ),
                SizedBox(height: 20),
                Center(child: Text('OU')),
                SizedBox(height: 20),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.black),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.google,
                    color: Color(0xFFdb4437),
                  ),
                  label: Text('Se connecter avec Google'),
                  onPressed: () async {
                    User? user = await _authService.signInWithGoogle();
                    if (user != null) {
                      Navigator.pushNamed(context, '/dashboard');
                    } else {
                      _showSnackbar('Échec de la connexion avec Google');
                    }
                  },
                ),
                SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.black),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.facebook,
                    color: Color(0xFF3b5998),
                  ),
                  label: Text('Se connecter avec Facebook'),
                  onPressed: () async {
                    User? user = await _authService.signInWithFacebook();
                    if (user != null) {
                      Navigator.pushNamed(context, '/dashboard');
                    } else {
                      _showSnackbar('Échec de la connexion avec Facebook');
                    }
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: Text("Pas encore inscrit ?"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
