import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const favoritesBox = 'favorite_car';
const List<String> cars = [
  'Toyota Camry',
  'Honda Civic',
  'Ford Mustang',
  'Chevrolet Corvette',
  'Tesla Model 3',
  'Volkswagen Golf',
  'BMW 3 Series',
  'Audi Q5',
  'Jeep Wrangler',
  'Mercedes-Benz E-Class',
  'Subaru Outback',
  'Nissan Altima',
  'Hyundai Sonata',
  'Kia Sorento',
  'Mazda CX-5',
  'Lexus RX',
  'Volvo XC60',
];

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>(favoritesBox);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box<String> favoriteCarsBox;

  @override
  void initState() {
    super.initState();
    favoriteCarsBox = Hive.box(favoritesBox);
  }

  Widget getIcon(int index) {
    if (favoriteCarsBox.containsKey(index)) {
      return Icon(Icons.favorite, color: Colors.red);
    }
    return Icon(Icons.favorite_border);
  }

  void onFavoritePress(int index) {
    if (favoriteCarsBox.containsKey(index)) {
      favoriteCarsBox.delete(index);
      return;
    }
    favoriteCarsBox.put(index, cars[index]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Cars',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Favorite Cars'),
        ),
        body: ValueListenableBuilder(
          valueListenable: favoriteCarsBox.listenable(),
          builder: (context, Box<String> box, _) {
            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, listIndex) {
                return ListTile(
                  title: Text(cars[listIndex]),
                  trailing: IconButton(
                    icon: getIcon(listIndex),
                    onPressed: () => onFavoritePress(listIndex),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
