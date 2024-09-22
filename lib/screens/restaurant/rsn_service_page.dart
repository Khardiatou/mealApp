import 'package:flutter/material.dart';

class ServiceScreen extends StatelessWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Nos Services'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
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
    );
  }
}
