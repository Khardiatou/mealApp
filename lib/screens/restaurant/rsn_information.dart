import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';  // Mise à jour pour Geolocator

class RsnInfoScreen extends StatefulWidget {
  @override
  _RsnInfoScreenState createState() => _RsnInfoScreenState();
}

class _RsnInfoScreenState extends State<RsnInfoScreen> {
  GoogleMapController? mapController;
  MapType _currentMapType = MapType.normal;
  Position? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Service de localisation désactivé.');
    }

    // Vérifie les permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissions de localisation refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Les permissions sont refusées de manière permanente
      return Future.error(
          'Permissions de localisation refusées définitivement.');
    }

    // Récupère la position actuelle
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLocation = position;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations - Restaurant Sénégalais Néné'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoSection(
              title: 'Horaires de Livraison',
              content: 'Lundi - Samedi : 8:00 AM–20:00 PM\nDimanche : 8:00 AM–12:00 PM',
            ),
            SizedBox(height: 20),
            _buildInfoSection(
              title: 'Temps estimé jusqu\'à la livraison',
              content: '20 min',
            ),
            SizedBox(height: 20),
            _buildInfoSection(
              title: 'Informations de contact',
              content: 'Numéro de téléphone : +226 72609261\nSite web : http://nene.bf/',
            ),
            SizedBox(height: 20),
            _buildInfoSection(
              title: 'Localisation',
              content: '',
              child: Container(
                height: 300,
                child: Stack(
                  children: [
                    _currentLocation == null
                        ? Center(child: CircularProgressIndicator()) // Ajout d'un indicateur de chargement
                        : GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(_currentLocation!.latitude,
                                  _currentLocation!.longitude),
                              zoom: 14.0,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId('restaurantLocation'),
                                position:
                                    LatLng(12.3714, -1.5197), // Coordonnées du restaurant
                                infoWindow:
                                    InfoWindow(title: 'Restaurant Sénégalais Néné'),
                              ),
                              Marker(
                                markerId: MarkerId('currentLocation'),
                                position: LatLng(_currentLocation!.latitude,
                                    _currentLocation!.longitude),
                                infoWindow:
                                    InfoWindow(title: 'Votre Position Actuelle'),
                              ),
                            },
                            mapType: _currentMapType,
                          ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: _toggleMapType,
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.map),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      {required String title, required String content, Widget? child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (content.isNotEmpty) Text(content, style: TextStyle(fontSize: 16)),
        if (child != null) child,
      ],
    );
  }
}
