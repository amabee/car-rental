// showroom_home.dart
import 'dart:async';
import 'package:car_rental_mobile/data.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_mobile/constants.dart';
import 'package:car_rental_mobile/car_widget.dart';
import 'package:car_rental_mobile/available_cars.dart';
import 'package:car_rental_mobile/book_car.dart';
import 'package:car_rental_mobile/top_customer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowroomHome extends StatefulWidget {
  @override
  _ShowroomHomeState createState() => _ShowroomHomeState();
}

class _ShowroomHomeState extends State<ShowroomHome> {
  late Future<List<Customer>> futureTopCustomers;
  List<Car> cars = [];
  List<Customer> topCustomers = [];
  Timer? pollingTimer;

  @override
  void initState() {
    super.initState();
    futureTopCustomers = fetchTopCustomers();
    startPollingAvailableCars();
  }

  void startPollingAvailableCars() {
    pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final fetchedCars = await fetchAvailableCars();
        setState(() {
          cars = fetchedCars;
        });

        futureTopCustomers.then((fetchedTopCustomers) {
          setState(() {
            topCustomers = fetchedTopCustomers;
          });
        });
      } catch (error) {
        print("Error fetching available cars: $error");
      }
    });
  }

  @override
  void dispose() {
    pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.only(left: 30),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 24.0, left: 16.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOP DEALS",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 280,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: buildDeals(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvailableCars(),
                        ),
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16, right: 16, left: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Available Cars",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Long term and short term rental",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              height: 50,
                              width: 50,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOP CUSTOMERS",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "view all",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: kPrimaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: buildTopCustomers(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildDeals() {
    List<Widget> list = [];
    for (var i = 0; i < cars.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookCar(car: cars[i])),
          );
        },
        child: buildCar(cars[i], i),
      ));

      if (i < cars.length - 1) {
        list.add(const SizedBox(width: 12));
      }
    }
    return list;
  }

  List<Widget> buildTopCustomers() {
    List<Widget> list = [];
    for (var i = 0; i < topCustomers.length; i++) {
      list.add(buildCustomer(topCustomers[i], i));
    }
    return list;
  }

  Future<List<Customer>> fetchTopCustomers() async {
    var url =
        Uri.parse('http://192.168.56.1/car-rental_api/customer/process.php');
    final query = {"operation": "getTopCustomers", "json": jsonEncode({})};
    final response = await http.get(url.replace(queryParameters: query));
    print("RESPONSE: $response");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> customers = jsonResponse['success'];
        return customers
            .map((customerData) => Customer.fromJson(customerData))
            .toList();
      } else {
        throw Exception('Failed to load top customers');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }
}
