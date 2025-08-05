import 'dart:io';
import 'package:flutter/material.dart';
import 'trip_model.dart';

class TripDetailScreen extends StatelessWidget {
  final TripModel trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trip.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(
            File(trip.imagePaths.first),
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(trip.description),
                const SizedBox(height: 8),
                Text("Budget: ₹${trip.budget}"),
                const SizedBox(height: 4),
                Text("Start: ${trip.startDate.toLocal().toString().split(' ')[0]}"),
                Text("End: ${trip.endDate.toLocal().toString().split(' ')[0]}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
