import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealmagic/screens/checkout/basket_screen.dart';
import 'package:mealmagic/screens/restaurant/rsn_menu_page.dart';
import 'package:mealmagic/screens/restaurant/rsn_information.dart';
import 'package:mealmagic/screens/restaurant/RSN_reviews_screen.dart';

class RestaurantNene extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Livraison rapide',
      'description': 'Recevez votre commande en moins de 30 minutes.',
      'icon': Icons.local_shipping, // Alternative pour delivery_dining
    },
    {
      'title': 'Commande en ligne',
      'description': 'Commandez et payez directement depuis votre mobile.',
      'icon': Icons.shopping_cart, // Shopping cart icon
    },
    {
      'title': 'Cuisine saine',
      'description': 'Des plats cuisinés avec des ingrédients frais et sains.',
      'icon': Icons.restaurant_menu, // Alternative pour health_and_safety
    },
    {
      'title': 'Service client',
      'description': 'Un support client disponible 24/7 pour répondre à vos besoins.',
      'icon': Icons.support, // Alternative pour support_agent
    },
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName ?? 'Invité';
    final String userProfileImage = user?.photoURL ?? 'assets/images/default_profile.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Sénégalais Néné'),
        backgroundColor: Colors.orange,
        centerTitle: true, // Pour centrer le titre
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BasketScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Profil Utilisateur
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: userProfileImage.startsWith('http')
                        ? NetworkImage(userProfileImage)
                        : AssetImage(userProfileImage) as ImageProvider,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenue, $userName',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
            // Image de Bannière
            Container(
  padding: const EdgeInsets.all(10.0), // Cadre global autour du conteneur
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.orange,
      width: 0.0, // Diminuer la largeur de la bordure externe
    ),
    borderRadius: BorderRadius.circular(8.0),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center, // Pour espacer uniformément les images
    children: [
      // Image à gauche
      Container(
        width: 250, // Taille ajustée pour permettre trois images
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0, // Pas de bordure supplémentaire
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/thièb_home.jpeg',
            fit: BoxFit.cover, // Adapter l'image au cadre
          ),
        ),
      ),
      // Image au centre
      Container(
        width: 300, // Même taille que les autres
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
           'assets/images/RSN.png', // Remplacer par l'image souhaitée
            fit: BoxFit.cover,
          ),
        ),
      ),
      // Image à droite
      Container(
        width: 250,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/thièb_home.jpeg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  ),
),

            // Boutons de Navigation
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavigationButton(
                    context,
                    'Menu',
                    Icons.restaurant_menu,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuScreen()),
                      );
                    },
                  ),
                  _buildNavigationButton(
                    context,
                    'Informations',
                    Icons.info,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RsnInfoScreen()),
                      );
                    },
                  ),
                  _buildNavigationButton(
                    context,
                    'Avis',
                    Icons.star,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RSNReviewsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Section Service du Restaurant (nouvelle section)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nos Services',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true, // To prevent ListView from occupying infinite height
                    physics: NeverScrollableScrollPhysics(), // Disable scrolling for ListView inside SingleChildScrollView
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(service['icon'], color: Colors.orange, size: 40),
                          title: Text(service['title'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          subtitle: Text(service['description']),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Aperçu du Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aperçu du Menu',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildMenuPreview(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMenuPreview() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('menu').limit(4).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        var menuItems = snapshot.data!.docs;

        return Column(
          children: menuItems.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: Image.network(data['image'], width: 50, height: 50, fit: BoxFit.cover),
              title: Text(data['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text('${data['price']} CFA'),
            );
          }).toList(),
        );
      },
    );
  }
}
