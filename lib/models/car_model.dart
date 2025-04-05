class Car {
  String id;
  String name;
  String year;
  String speed;
  String image;
  String price;

  Car({
    required this.id,
    required this.name,
    required this.year,
    required this.speed,
    required this.image,
    required this.price,
  });

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      year: map['year'] ?? '',
      speed: map['speed'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'speed': speed,
      'image': image,
      'price': price,
    };
  }
}