import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RSNReviewsScreen extends StatefulWidget {
  @override
  _RSNReviewsScreenState createState() => _RSNReviewsScreenState();
}

class _RSNReviewsScreenState extends State<RSNReviewsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Avis du Restaurant Sénégalais Néné',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('reviews').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var reviews = snapshot.data!.docs;
                if (reviews.isEmpty) {
                  return Center(child: Text('Aucun avis pour le moment.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),);
                }

                double averageRating = _calculateAverageRating(reviews);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Note moyenne: ${averageRating.toStringAsFixed(1)} / 5',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Icon(
                                index < averageRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.orange,
                                size: 30,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          var review = reviews[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Text(
                                review['reviewer'][0],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(review['reviewer']),
                            subtitle: Text(review['comment']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  i < review['rating']
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _buildAddReviewSection(),
        ],
      ),
    );
  }

  Widget _buildAddReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ajouter un avis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
              labelText: 'Votre commentaire',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Votre note: ',
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Slider(
                  value: _rating,
                  onChanged: (newRating) {
                    setState(() {
                      _rating = newRating;
                    });
                  },
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: '$_rating',
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submitReview,
            child: Text('Ajouter l\'avis'),
            style: ElevatedButton.styleFrom(
  backgroundColor: Colors.orange,
  // autres propriétés...
),

          ),
        ],
      ),
    );
  }

  void _submitReview() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (_reviewController.text.isNotEmpty && _rating > 0) {
      await _firestore.collection('reviews').add({
        'reviewer': user?.displayName ?? 'Utilisateur anonyme',
        'comment': _reviewController.text,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _reviewController.clear();
      setState(() {
        _rating = 0;
      });
    }
  }

  double _calculateAverageRating(List<QueryDocumentSnapshot> reviews) {
    double totalRating = 0;
    for (var review in reviews) {
      totalRating += review['rating'];
    }
    return totalRating / reviews.length;
  }
}
