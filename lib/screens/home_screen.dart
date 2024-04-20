import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_navi_stick/screens/signin_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;

  final LatLng _center = LatLng(19.022227, 72.856201);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Navi Stick'),
          elevation: 2,
        ),
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                  8.0), // Add some padding around the button
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Signed out");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  });
                },
                child: Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // return Scaffold(
  //   extendBodyBehindAppBar: true,
  //   appBar: AppBar(
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     title: const Text(
  //       "Smart Navi Stick",
  //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //     ),
  //   ),
  //   body: Container(
  //     child: Center(
  //         child: ElevatedButton(
  //             child: Text("Log Out"),
  //             onPressed: () {
  //               FirebaseAuth.instance.signOut().then((value) {
  //                 print("Signed out");
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => SignInScreen()));
  //               });
  //             })),
  //   ),
  // );
}
