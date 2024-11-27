class ItemData {
  final int id; // Changed to int based on API response
  final String name;
  final String geo; // Changed to geo based on API response
  final String createdAt; // Added createdAt field
  final String work; // Added work field
  final double sum; // Changed to double based on API response
  final String photo; // Added photo field (if needed)

  ItemData({
    required this.id,
    required this.name,
    required this.geo,
    required this.createdAt,
    required this.work,
    required this.sum,
    required this.photo,
  });

  // Factory constructor to create an Item from JSON
  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json['id'],
      name: json['name'] ?? '',
      geo: json['geo'] ?? '',
      createdAt: json['created_at'] ?? '', // Ensure you format this if needed
      work: json['work'] ?? '',
      sum: json['sum'] ?? '',
      photo: json['photo'] ?? '', // If you want to use this field later
    );
  }
}