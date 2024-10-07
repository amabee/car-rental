import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NavigationItem {
  IconData iconData;

  NavigationItem(this.iconData);
}

List<NavigationItem> getNavigationItemList() {
  return <NavigationItem>[
    NavigationItem(Icons.home),
    NavigationItem(Icons.calendar_today),
    NavigationItem(Icons.notifications),
    NavigationItem(Icons.person),
  ];
}

class Car {
  final int id;
  final String model;
  final String make;
  final String status;
  final String image;
  final double price;
  final int year; // Changed to int

  Car({
    required this.id,
    required this.model,
    required this.make,
    required this.status,
    required this.image,
    required this.price,
    required this.year,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['car_id'],
      make: json['make'],
      model: json['model'],
      status: json['status'],
      image:
          "http://192.168.56.1/car-rental_api/car_images/" + json['car_image'],
      price: double.parse(json['price_per_day']),
      year: json['year'], // No change needed here
    );
  }
}

Future<List<Car>> fetchAvailableCars() async {
  var url =
      Uri.parse('http://192.168.56.1/car-rental_api/customer/process.php');
  final query = {"operation": "getAvailableCars", "json": jsonEncode({})};
  final response = await http.get(url.replace(queryParameters: query));
  try {
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> cars = jsonResponse['success'];
      print(cars);
      return cars.map((carData) => Car.fromJson(carData)).toList();
    } else {
      throw Exception('Failed to load cars');
    }
  } catch (error) {
    print(response);
    print("Error: $error");
    throw error;
  }
}

class Customer {
  final int id;
  final String name;
  final int bookings;

  Customer({
    required this.id,
    required this.name,
    required this.bookings,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['customer_id'],
      name: json['first_name'] + " " + json['last_name'],
      bookings: json['bookings'],
    );
  }
}



class Dealer {
  String name;
  int offers;
  String image;

  Dealer(this.name, this.offers, this.image);
}

List<Dealer> getDealerList() {
  return <Dealer>[
    Dealer(
      "Hertz",
      174,
      "assets/images/hertz.png",
    ),
    Dealer(
      "Avis",
      126,
      "assets/images/avis.png",
    ),
    Dealer(
      "Tesla",
      89,
      "assets/images/tesla.jpg",
    ),
  ];
}

class Filter {
  String name;

  Filter(this.name);
}

List<Filter> getFilterList() {
  return <Filter>[
    Filter("Best Match"),
    Filter("Highest Price"),
    Filter("Lowest Price"),
  ];
}
