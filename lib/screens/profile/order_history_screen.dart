import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Commandes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          var orders = snapshot.data!.docs;
          return ListView(
            children: orders.map((order) {
              var data = order.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['itemName']),
                subtitle: Text('${data['price']} € - ${data['date']}'),
                trailing: Text('x${data['quantity']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
