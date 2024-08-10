import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harita_uygulama_yyu/feature/screens/login/login_screen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
 

}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Other variables
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  MapType _currentMapType = MapType.normal;
  late GoogleMapController _controller;
  int _polylineIdCounter = 1;
  int _markerIdCounter = 1;

  Offset _fabPosition = Offset(20, 20); // FloatingActionButton başlangıç pozisyonu

  double _originLatitude = 38.57595834305205;
  double _originLongitude = 43.29970046867356;
  double _destLatitude = 38.575051429138874;
  double _destLongitude = 43.29670343193504;

  String? _polylineName;
  double? _distance;

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(38.57595834305205, 43.29970046867356),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _loadUserData() async {
  User? user = _auth.currentUser;
  if (user != null) {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      setState(() {
        _originLatitude = userDoc['originLatitude'];
        _originLongitude = userDoc['originLongitude'];
        _destLatitude = userDoc['destLatitude'];
        _destLongitude = userDoc['destLongitude'];
        _polylineName = userDoc['polylineName'];
        _distance = userDoc['distance'];
      });
      _getPolyline(_polylineName!, Colors.blue);
    }
  }
}


Future<void> _saveUserData() async {
  try {
    User? user = _auth.currentUser;
    if (user != null) {
 await _firestore.collection('users').doc(user.uid).set({
  'originLatitude': _originLatitude,
  'originLongitude': _originLongitude,
  'destLatitude': _destLatitude,
  'destLongitude': _destLongitude,
  'polylineName': _polylineName,
  'distance': _distance,
}, SetOptions(merge: true));
    }
  } catch (e) {
    print('Firestore save error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          FractionallySizedBox(
            heightFactor: 0.7,
            child: GoogleMap(
              polylines: Set<Polyline>.of(polylines.values),
              markers: Set<Marker>.of(markers.values),
              myLocationButtonEnabled: true,
              mapType: _currentMapType,
              initialCameraPosition: _initialCameraPosition,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
          ),
          Positioned(
            bottom: 150,
            left: 10,
            child: ElevatedButton(
              onPressed: _onSelectPointsButtonPressed,
              child: Text('Başlangıç ve Bitiş Noktalarını Seç'),
            ),
          ),
          Positioned(
            left: _fabPosition.dx,
            top: _fabPosition.dy,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: null,
                child: Icon(Icons.map),
                backgroundColor: Colors.orange,
              ),
              childWhenDragging: Container(),
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  _fabPosition = offset;
                });
              },
              child: FloatingActionButton(
                onPressed: _onMapTypeButtonPressed,
                child: Icon(Icons.map),
                backgroundColor: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 50,),
         // Alt buton
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red,
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_polylineName != null)
                    Text(
                      'Çizgi Adı: $_polylineName',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  if (_distance != null)
                    Text(
                      'Mesafe: ${_distance!.toStringAsFixed(2)} km',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
       floatingActionButton: FloatingActionButton(
        heroTag: null,
      onPressed: _showLogoutDialog,
      child: Icon(Icons.exit_to_app),
      backgroundColor: Colors.red,
    ),
    );
  }
void _showLogoutDialog() {
  
  showDialog(
    
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Hesaptan çıkmak istiyor musunuz?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ShowDialog'u kapatır
          },
          child: Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            _loggout(); // Hesaptan çıkış yapar
          },
          child: Text('Tamam'),
        ),
      ],
    ),
  );
}

Future<void> _loggout() async {
  await _auth.signOut(); // Firebase'den çıkış yapar
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
}
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onSelectPointsButtonPressed() async {
    LatLng? origin = await _selectPoint(context, 'Başlangıç Noktasını Seçin');
    if (origin == null) return;

    LatLng? destination = await _selectPoint(context, 'Bitiş Noktasını Seçin');
    if (destination == null) return;

    String? polylineName = await _getPolylineName(context);
    if (polylineName == null || polylineName.isEmpty) return;

    Color? polylineColor = await _getPolylineColor(context);
    if (polylineColor == null) return;

    setState(() {
      _originLatitude = origin.latitude;
      _originLongitude = origin.longitude;
      _destLatitude = destination.latitude;
      _destLongitude = destination.longitude;
      _polylineName = polylineName;
      _distance = Geolocator.distanceBetween(
        _originLatitude,
        _originLongitude,
        _destLatitude,
        _destLongitude,
      ) / 1000; // Mesafeyi kilometre cinsinden hesapla
    });

    await _saveUserData();
    _getPolyline(polylineName, polylineColor);
  }

  Future<LatLng?> _selectPoint(BuildContext context, String title) async {
    LatLng? selectedPoint;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onTap: (point) {
              selectedPoint = point;
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
    return selectedPoint;
  }

  Future<String?> _getPolylineName(BuildContext context) async {
    String? polylineName;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Çizgi İsmi Girin'),
        content: TextField(
          onChanged: (value) {
            polylineName = value;
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Tamam'),
          ),
        ],
      ),
    );
    return polylineName;
  }

  Future<Color?> _getPolylineColor(BuildContext context) async {
    Color? selectedColor;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Çizgi Rengi Seçin'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.circle, color: Colors.red),
                title: Text('Kırmızı'),
                onTap: () {
                  selectedColor = Colors.red;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.green),
                title: Text('Yeşil'),
                onTap: () {
                  selectedColor = Colors.green;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.blue),
                title: Text('Mavi'),
                onTap: () {
                  selectedColor = Colors.blue;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.yellow),
                title: Text('Sarı'),
                onTap: () {
                  selectedColor = Colors.yellow;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.orange),
                title: Text('Turuncu'),
                onTap: () {
                  selectedColor = Colors.orange;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.purple),
                title: Text('Mor'),
                onTap: () {
                  selectedColor = Colors.purple;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.pink),
                title: Text('Pembe'),
                onTap: () {
                  selectedColor = Colors.pink;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.brown),
                title: Text('Kahverengi'),
                onTap: () {
                  selectedColor = Colors.brown;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.grey),
                title: Text('Gri'),
                onTap: () {
                  selectedColor = Colors.grey;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
    return selectedColor;
  }

  void _getPolyline(String polylineName, Color polylineColor) async {
    List<LatLng> polylineCoordinates = [];

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(_originLatitude, _originLongitude),
          destination: PointLatLng(_destLatitude, _destLongitude),
          mode: TravelMode.driving,
        ),
        googleApiKey: "AIzaSyD3F26wQhYJ7jMTRuw3rjPTGJlhTUvIhko", 
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        _addPolyline(polylineCoordinates, polylineName, polylineColor);

        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            polylineCoordinates.map((e) => e.latitude).reduce((a, b) => a < b ? a : b),
            polylineCoordinates.map((e) => e.longitude).reduce((a, b) => a < b ? a : b),
          ),
          northeast: LatLng(
            polylineCoordinates.map((e) => e.latitude).reduce((a, b) => a > b ? a : b),
            polylineCoordinates.map((e) => e.longitude).reduce((a, b) => a > b ? a : b),
          ),
        );

        _controller.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );

        _addMarkers(bounds);
      } else {
        throw Exception('No points found in the polyline');
      }
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  void _addPolyline(List<LatLng> polylineCoordinates, String polylineName, Color polylineColor) {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: polylineColor,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  void _addMarkers(LatLngBounds bounds) {
    MarkerId originMarkerId = MarkerId('origin_marker');
    MarkerId destinationMarkerId = MarkerId('destination_marker');

    Marker originMarker = Marker(
      markerId: originMarkerId,
      position: LatLng(_originLatitude, _originLongitude),
      infoWindow: InfoWindow(title: 'Başlangıç Noktası'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: destinationMarkerId,
      position: LatLng(_destLatitude, _destLongitude),
      infoWindow: InfoWindow(title: 'Bitiş Noktası'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markers[originMarkerId] = originMarker;
      markers[destinationMarkerId] = destinationMarker;
    });
  }
}
