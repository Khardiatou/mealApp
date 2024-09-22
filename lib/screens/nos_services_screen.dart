import 'package:flutter/material.dart';

class NosServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nos Services'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Découvrez nos services',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 20),
            _buildServiceSection(
              context,
              icon: Icons.fastfood,
              title: 'Livraison de Repas',
              description:
                  'Nous vous offrons une large gamme de plats livrés directement chez vous, rapidement et en toute sécurité.',
            ),
            _buildServiceSection(
              context,
              icon: Icons.restaurant,
              title: 'Réservation de Restaurant',
              description:
                  'Réservez facilement une table dans votre restaurant préféré directement depuis notre application.',
            ),
            _buildServiceSection(
              context,
              icon: Icons.local_offer,
              title: 'Offres Spéciales',
              description:
                  'Profitez de réductions exclusives et d\'offres spéciales sur vos commandes de repas.',
            ),
            _buildServiceSection(
              context,
              icon: Icons.delivery_dining,
              title: 'Inscription pour la Livraison',
              description:
                  'Vous voulez rejoindre notre équipe de livreurs ? Inscrivez-vous pour commencer à livrer dès aujourd\'hui.',
              onTap: () {
                // Redirection vers l'écran d'inscription pour les livreurs
                Navigator.pushNamed(context, '/signUpDelivery');
              },
            ),
            _buildServiceSection(
              context,
              icon: Icons.add_business,
              title: 'Ajoutez votre Restaurant',
              description:
                  'Augmentez votre visibilité en ajoutant votre restaurant sur notre plateforme.',
              onTap: () {
                // Redirection vers l'écran d'ajout de restaurant
                Navigator.pushNamed(context, '/addRestaurant');
              },
            ),
            _buildServiceSection(
              context,
              icon: Icons.support_agent,
              title: 'Support Client',
              description:
                  'Besoin d\'aide ? Notre équipe de support est là pour vous assister à tout moment.',
              onTap: () {
                // Redirection vers l'écran d'aide
                Navigator.pushNamed(context, '/help');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.orange),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
