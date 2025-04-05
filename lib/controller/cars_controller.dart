import 'package:firebase_database/firebase_database.dart';
import 'package:lesson_6moonz3/models/car_model.dart';

class FirebaseService {
  static final DatabaseReference _db = FirebaseDatabase.instance.ref().child('cars');

  static Future<List<Car>> getCars() async {
    final snapshot = await _db.get();
    
    if (!snapshot.exists) {
      return [];
    }

    Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
    List<Car> cars = [];
    values.forEach((key, value) {
      cars.add(Car.fromMap(Map<String, dynamic>.from(value)));
    });
    return cars;
  }

  static Future<void> addCar(Car car) async {
    await _db.push().set(car.toMap());
  }

  static Future<void> updateCar(Car car) async {
    await _db.child(car.id).update(car.toMap());
  }

  static Future<void> deleteCar(String id) async {
    await _db.child(id).remove();
  }
}