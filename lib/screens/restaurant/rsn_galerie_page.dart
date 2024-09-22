import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galerie du Restaurant'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('gallery').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final photos = snapshot.data!.docs.map((doc) => doc['url'] as String).toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Image.network(
                photos[index],
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }
}
