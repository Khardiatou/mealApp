import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Connexion avec email et mot de passe
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Erreur lors de la connexion avec email et mot de passe : $e');
      return null;
    }
  }

  // Inscription avec email et mot de passe
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Erreur lors de l\'inscription avec email et mot de passe : $e');
      return null;
    }
  }

  // Connexion avec Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Erreur lors de la connexion avec Google : $e');
      return null;
    }
  }

  // Connexion avec Facebook
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success && result.accessToken != null) {
        final OAuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        final UserCredential userCredential = await _auth.signInWithCredential(facebookCredential);
        return userCredential.user;
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur lors de la connexion avec Facebook : $e');
      return null;
    }
  }

  // Méthode pour vérifier si un utilisateur existe déjà par email
  Future<bool> getUserByEmail(String email) async {
    try {
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        return true; // L'utilisateur existe déjà
      } else {
        return false; // L'utilisateur n'existe pas
      }
    } catch (e) {
      print('Erreur lors de la vérification de l\'utilisateur par email : $e');
      return false;
    }
  }
}
