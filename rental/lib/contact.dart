class Contact {
  late int? id;
  late int? accountId;
  late String? model;
  late String? description;
  late String? price;
  late String? imageFilename;

  Contact({
    required this.id,
    required this.accountId,
    required this.model,
    required this.description,
    required this.price,
    this.imageFilename,
  });
  Contact.jsonData({
    required this.accountId,
  });
  Map<String, dynamic> toJson() {
    return {
      "accountId": accountId,
    };
  }

  Map<String, dynamic> toJson2() {
    return {
      'id': id,
      'accountId': accountId,
      'model': model,
      'description': description,
      'price': price,
      'imageFilename': imageFilename,
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
  return Contact(
    id: int.tryParse(json['car_id'].toString()),
    accountId: int.tryParse(json['accountId'].toString()),
    model: json['car_model'],
    description: json['car_description'],
    price: json['car_price'],
    imageFilename: json['car_image'],
  );
}

}
