import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealmagic/screens/checkout/basket_screen.dart';

// Déclaration de la clé scaffoldMessengerKey
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MenuScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Petit Déjeuner',
      'items': [
        {
          'name': 'Pain',
          'price': 500,
          'image': 'assets/images/pain.png',
          'options': [
            'Pain avec Viande hachée',
            'Pain avec Gésier',
            'Pain avec Foie',
            'Pain avec Sardine'
          ],
        },
        {'name': 'Café', 'price': 100, 'image': 'assets/images/café.jpeg'},
        {'name': 'Lipton', 'price': 100, 'image': 'assets/images/lipton.jpeg'},
      ],
    },
    {
      'name': 'Repas',
      'items': [
        {
          'name': 'Thiéboudiène (riz gras)',
          'price': 800,
          'image': 'assets/images/IMG-20240829-WA0016.jpg',
          'vegetables': ['Choux', 'Carotte', 'Aubergine', 'Piment', 'Citron'],
          'meatOptions': [
            {'name': 'Viande', 'price': 1000},
            {'name': '1/2 Poisson', 'price': 1500},
            {'name': '1/4 Poulet', 'price': 1250},
          ],
        },
        {
          'name': 'Poulet Yassa',
          'price': 2000,
          'image': 'assets/images/yassa_poulet.jpg',
          'meatOptions': [
            {'name': 'Viande', 'price': 1000},
            {'name': '1/2 Poisson', 'price': 1500},
            {'name': '1/4 Poulet', 'price': 1250},
          ],
        },
     {
          'name': 'Mafé (riz arachide)',
          'price': 800,
          'image': 'assets/images/mafé.jpeg',
          'vegetables': ['Choux', 'Carotte', 'Aubergine', 'Piment', 'Citron'],
          'meatOptions': [
            {'name': 'Viande', 'price': 1000},
            {'name': '1/2 Poisson', 'price': 1500},
            {'name': '1/4 Poulet', 'price': 1250},
          ],
        },
        {
          'name': 'Soupe Kandia (riz sauce gombo)',
          'price': 800,
          'image': 'assets/images/soupe kandia.jpg',
          'vegetables': ['Choux', 'Carotte', 'Aubergine', 'Piment', 'Citron'],
          'meatOptions': [
            {'name': 'Viande', 'price': 1000},
            {'name': '1/2 Poisson', 'price': 1500},
            {'name': '1/4 Poulet', 'price': 1250},
          ],
        },
        {
          'name': 'Riz avec sauce feuille',
          'price': 800,
          'image': 'assets/images/riz_aubergine.jpeg',
          'meatOptions': [
            {'name': 'Viande', 'price': 1000},
            {'name': '1/2 Poisson', 'price': 1500},
            {'name': '1/4 Poulet', 'price': 1250},
          ],
        },
        {'name': 'Soupe de Viande', 'price': 1250, 'image': 'assets/images/soupe.jpg',  'meatOptions': [
            {'name': 'Viande', 'price': 1000},
          ],},
        {'name': 'Soupe de Poulet', 'price': 1500, 'image': 'assets/images/soupe_poulet.jpeg',  'meatOptions': [
            {'name': '1/4 Poulet', 'price': 1250},
          ],},
        {'name': 'To avec sauce Gombo', 'price': 600, 'image': 'assets/images/Tot-à-la-sauce-gombo.jpg', 'meatOptions': [
            {'name': 'Viande', 'price': 1000},
            {'name': '1/2 Poisson', 'price': 1500},
            {'name': '1/4 Poulet', 'price': 1250},
          ],},
        {'name': 'To avec sauce Oseille', 'price': 600, 'image': 'assets/images/oseille.jpeg',  'meatOptions': [
            {'name': 'Viande', 'price': 1000},
            {'name': '1/2 Poisson', 'price': 1500},
            {'name': '1/4 Poulet', 'price': 1250},
          ],},
        {'name': 'To avec sauce Feuille', 'price': 700, 'image': 'assets/images/aubergine.png',  'meatOptions': [
            {'name': 'Viande', 'price': 1000},
            {'name': '1/2 Poisson', 'price': 1500},
            {'name': '1/4 Poulet', 'price': 1250},
          ],},
      ],
    },
    {
      'name': 'Boisson',
      'items': [
        {
          'name': 'Bissap',
          'price': 600,
          'image': 'assets/images/bissap-removebg-preview.png'
        },
        {
          'name': 'Tamarin',
          'price': 600,
          'image': 'assets/images/tamarinpng-removebg-preview.png'
        },
        {
          'name': 'Gingembre',
          'price': 600,
          'image': 'assets/images/jus-de-gingembre-removebg-preview.png'
        },
        {
          'name': 'Dafani',
          'price': 1100,
          'image': 'assets/images/cocktails-removebg-preview.png'
        },
        {'name': 'Fanta', 'price': 500, 'image': 'assets/images/fanta.jpeg'},
        {'name': 'Coca', 'price': 500, 'image': 'assets/images/coca.png'},
        {'name': 'Sprite', 'price': 500, 'image': 'assets/images/sprite.jpg'},
      ],
    },
    {
      'name': 'Dessert',
      'items': [
        {'name': 'Yaourt', 'price': 500, 'image': 'assets/images/yaourt.png'},
        {'name': 'Dégué', 'price': 500, 'image': 'assets/images/dégué.jpg'},
        {
          'name': 'Salade de fruits',
          'price': 1000,
          'image': 'assets/images/yaourt-of-fruit.jpg'
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu du Restaurant'),
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: categories.map((category) {
              return _buildCategory(context, category);
            }).toList(),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BasketScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.0),
              minimumSize: Size(double.infinity, 30),
            ),
            child: Text(
              'Voir Panier',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(BuildContext context, Map<String, dynamic> category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category['name'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: category['items'].map<Widget>((item) {
              return _buildMenuItem(context, item, category['name']);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, Map<String, dynamic> item, String categoryName) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            item['image'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item['name'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('${item['price']} CFA'),
        trailing: ElevatedButton(
          onPressed: () {
            if (categoryName == 'Repas') {
              _showCustomizationDialog(context, item);
            } else if (item.containsKey('options')) {
              _showBreadOptionsDialog(context, item);
            } else {
              _addToCart(context, item);
            }
          },
          child: Text('Ajouter au Panier',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context, Map<String, dynamic> item,
      [String? option,
      int quantity = 1,
      List<String>? selectedVegetables,
      Map<String, dynamic>? selectedMeat]) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
     // Créer un objet pour l'article du panier avec les informations nécessaires
final cartItem = {
  'name': item['name'] + (option != null ? ' ($option)' : ''), // Ajoute l'option au nom (ex: Pain (Pain avec Gésier))
  'basePrice': item['price'], // Stocker le prix de base
  'quantity': quantity, // Quantité sélectionnée
  'option': option, // Option spécifique pour "Pain" ou autres
  'vegetables': selectedVegetables, // Enregistrer les légumes sélectionnés (si disponibles)
  'meat': selectedMeat, // Enregistrer les options de viande/poisson (si disponibles)
  'optionPrice': selectedMeat != null ? selectedMeat['price'] : 0, // Ajouter le prix de l'option viande/poisson si présente
  'total': (item['price'] + (selectedMeat != null ? selectedMeat['price'] : 0)) * quantity, // Calculer le prix total
};

// Ajouter l'article dans Firestore sous l'utilisateur actuel
await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('cart')
    .add(cartItem);

// Afficher un message de confirmation
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('${item['name']} avec l\'option ${option ?? "aucune"} a été ajouté au panier.'),
    backgroundColor: Colors.green,
  ),
);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez vous connecter pour ajouter des articles.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fenêtre modale pour personnaliser le pain
  void _showBreadOptionsDialog(
      BuildContext context, Map<String, dynamic> item) {
    int quantity = 1;
    String? selectedOption;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Choisissez une option pour ${item['name']}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: item['options'].map<Widget>((option) {
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: selectedOption,
                        onChanged: (String? value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedOption != null) {
                      // Ajouter l'article au panier avec l'option sélectionnée
                      _addToCart(context, item, selectedOption, quantity);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Veuillez sélectionner une option.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Ajouter au Panier'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Fenêtre modale pour personnaliser les articles de la catégorie "Repas"
  void _showCustomizationDialog(BuildContext context, Map<String, dynamic> item) {
    int quantity = 1;
    List<String> selectedVegetables = [];
    Map<String, dynamic>? selectedMeat;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Personnaliser ${item['name']}'),
              content: SingleChildScrollView( // Ajout du défilement
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.containsKey('vegetables'))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choisissez vos légumes (Gratuit)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...item['vegetables'].map<Widget>((vegetable) {
                            return CheckboxListTile(
                              title: Text(vegetable),
                              value: selectedVegetables.contains(vegetable),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedVegetables.add(vegetable);
                                  } else {
                                    selectedVegetables.remove(vegetable);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    if (item.containsKey('meatOptions')) ...[
                      SizedBox(height: 20),
                      Text(
                        'Ajouter de la viande ou du poisson (Payant)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: item['meatOptions'].map<Widget>((meatOption) {
                          return RadioListTile<Map<String, dynamic>>(
                            title: Text('${meatOption['name']} (${meatOption['price']} CFA)'),
                            value: meatOption,
                            groupValue: selectedMeat,
                            onChanged: (Map<String, dynamic>? value) {
                              setState(() {
                                selectedMeat = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        Text(
                          '$quantity',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    // Ajouter l'article au panier avec les légumes et options sélectionnées
                    _addToCart(context, item, null, quantity, selectedVegetables, selectedMeat);
                    Navigator.pop(context);
                  },
                  child: Text('Ajouter au Panier'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
