import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mealmagic/screens/restaurant/restaurant_nene.dart';
import 'package:mealmagic/screens/restaurant/suivre_order.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  PaymentScreen({required this.totalAmount});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'credit_card'; // Méthode de paiement sélectionnée
  final _creditCardNumberController = TextEditingController();
  final _creditCardExpiryController = TextEditingController();
  final _creditCardCVVController = TextEditingController();
  final _mobileMoneyNumberController = TextEditingController();
  final _mobileMoneyCodeController = TextEditingController(); // Champ code Mobile Money
  final _mobileMoneySenderNumberController = TextEditingController(); // Numéro de l'émetteur Mobile Money

  bool _isButtonEnabled = false; // Contrôle de l'état du bouton Payer maintenant
  bool _showError = false; // Contrôle de l'affichage des erreurs

  String? _creditCardNumberError;
  String? _creditCardExpiryError;
  String? _creditCardCVVError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Les Détails du Paiement'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Méthode de paiement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPaymentMethodButton('Carte Crédit', 'credit_card',
                    Icons.credit_card, Colors.orange),
                _buildPaymentMethodButton('Mobile Money', 'mobile_money',
                    Icons.phone_android, Colors.green),
              ],
            ),
            SizedBox(height: 24),

            // Affiche les détails de la méthode de paiement sélectionnée
            if (_selectedPaymentMethod == 'credit_card') _buildCreditCardDetails(),
            if (_selectedPaymentMethod == 'mobile_money') _buildMobileMoneyDetails(),

            Spacer(),
            // Montant total à payer
            Text(
              'Montant à payer',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              '${widget.totalAmount.toStringAsFixed(2)} CFA', // Prix dynamique
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            SizedBox(height: 24),

            // Boutons de navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Retourne au panier
                  },
                  child: Text(
                    'Retour au panier',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _processPayment : null, // Activer ou désactiver le bouton
                  child: Text(
                    'Payer maintenant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isButtonEnabled ? Colors.green : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bouton pour choisir la méthode de paiement
  Widget _buildPaymentMethodButton(
      String title, String method, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method; // Mettre à jour la méthode de paiement
          _checkFormValidity(); // Vérifie l'état du formulaire
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _selectedPaymentMethod == method
                  ? color.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _selectedPaymentMethod == method ? color : Colors.grey,
                width: 2,
              ),
            ),
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: color, size: 32),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: _selectedPaymentMethod == method ? color : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Détails de la carte de crédit avec messages d'erreurs
  Widget _buildCreditCardDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _creditCardNumberController,
          decoration: InputDecoration(
            labelText: 'Numéro de Carte',
            hintText: '1234 5678 9101 1121',
            border: OutlineInputBorder(),
            errorText: _creditCardNumberError,
          ),
          keyboardType: TextInputType.number,
          maxLength: 16,
          onChanged: (_) => _checkFormValidity(),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _creditCardExpiryController,
                decoration: InputDecoration(
                  labelText: 'Date d\'expiration',
                  hintText: 'MM/AA',
                  border: OutlineInputBorder(),
                  errorText: _creditCardExpiryError,
                ),
                keyboardType: TextInputType.datetime,
                maxLength: 5,
                onChanged: (_) => _checkFormValidity(),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _creditCardCVVController,
                decoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                  border: OutlineInputBorder(),
                  errorText: _creditCardCVVError,
                ),
                keyboardType: TextInputType.number,
                maxLength: 3,
                onChanged: (_) => _checkFormValidity(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Détails pour Mobile Money
  Widget _buildMobileMoneyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _mobileMoneyNumberController,
          decoration: InputDecoration(
            labelText: 'Numéro Mobile Money (Receveur)',
            hintText: 'Numéro de téléphone du receveur',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          onChanged: (_) => _checkFormValidity(),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _mobileMoneySenderNumberController,
          decoration: InputDecoration(
            labelText: 'Numéro émetteur Mobile Money',
            hintText: 'Votre numéro de téléphone',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          onChanged: (_) => _checkFormValidity(),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _mobileMoneyCodeController,
          decoration: InputDecoration(
            labelText: 'Code de confirmation',
            hintText: 'Entrez le code',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _checkFormValidity(),
        ),
      ],
    );
  }

  // Vérifie si tous les champs sont remplis et valide l'état du bouton
  void _checkFormValidity() {
    bool isValid = false;
    if (_selectedPaymentMethod == 'credit_card') {
      isValid = _validateCreditCard(); // Valide les informations de la carte
    } else if (_selectedPaymentMethod == 'mobile_money') {
      isValid = _mobileMoneyNumberController.text.isNotEmpty &&
          _mobileMoneyCodeController.text.isNotEmpty &&
          _mobileMoneySenderNumberController.text.isNotEmpty;
    }
    setState(() {
      _isButtonEnabled = isValid;
    });
  }

  // Valide les informations de la carte de crédit
  bool _validateCreditCard() {
    setState(() {
      _creditCardNumberError = _creditCardNumberController.text.length == 16
          ? null
          : 'Numéro de carte invalide';
      _creditCardExpiryError =
          _creditCardExpiryController.text.length == 5 ? null : 'Date invalide';
      _creditCardCVVError =
          _creditCardCVVController.text.length == 3 ? null : 'CVV invalide';
    });
    return _creditCardNumberError == null &&
        _creditCardExpiryError == null &&
        _creditCardCVVError == null;
  }

  // Traitement du paiement
  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == 'mobile_money') {
      // Envoie une notification Firebase Cloud Functions
      try {
        HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('sendMobileMoneyNotification');
        await callable.call(<String, dynamic>{
          'senderNumber': _mobileMoneySenderNumberController.text,
          'amount': widget.totalAmount,
        });
      } catch (e) {
        print('Erreur lors de l\'envoi de la notification Mobile Money: $e');
      }
    }

    _showPaymentConfirmationDialog(); // Affiche la boîte de dialogue de confirmation
  }

  // Boîte de dialogue pour confirmer le paiement
  void _showPaymentConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Paiement réussi'),
          content: Text('Transfert reçu. Merci pour votre paiement !'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SuivreCommandeScreen()),
                );
              },
              child: Text('Suivre commande'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantNene()),
                );
              },
              child: Text('Quitter'),
            ),
          ],
        );
      },
    );
  }
}
