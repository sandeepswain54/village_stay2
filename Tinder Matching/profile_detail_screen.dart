import 'package:flutter/material.dart';
import 'package:service_app/Tinder%20Matching/trip_model.dart';


class ProfileDetailScreen extends StatelessWidget {
  final TripModel trip;

  ProfileDetailScreen({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trip.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(trip.imagePaths[0], // or any index you want
 fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(trip.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
