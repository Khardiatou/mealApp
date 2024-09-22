import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealmagic/screens/checkout/payment_screen.dart';
import 'package:mealmagic/screens/restaurant/rsn_menu_page.dart';

class BasketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    final CollectionReference cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('cart');

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var cartItems = snapshot.data!.docs;
          if (cartItems.isEmpty) {
            return Center(child: Text('Votre panier est vide.'));
          }

          double total = _calculateTotal(cartItems);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index].data() as Map<String, dynamic>;

                    List<dynamic>? vegetables = item['vegetables'];
                    Map<String, dynamic>? meatOption = item['meat'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.shade100,
                            child: Text(
                              '${item['quantity']}x',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ),
                          title: Text(
                            '${item['name']}', // Le nom inclura l'option (ex: Pain avec Gésier)
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Afficher le prix de base et le prix total avec options
                              Text('${item['basePrice']} CFA (Prix de base)'),
                              if (item['option'] != null)
                                Text('Option: ${item['option']}',
                                    style: TextStyle(color: Colors.grey)),
                              if (vegetables != null && vegetables.isNotEmpty)
                                Text(
                                  'Légumes: ${vegetables.join(', ')}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              if (meatOption != null)
                                Text(
                                  'Option viande/poisson: ${meatOption['name']} (${meatOption['price']} CFA)',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              Text('Total: ${item['total']} CFA',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Bouton pour diminuer la quantité
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  _decreaseQuantity(cartItems[index].id,
                                      item['quantity'], cartRef);
                                },
                                color: Colors.red,
                              ),
                              Text(
                                '${item['quantity']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                              // Bouton pour augmenter la quantité
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  _increaseQuantity(cartItems[index].id,
                                      item['quantity'], cartRef);
                                },
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _buildSummaryRow('Sous-total', '${total.toStringAsFixed(2)} CFA'),
      _buildSummaryRow('Frais de livraison', '1,000 CFA'),
      Divider(),
      _buildTotalRow('Total à payer', '${(total + 1000).toStringAsFixed(2)} CFA'), // Total + frais de livraison
      SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          _checkout(context, total, cartRef);
        },
        child: Text('Valider la commande'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
      ),
    ],
  ),
)
,
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
      ],
    );
  }

  void _removeItem(String itemId, CollectionReference cartRef) {
    cartRef.doc(itemId).delete();
  }

  double _calculateTotal(List<QueryDocumentSnapshot> cartItems) {
  return cartItems.fold(0, (sum, item) {
    var data = item.data() as Map<String, dynamic>;
    double basePrice = (data['basePrice'] ?? 0).toDouble(); // Prix de base de l'article
    int quantity = data['quantity'] ?? 1; // Quantité d'articles

    // Ajouter le prix de l'option viande/poisson si elle existe
    double meatPrice = 0;
    if (data['meat'] != null) {
      meatPrice = (data['meat']['price'] ?? 0).toDouble();
    }

    // Calculer le total pour cet article (basePrice + meatPrice) * quantité
    double itemTotal = (basePrice + meatPrice) * quantity;

    return sum + itemTotal; // Ajouter au total général
  });
}

  // Fonction pour augmenter la quantité
  void _increaseQuantity(String itemId, int currentQuantity,
      CollectionReference cartRef) {
    cartRef.doc(itemId).update({'quantity': currentQuantity + 1});
  }

  // Fonction pour diminuer la quantité
  void _decreaseQuantity(String itemId, int currentQuantity,
      CollectionReference cartRef) {
    if (currentQuantity > 1) {
      cartRef.doc(itemId).update({'quantity': currentQuantity - 1});
    } else {
      _removeItem(itemId, cartRef);
    }
  }

  void _checkout(BuildContext context, double total,
      CollectionReference cartRef) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Commande validée'),
        content:
            Text('Votre commande a été passée avec succès. Total: $total CFA'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
            },
            child: Text('Retour aux articles'),
          ),
          ElevatedButton(
            onPressed: () {
              _clearCart(cartRef);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentScreen(totalAmount: total)),
              );
            },
            child: Text('Passer à la caisse'),
          ),
        ],
      ),
    );
  }

  void _clearCart(CollectionReference cartRef) {
    cartRef.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
