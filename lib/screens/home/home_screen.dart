import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<String> imageUrls = [
    "assets/images/yassa_poulet.jpg",
    "assets/images/image_home_1.jpg",
    "assets/images/image_home_2.jpg",
    "assets/images/image_home_3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFA500), // Couleur de fond orange
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image du logo MealMagic
            Image.asset(
              'assets/images/logo_MealMagic.png', // Assurez-vous de mettre le bon chemin du logo ici
              width: 200, // Ajustez la taille de l'image du logo selon vos besoins
            ),
            SizedBox(height: 20),
            // Carrousel d'images des plats
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 4),
                enlargeCenterPage: true,
                reverse: true, // Défiler de droite à gauche
                viewportFraction: 0.8,
                aspectRatio: 16 / 9,
                initialPage: 0,
              ),
              items: imageUrls.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 40), // Espace ajouté entre le carrousel et le texte
            // Texte sous l'image
            Text(
              'Trouvez vos meilleurs Plats !!!',
              style: TextStyle(
                fontFamily: 'Times New Roman', // Assurez-vous que cette police est disponible
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50), // Espace ajouté entre le texte et les boutons
            // Bouton Se connecter
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              child: Text('Se connecter'),
            ),
            SizedBox(height: 10),
            // Bouton Créer un compte
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              child: Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
