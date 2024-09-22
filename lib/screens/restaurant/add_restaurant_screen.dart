import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRestaurantScreen extends StatefulWidget {
  @override
  _AddRestaurantScreenState createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _restaurantName, _restaurantAddress;

  void _addRestaurant() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        await FirebaseFirestore.instance.collection('restaurants').add({
          'name': _restaurantName,
          'address': _restaurantAddress,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // Redirection ou confirmation
        print("Restaurant ajouté avec succès");
      } catch (e) {
        print("Erreur: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Restaurant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du restaurant'),
                validator: (value) => value?.isEmpty == true ? 'Veuillez entrer le nom du restaurant' : null,
                onSaved: (value) => _restaurantName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse du restaurant'),
                validator: (value) => value?.isEmpty == true ? 'Veuillez entrer l\'adresse du restaurant' : null,
                onSaved: (value) => _restaurantAddress = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addRestaurant,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
