import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_navi_stick/screens/signin_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_navi_stick/reusable_widgets/user_name_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  late LatLng latLng = LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _callNumber(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    String userName = Provider.of<UserNameProvider>(context).userName;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tracking - $userName'),
          elevation: 2,
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed out");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ),
                  );
                });
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('test')
                    .doc('FcNJSXB4ZlWQ69n3t94Z')
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Retrieve data from the snapshot
                  Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;

                  // Check if data is null and handle accordingly
                  if (data == null) {
                    return const Center(
                      child: Text('Data not available'),
                    );
                  }

                  // Extract latitude and longitude values as strings
                  String latitudeStr = data['latitude'] as String;
                  String longitudeStr = data['longitude'] as String;

                  // Convert strings to doubles using double.tryParse
                  double latitude = double.tryParse(latitudeStr) ?? 0.0;
                  double longitude = double.tryParse(longitudeStr) ?? 0.0;

                  // Create a LatLng object using the parsed doubles
                  LatLng latLng = LatLng(latitude / 100, longitude / 100);

                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: latLng,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('currentLocation'),
                        position: latLng,
                        infoWindow: InfoWindow(title: 'Your Location'),
                      ),
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      _callNumber('100');
                      // Call police action
                    },
                    label: Text('Call Police'),
                    icon: Icon(Icons.phone),
                    backgroundColor: Colors.red,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      _callNumber('02224184191');
                      // Call nearest hospital action
                    },
                    label: Text('Call Nearest Hospital'),
                    icon: Icon(Icons.phone),
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// class _HomeScreenState extends State<HomeScreen> {
//   late GoogleMapController mapController;
//   late LatLng latLng = LatLng(0, 0);

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.red,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Smart Navi Stick'),
//           elevation: 2,
//         ),
//         body: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('test')
//               .doc('FcNJSXB4ZlWQ69n3t94Z')
//               .snapshots(),
//           builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             // Retrieve data from the snapshot
//             Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;

//             // Check if data is null and handle accordingly
//             if (data == null) {
//               return const Center(
//                 child: Text('Data not available'),
//               );
//             }

//             // Extract latitude and longitude values as strings
//             String latitudeStr = data['latitude'] as String;
//             String longitudeStr = data['longitude'] as String;

//             // Convert strings to doubles using double.tryParse
//             double latitude = double.tryParse(latitudeStr) ?? 0.0;
//             double longitude = double.tryParse(longitudeStr) ?? 0.0;

//             // Create a LatLng object using the parsed doubles
//             LatLng latLng = LatLng(latitude/100, longitude/100);

//             return Column(
//               children: [
//                 Expanded(
//                   child: GoogleMap(
//                     onMapCreated: _onMapCreated,
//                     initialCameraPosition: CameraPosition(
//                       target: latLng,
//                       zoom: 15,
//                     ),
//                     markers: {
//                       Marker(
//                         markerId: MarkerId('currentLocation'),
//                         position: latLng,
//                         infoWindow: InfoWindow(title: 'Your Location'),
//                       ),
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       FirebaseAuth.instance.signOut().then((value) {
//                         print("Signed out");
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SignInScreen(),
//                           ),
//                         );
//                       });
//                     },
//                     child: Text('Log Out'),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
