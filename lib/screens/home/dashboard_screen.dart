import 'package:flutter/material.dart';
import 'package:mealmagic/screens/profile/user_profile_screen.dart';
import 'package:mealmagic/screens/nos_services_screen.dart';
import 'package:mealmagic/screens/help_screen.dart';
import 'package:mealmagic/screens/terms_conditions_screen.dart';
import 'package:mealmagic/screens/cookies_screen.dart';
import 'package:mealmagic/screens/privacy_screen.dart';
import 'package:mealmagic/screens/restaurant/add_restaurant_screen.dart';
import 'package:mealmagic/screens/auth/sign_up_delivery_screen.dart';
import 'package:mealmagic/screens/auth/create_business_account_screen.dart';
import 'package:mealmagic/screens/checkout/basket_screen.dart';
import 'package:mealmagic/screens/profile/notification_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mealmagic/screens/profile/order_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:mealmagic/screens/profile/profile_screen.dart';

class StatCard extends StatelessWidget {
  final String number;
  final String label;

  const StatCard({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  Future<String> _createDynamicLink(String url) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://yourapp.page.link',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.example.yourapp',
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.example.yourapp',
        minimumVersion: '1.0.0',
        appStoreId: '123456789',
      ),
    );

    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortDynamicLink.shortUrl.toString();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final List<Map<String, String>> plats = [
    {
      'image': 'assets/images/telecharge_2.jpeg',
      'name': 'SPAGHETTI',
      'description':
          '1 kg de spaghetti, 100 g de concentré de tomate,\n2 c. à soupe d\'huile d\'olive,\nsel, poivre, 2 feuilles de laurier.',
      'price': '1,500 CFA'
    },
    {
      'image': 'assets/images/IMG-20240829-WA0017.jpg',
      'name': 'Salade ',
      'description': 'Salade fraîche avec une variété de légumes.',
      'price': '1,000 CFA'
    },
    {
      'image': 'assets/images/Le mafé be.jpg',
      'name': 'Mafé',
      'description': 'Plat traditionnel avec riz et sauce.',
      'price': '2,000 CFA'
    },
    {
      'image': 'assets/images/yaourt-of-fruit.jpg',
      'name': 'Dessert',
      'description': 'Dessert délicat pour terminer votre repas.',
      'price': '1,000 CFA'
    },
  ];

  final List<Map<String, String>> categories = [
    {
      'image': 'assets/images/IMG-20240829-WA0004.jpg',
      'name': 'Entrée',
    },
    {
      'image': 'assets/images/jus_fruit-removebg-preview.png',
      'name': 'Boisson',
    },
    {
      'image': 'assets/images/IMG-20240829-WA0009.jpg',
      'name': 'Repas',
    },
    {
      'image': 'assets/images/yaourt.png',
      'name': 'Dessert',
    },
  ];

  final Map<String, List<String>> categoryOptions = {
    'Entrée': ['Salade de légumes', 'Soupe de poisson'],
    'Boisson': [
      'Jus naturel: Bissap, tamarin, gingembre',
      'Jus de fruit: dafani, lemon',
      'Soda: Fanta, Coca, Sprite'
    ],
    'Repas': [
      'Poulet Yassa',
      'Foutou',
      'Thiéboudiène',
      'Ragoût de viande',
      'Mafé',
      'Spaghetti'
    ],
    'Dessert': ['Dégué', 'Yaourt', 'Salade de fruits'],
  };

  final List<Map<String, String>> restaurants = [
    {
      'logo': 'assets/images/RSN.png',
      'name': 'Restaurant Sénégalais Néné',
      'route': '/restaurantNene',
    },
    {
      'logo': 'assets/images/Reunion.png',
      'name': 'La Réunion',
      'route': '/restaurantReunion',
    },
    {
      'logo': 'assets/images/LDK.png',
      'name': 'Les Délices de Koudougou',
      'route': '/restaurantKoudougou',
    },
  ];

  void _showPlatDetails(BuildContext context, Map<String, String> plat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plat['name']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(plat['image']!, fit: BoxFit.cover),
            SizedBox(height: 30),
            Text(plat['description']!, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Prix: ${plat['price']}',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BasketScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/logo_mealmagic.png',
              height: 100,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.book),
              title: Text('Pages légales'),
              children: [
                ListTile(
                  title: Text('Termes et conditions'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TermsConditionsScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Confidentialité'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Cookies'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CookiesScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Nos Services'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NosServicesScreen()),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.link),
              title: Text('Liens importants'),
              children: [
                ListTile(
                  title: Text('Historique des Commandes'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderHistoryScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Commentaires'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Obtenir de l\'aide'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Ajoutez votre restaurant'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddRestaurantScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Inscrivez-vous pour livrer'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpDeliveryScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Créer un compte professionnel'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateBusinessAccountScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileSection(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 60.0, vertical: 30.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    height: 250.0, // Ajustez la hauteur selon vos besoins
                    child: Stack(
                      children: [
                        // Image d'arrière-plan
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/Capture d’écran 2024-07-28 020727.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Superposition d'un effet orange clair
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.withOpacity(0.5),
                                  Colors.transparent
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        // Texte au-dessus de l'image
                        Positioned(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Repas rapides et délicieux !',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(height: 60),
                              Text(
                                'Simplifiez votre vie, commandez vos repas préférés en un clin d\'œil avec MealMagic.',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
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
              // Section "Plat du jour"
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plats du jour Jusqu\'à -40% de réduction 🎉',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height:
                          250, // Hauteur réduite pour éviter les débordements
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: plats.length,
                        itemBuilder: (context, index) {
                          final plat = plats[index];
                          return GestureDetector(
                            onTap: () => _showPlatDetails(context, plat),
                            child: Container(
                              width: 250, // Largeur réduite pour les éléments
                              margin: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(plat['image']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                padding:
                                    EdgeInsets.all(20), // Ajuster les marges
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black54,
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      plat['name']!,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      plat['price']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Section "Catégories"
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catégories de commande',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height:
                          250, // Hauteur réduite pour éviter les débordements
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap: () {
                              final options = categoryOptions[category['name']];
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(category['name']!),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        category['image']!,
                                        width:
                                            100, // Largeur de l'image réduite
                                        height:
                                            100, // Hauteur de l'image réduite
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 30),
                                      if (options != null)
                                        ...options.map((option) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: Text(option,
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            )),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Fermer'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              width: 250, // Largeur réduite de l'item
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage(category['image']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                padding:
                                    EdgeInsets.all(8), // Ajuster les marges
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.black54,
                                ),
                                child: Center(
                                  child: Text(
                                    category['name']!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Section "Nos Partenaires"
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nos Partenaires',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, restaurant['route']!);
                            },
                            child: Container(
                              width: 260,
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage(restaurant['logo']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.black54,
                                ),
                                child: Center(
                                  child: Text(
                                    restaurant['name']!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// Section "Des commandes plus"
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Container with white background color
                    Container(
                      color: Color(0xFFF5F5F5), // Couleur blanc sale
                      padding: const EdgeInsets.all(
                          16.0), // Add some padding inside the container
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Des commandes plus',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.black, // Couleur noire pour le titre
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Personnalisées et immédiates',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                  0xFFED7014), // Couleur orange pour le sous-titre
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Téléchargez l\'application MealMagic pour des commandes rapides',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final link = await _createDynamicLink(
                                      'https://yourdomain.com/app_play');
                                  _launchURL(link);
                                },
                                child: Image.asset('assets/images/app_play.png',
                                    width: 150),
                              ),
                              SizedBox(width: 16),
                              InkWell(
                                onTap: () async {
                                  final link = await _createDynamicLink(
                                      'https://yourdomain.com/google_play');
                                  _launchURL(link);
                                },
                                child: Image.asset(
                                    'assets/images/google_play.png',
                                    width: 150),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Action du bouton
                                },
                                child: Image.asset(
                                  'assets/images/couple.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Gagnez plus avec des frais réduits\n Profitez d\'avantages exclusifs'",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 11, 11, 11),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 24),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Première Image - Inscrivez-vous en tant qu'entreprise et Partenariat avec nous
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddRestaurantScreen()),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/cuisiniere.jpeg',
                                fit: BoxFit.cover,
                                width: 550,
                                height: 300,
                              ),
                              Positioned(
                                top: 20,
                                child: Text(
                                  "Inscrivez-vous en tant qu'entreprise\net Partenariat avec nous",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 3,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddRestaurantScreen()),
                                    );
                                  },
                                  child: Text(
                                    "S'inscrire",
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold, // Texte en gras
                                      color:
                                          Colors.black, // Couleur du texte noir
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFED7014),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 24.0),
                                    shadowColor: Colors.black
                                        .withOpacity(0.5), // Couleur de l'ombre
                                    elevation:
                                        8, // Élévation pour l'effet de l'ombre
                                    side: BorderSide(
                                      color: Colors
                                          .white, // Couleur de la bordure blanche
                                      width: 2.0, // Largeur de la bordure
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Deuxième Image - Inscrivez-vous en tant que livreur et Roulez avec nous
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpDeliveryScreen()),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/LIVREUR.jpeg',
                                fit: BoxFit.cover,
                                width: 550,
                                height: 300,
                              ),
                              Positioned(
                                top: 30,
                                child: Text(
                                  "Inscrivez-vous en tant que livreur\net Roulez avec nous",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 3,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpDeliveryScreen()),
                                    );
                                  },
                                  child: Text(
                                    "S'inscrire",
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold, // Texte en gras
                                      color:
                                          Colors.black, // Couleur du texte noir
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFED7014),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 30.0),
                                    shadowColor: Colors.black
                                        .withOpacity(0.5), // Couleur de l'ombre
                                    elevation:
                                        10, // Élévation pour l'effet de l'ombre
                                    side: BorderSide(
                                      color: Colors
                                          .white, // Couleur de la bordure blanche
                                      width: 2.0, // Largeur de la bordure
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Action du bouton
                      },
                      child: Text("En savoir plus sur nous !"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFED7014), // Couleur orange
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "-Comment fonctionne MealMagic ?\n -Quels modes de paiement sont acceptés ?\n -Puis-je suivre ma commande en temps réel ?\n -Y a-t-il des promotions spéciales ?\n -MealMagic est-il disponible dans ma région ?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                child: Container(
                  color: Colors.black, // Fond noir pour la section entière
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Première étape : Passez une commande
                        Card(
                          color:
                              Color(0xFFEFEFEF), // Couleur de fond des cartes
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Passez une commande !',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Image.asset(
                                  'assets/images/icon com.jpg', // Remplacez par votre image
                                  height: 100,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Passez commande via\n notre site web ou notre \napplication mobile',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Deuxième étape : Suivre la progression
                        Card(
                          color: Color(0xFFEFEFEF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Suivre la progression',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Image.asset(
                                  'assets/images/icon plat.png', // Remplacez par votre image
                                  height: 100,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Vous pouvez suivre le statut\n de votre commande et\n le temps de livraison.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Troisième étape : Obtenez votre commande
                        Card(
                          color: Color(0xFFEFEFEF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Obtenez votre commande !',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Image.asset(
                                  'assets/images/icon reçu.png', // Remplacez par votre image
                                  height: 100,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Recevez votre commande\n à une vitesse éclair !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Texte descriptif en bas
                        Text(
                          'MealMagic simplifie le processus de commande de repas.\n Parcourez notre menu diversifié, sélectionnez \n vos plats préférés et passez à la caisse.\n Votre délicieux repas sera en route vers \nvotre porte en un rien de temps !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
// Section statistiques
              SizedBox(height: 20),
              Center(
                child: Container(
                  color: Colors.orange[100],
                  padding: EdgeInsets.symmetric(vertical: 60, horizontal: 100),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centre verticalement
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Centre horizontalement
                    children: [
                      StatCard(number: "300+", label: "Livreurs enregistrés"),
                      SizedBox(
                          height: 16), // Ajoute de l'espace entre les cartes
                      StatCard(number: "50,000+", label: "Commandes livrées"),
                      SizedBox(height: 16),
                      StatCard(
                          number: "150+", label: "Restaurants partenaires"),
                      SizedBox(height: 16),
                      StatCard(number: "1,200+", label: "Plats proposés"),
                    ],
                  ),
                ),
              ),

              // Footer
              SizedBox(height: 24),
              Container(
                color: const Color.fromARGB(255, 205, 194, 194),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "MealMagic",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 11, 11, 11),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final link = await _createDynamicLink(
                                'https://yourdomain.com/app_play');
                            _launchURL(link);
                          },
                          child: Image.asset('assets/images/app_play.png',
                              width: 150),
                        ),
                        SizedBox(width: 16),
                        GestureDetector(
                          onTap: () async {
                            final link = await _createDynamicLink(
                                'https://yourdomain.com/google_play');
                            _launchURL(link);
                          },
                          child: Image.asset('assets/images/google_play.png',
                              width: 150),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Société n° 123456-789, enregistrée auprès \n de la Chambre de Commerce de Koudougou.",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Recevez des offres exclusives par e-mail",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "votremail@gmail.com",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Action du bouton "S'abonner"
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Merci de vous être abonné!"),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
                          child: Text("S'abonner"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.orange, // Couleur de fond orange
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Bordures arrondies
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(height: 16),
                    Text(
                      "Suivez-nous sur nos réseaux sociaux pour plus d\'offres et d\'informations.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.facebook,
                              color: Colors.white),
                          onPressed: () {
                            _launchURL(
                                'https://www.facebook.com/YourPage'); // Remplacez par votre URL Facebook
                          },
                        ),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.twitter,
                              color: Colors.white),
                          onPressed: () {
                            _launchURL(
                                'https://www.twitter.com/YourPage'); // Remplacez par votre URL Twitter
                          },
                        ),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.instagram,
                              color: Colors.white),
                          onPressed: () {
                            _launchURL(
                                'https://www.instagram.com/YourPage'); // Remplacez par votre URL Instagram
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Merci de visiter MealMagic !",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Container(
                      color: Colors.black, // Fond noir
                      padding: EdgeInsets.all(
                          8), // Ajoute un peu de padding autour du texte
                      child: Text(
                        "© 2024 MealMagic. Tous droits réservés.",
                        style: TextStyle(
                          color: const Color.fromRGBO(
                              255, 252, 252, 0.537), // Couleur du texte
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
