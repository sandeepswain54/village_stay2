class TripModel {
  final String name;
  final String description;
  final int budget;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> imagePaths;

  TripModel({
    required this.name,
    required this.description,
    required this.budget,
    required this.startDate,
    required this.endDate,
    required this.imagePaths,
  });
}
