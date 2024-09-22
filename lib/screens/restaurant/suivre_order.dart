import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SuivreCommandeScreen extends StatefulWidget {
  @override
  _SuivreCommandeScreenState createState() => _SuivreCommandeScreenState();
}

class _SuivreCommandeScreenState extends State<SuivreCommandeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  GoogleMapController? _mapController;
  LatLng _startLocation = LatLng(-26.131, 28.231); // Kempton Park (Exemple)
  LatLng _endLocation = LatLng(-26.137, 28.246);   // Destination finale (Exemple)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suivi des Commandes'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Map section
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _startLocation,
                zoom: 12.0,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              polylines: _createPolyline(),
              markers: _createMarkers(),
            ),
          ),

          // Order Summary section
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .collection('orders')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Vous n\'avez aucune commande en cours.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                var order = snapshot.data!.docs.first;
                var orderData = order.data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Résumé de la commande',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildOrderItems(orderData['items']),
                      SizedBox(height: 16),
                      Text(
                        'Montant Total: ${orderData['totalAmount']} CFA',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      _buildOrderStatus(orderData['status']),
                      SizedBox(height: 16),
                      // Button to leave the page
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);  // Quitter
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: Text(
                            'Quitter',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['name'], style: TextStyle(fontSize: 16)),
              Text('${item['quantity']} x ${item['price']} CFA'),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderStatus(String status) {
    Color statusColor;
    String statusText;

    switch (status) {
      case 'en cours':
        statusColor = Colors.orange;
        statusText = 'Commande en cours';
        break;
      case 'livrée':
        statusColor = Colors.green;
        statusText = 'Commande livrée';
        break;
      case 'annulée':
        statusColor = Colors.red;
        statusText = 'Commande annulée';
        break;
      default:
        statusColor = Colors.blue;
        statusText = 'Statut inconnu';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Statut: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  // Create markers for start and destination points
  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId('start'),
        position: _startLocation,
        infoWindow: InfoWindow(title: 'Point de départ'),
      ),
      Marker(
        markerId: MarkerId('end'),
        position: _endLocation,
        infoWindow: InfoWindow(title: 'Destination'),
      ),
    };
  }

  // Create polyline (route) between two locations
  Set<Polyline> _createPolyline() {
    return {
      Polyline(
        polylineId: PolylineId('route'),
        points: [_startLocation, _endLocation],
        color: Colors.orange,
        width: 5,
      ),
    };
  }
}
