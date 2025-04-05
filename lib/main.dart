import 'package:flutter/material.dart';
import 'models/car_model.dart';
import 'controller/cars_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Car> cars = [];
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController speedController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  Future<void> loadCars() async {
    setState(() => isLoading = true);
    cars = await FirebaseService.getCars();
    setState(() => isLoading = false);
  }

  void showCarDialog({Car? car}) {
    if (car != null) {
      nameController.text = car.name;
      yearController.text = car.year;
      speedController.text = car.speed;
      imageController.text = car.image;
      priceController.text = car.price;
    } else {
      nameController.clear();
      yearController.clear();
      speedController.clear();
      imageController.clear();
      priceController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(car == null ? 'Yangi mashina' : 'Tahrirlash'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nomi')),
              TextField(
                  controller: yearController,
                  decoration: InputDecoration(labelText: 'Yili')),
              TextField(
                  controller: speedController,
                  decoration: InputDecoration(labelText: 'Tezligi')),
              TextField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: 'Rasm URL')),
              TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Narxi')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Bekor')),
          ElevatedButton(
            child: Text(car == null ? 'Qo‘shish' : 'Saqlash'),
            onPressed: () async {
              final newCar = Car(
                id: car?.id ?? '',
                name: nameController.text,
                year: yearController.text,
                speed: speedController.text,
                image: imageController.text,
                price: priceController.text,
              );

              if (car == null) {
                await FirebaseService.addCar(newCar);
              } else {
                await FirebaseService.updateCar(newCar);
              }

              Navigator.pop(context);
              await loadCars();
            },
          ),
        ],
      ),
    );
  }

  // Mashina o'chirish
  Future<void> deleteCar(String id) async {
    await FirebaseService.deleteCar(id);
    await loadCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mashinalar'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showCarDialog(),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cars.isEmpty
              ? Center(child: Text('Hech qanday mashina yo‘q'))
              : ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(
                          car.image,
                          width: 60,
                          errorBuilder: (_, __, ___) => Icon(Icons.car_rental),
                        ),
                        title: Text('${car.name} (${car.year})'),
                        subtitle: Text(
                            'Tezlik: ${car.speed} km/h\nNarx: \$${car.price}'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showCarDialog(car: car),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteCar(car.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
