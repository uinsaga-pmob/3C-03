class OrderModel {
  final String id;
  final String userId;
  final String productId;
  final String rentalStartDate;
  final String rentalEndDate;
  final int totalPrice;
  final String status; // 'pending', 'active', 'returned'

  OrderModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.totalPrice,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      rentalStartDate: json['rentalStartDate'],
      rentalEndDate: json['rentalEndDate'],
      totalPrice: json['totalPrice'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'rentalStartDate': rentalStartDate,
      'rentalEndDate': rentalEndDate,
      'totalPrice': totalPrice,
      'status': status,
    };
  }
}