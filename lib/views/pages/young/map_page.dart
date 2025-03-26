import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Position> _getPosition() async {
  bool servicesEnabled;
  LocationPermission permission;

  servicesEnabled = await Geolocator.isLocationServiceEnabled();
  if (!servicesEnabled) {
    return Future.error('Location services are disabled.');
  } 

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    return Future.error('Locatation permissions are denied');
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  print('Happyyyyyyy');

  return await Geolocator.getCurrentPosition();
}

class Young_MapPage extends StatefulWidget {
  const Young_MapPage({super.key});

  @override
  State<Young_MapPage> createState() => _Young_mapState();
}

class _Young_mapState extends State<Young_MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _elderlyLocation;
  String _locationText = 'Elderly Location: Unknown';
  Set<Marker> _markers = {};

  Future<void> _updateMap() async {
    try {
      final position = await _getPosition();
      setState(() {
        _elderlyLocation = LatLng(position.latitude, position.longitude);
        _locationText =
            'Elderly Location: Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        _markers = {
          Marker(
            markerId: const MarkerId('elderlyLocation'),
            position: _elderlyLocation!,
            infoWindow: const InfoWindow(title: 'Elderly Location'),
          ),
        };
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _elderlyLocation!, zoom: 15),
      ));
    } catch (e) {
      setState(() {
        _locationText = 'Error: $e';
      });
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Elderly'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _elderlyLocation != null
                  ? GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _elderlyLocation!,
                        zoom: 15,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: _markers,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'Google Map Placeholder',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              _locationText,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateMap,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Start Tracking'),
            ),
          ],
        ),
      ),
    );
  }
}