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

  // Variables pour les erreurs spécifiques
  String? _emailError;
  String? _passwordError;

 Future<void> _signIn() async {
  setState(() {
    _emailError = null;
    _passwordError = null;
  });

  if (_formKey.currentState!.validate()) {
    try {
      print('Tentative de connexion avec l\'email : ${_emailController.text}');
      User? user = await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        print('Connexion réussie pour l\'utilisateur : ${user.email}');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        setState(() {
          _emailError = 'Email incorrect ou non enregistré';
          _passwordError = 'Mot de passe incorrect';
        });
      }
    } catch (e) {
      print('Erreur lors de la tentative de connexion : $e');
      if (e.toString().contains('wrong-password')) {
        setState(() {
          _passwordError = 'Mot de passe incorrect';
        });
      } else if (e.toString().contains('user-not-found')) {
        setState(() {
          _emailError = 'Email incorrect ou non enregistré';
        });
      } else {
        setState(() {
          _emailError = 'Erreur lors de la connexion';
          _passwordError = 'Erreur lors de la connexion';
        });
      }
    }
  }
}

  Future<void> _signInWithGoogle() async {
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        // Connexion réussie, redirection vers DashboardScreen
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      print('Erreur lors de la connexion avec Google: $e');
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      User? user = await _authService.signInWithFacebook();
      if (user != null) {
        // Connexion réussie, redirection vers DashboardScreen
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      print('Erreur lors de la connexion avec Facebook: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    errorText: _emailError,
                  ),
                  onChanged: (value) {
                    if (_emailError != null) {
                      setState(() {
                        _emailError = null;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(),
                    errorText: _passwordError,
                  ),
                  obscureText: _obscurePassword,
                  onChanged: (value) {
                    if (_passwordError != null) {
                      setState(() {
                        _passwordError = null;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    } else if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
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
                  onPressed: _signIn,
                  child: Text('SE CONNECTER'),
                ),
                SizedBox(height: 20),
                Center(child: Text('OU')),
                SizedBox(height: 20),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    side: BorderSide(color: Colors.black),
                  ),
                  icon: Icon(FontAwesomeIcons.google, color: Color(0xFFdb4437)),
                  label: Text('Continuer avec Google'),
                  onPressed: _signInWithGoogle,
                ),
                SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    side: BorderSide(color: Colors.black),
                  ),
                  icon: Icon(FontAwesomeIcons.facebook, color: Color(0xFF3b5998)),
                  label: Text('Continuer avec Facebook'),
                  onPressed: _signInWithFacebook,
                ),
                SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Pas encore inscrit ? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          "Créer un compte",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
