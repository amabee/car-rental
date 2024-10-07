import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Booking Model
class Booking {
  final int id;
  final String carName;
  final String startDate;
  final String endDate;
  final double totalAmount;
  final String status;

  Booking({
    required this.id,
    required this.carName,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['booking_id'] ?? 0,
      carName: "${json['make']} ${json['model']}",
      startDate: json['rental_start'] ?? '',
      endDate: json['rental_end'] ?? '',
      totalAmount: double.parse(json['total_price'].toString()),
      status: json['status'] ?? '',
    );
  }
}

class MyBookings extends StatelessWidget {
  const MyBookings({super.key});

  Future<List<Booking>> fetchMyBookings() async {
    var url =
        Uri.parse('http://192.168.56.1/car-rental_api/customer/process.php');
    final query = {
      "operation": "getMyBookings",
      "json": jsonEncode({"customer_id": 3})
    };

    final response = await http.get(url.replace(queryParameters: query));

    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> bookings = jsonResponse['success'];
        print(bookings);
        return bookings
            .map((bookingData) => Booking.fromJson(bookingData))
            .toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: FutureBuilder<List<Booking>>(
        future: fetchMyBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final booking = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.carName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Text(formatDateTime(booking.startDate)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(formatDateTime(booking.endDate))
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: \$${booking.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: booking.status.toLowerCase() == 'confirmed'
                                  ? Colors.green[100]
                                  : Colors.orange[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              booking.status,
                              style: TextStyle(
                                color:
                                    booking.status.toLowerCase() == 'confirmed'
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String formatDateTime(String dateTimeStr) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);

      String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
      String formattedTime = DateFormat('hh:mm a').format(dateTime);
      return "$formattedDate at $formattedTime";
    } catch (e) {
      return dateTimeStr;
    }
  }
}
