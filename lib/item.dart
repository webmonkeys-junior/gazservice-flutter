class ItemData {
  final String id;
  final String name;
  final String address;
  final String time;
  final double amount;
  final String geolocation;

  ItemData({
    required this.id,
    required this.name,
    required this.address,
    required this.time,
    required this.amount,
    required this.geolocation,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json['id'].toString(),
      name: json['name'],
      address: json['address'],
      time: json['time'],
      amount: json['amount'].toDouble(),
      geolocation: json['geolocation'],
    );
  }
}