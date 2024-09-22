import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    final String userName = user?.displayName ?? 'Utilisateur';
    final String userEmail = user?.email ?? 'email@exemple.com';
    final String userProfileImage = user?.photoURL ?? '';
    final String userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.orange, // Couleur de fond pour l'initiale
            child: userProfileImage.isEmpty
                ? Text(
                    userInitial,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
            backgroundImage: userProfileImage.isNotEmpty && userProfileImage.startsWith('http') 
                ? NetworkImage(userProfileImage)
                : userProfileImage.isNotEmpty
                    ? AssetImage(userProfileImage) as ImageProvider
                    : null,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,  // Affichage du vrai prénom de l'utilisateur
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Naviguer vers la page de compte
                },
                child: Text(
                  'Mon compte',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  '0 CFA', // Remplacez par le total du panier
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
