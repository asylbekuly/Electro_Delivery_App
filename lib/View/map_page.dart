import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = MapController();
  LatLng _currentPosition = LatLng(51.1605, 71.4704);
  bool _locationLoaded = false;
  double _currentZoom = 13.0;
  List<Marker> _customMarkers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      timeLimit: const Duration(seconds: 10),
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _locationLoaded = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    mapController.move(_currentPosition, _currentZoom);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '📍 Location updated: ${_currentPosition.latitude}, ${_currentPosition.longitude}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      mapController.move(mapController.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      mapController.move(mapController.center, _currentZoom);
    });
  }

  void _goToCurrentLocation() {
    mapController.move(_currentPosition, _currentZoom);
  }

  void _addMarkerWithDoubleTap(LatLng point) {
    final alreadyExists = _customMarkers.any(
      (m) => m.point.latitude == point.latitude && m.point.longitude == point.longitude,
    );

    if (alreadyExists) return;

    setState(() {
      _customMarkers.add(
        Marker(
          point: point,
          width: 50,
          height: 50,
          child: GestureDetector(
            onDoubleTap: () {
              setState(() {
                _customMarkers.removeWhere(
                  (m) => m.point.latitude == point.latitude && m.point.longitude == point.longitude,
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑️ Marker deleted')),
              );
            },
            child: const Icon(
              Icons.add_location_alt,
              color: Colors.orange,
              size: 40,
            ),
          ),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📌 Marker added: ${point.latitude}, ${point.longitude}'),
      ),
    );
  }

  void _clearAllMarkers() {
    setState(() => _customMarkers.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🧹 All markers deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: _currentPosition,
              zoom: _currentZoom,
              onTap: (tapPosition, point) => _addMarkerWithDoubleTap(point),
              onPositionChanged: (MapPosition pos, bool hasGesture) {
                setState(() {
                  _currentZoom = pos.zoom ?? _currentZoom;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  if (_locationLoaded)
                    Marker(
                      point: _currentPosition,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  Marker(
                    point: const LatLng(51.1605, 71.4704),
                    width: 60,
                    height: 60,
                    child: Tooltip(
                      message: 'TechZone',
                      child: const Icon(
                        Icons.store,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                  Marker(
                    point: const LatLng(51.1287, 71.4304),
                    width: 60,
                    height: 60,
                    child: Tooltip(
                      message: 'PowerElectro',
                      child: const Icon(
                        Icons.store,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  ),
                  Marker(
                    point: const LatLng(51.1450, 71.4900),
                    width: 60,
                    height: 60,
                    child: Tooltip(
                      message: 'SmartFix',
                      child: const Icon(
                        Icons.store,
                        color: Colors.purple,
                        size: 40,
                      ),
                    ),
                  ),
                  ..._customMarkers,
                ],
              ),
            ],
          ),
          Positioned(
            right: 10,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  mini: true,
                  onPressed: _zoomIn,
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  mini: true,
                  onPressed: _zoomOut,
                  child: const Icon(Icons.zoom_out),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'locate_me',
                  onPressed: _goToCurrentLocation,
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'refresh_location',
                  mini: true,
                  onPressed: _getCurrentLocation,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'clear_markers',
                  mini: true,
                  onPressed: _clearAllMarkers,
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
