import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:car_rental_mobile/constants.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class PaymentDialog extends StatefulWidget {
  final int carID;
  final String dateTimeStart;
  final String dateTimeEnd;
  final double totalPrice;
  final VoidCallback onBookingSuccess;

  PaymentDialog({
    required this.totalPrice,
    required this.carID,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.onBookingSuccess,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String? selectedPaymentMethod;
  final List<String> paymentMethods = [
    'Credit Card',
    'PayPal',
    'Bank Transfer',
  ];

  late Box userBox;
  int? customerId;

  @override
  void initState() {
    super.initState();
    openUserBox();
  }

  Future<void> openUserBox() async {
    userBox = await Hive.openBox('userBox');
    customerId = userBox.get('customer_id');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Payment",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Total Amount: PHP ${widget.totalPrice.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Select Payment Method:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: paymentMethods.map((method) {
              return RadioListTile<String>(
                title: Text(method),
                value: method,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDialogButton("Cancel", Colors.grey[300]!, Colors.black, () {
                Navigator.of(context).pop();
              }),
              _buildDialogButton("Pay Now", kPrimaryColor, Colors.white, () {
                if (selectedPaymentMethod != null) {
                  if (customerId != null) {
                    bookCar(
                      context,
                      widget.carID,
                      customerId!,
                      widget.dateTimeStart,
                      widget.dateTimeEnd,
                      widget.totalPrice,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Customer ID not found!')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a payment method')),
                  );
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  void bookCar(BuildContext context, int carID, int customerID,
      String dateTimeStart, String dateTimeEnd, double totalPrice) async {
    var link = "http://192.168.56.1/car-rental_api/customer/process.php";

    try {
      final jsonData = {
        "car_id": carID,
        "customer_id": customerID,
        "rental_start": dateTimeStart,
        "rental_end": dateTimeEnd,
        "total_price": totalPrice,
        "status": "confirmed",
        "booking_source": "online"
      };
      final query = {
        "operation": "createBooking",
        "json": jsonEncode(jsonData)
      };

      final response =
          await http.get(Uri.parse(link).replace(queryParameters: query));

      var result = jsonDecode(response.body);
      if (result['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Something went wrong renting the car.')),
        );
      } else {
        widget.onBookingSuccess(); // Call the callback on successful booking
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully Rented the car!')),
        );
      }

      Navigator.of(context).pop();
    } catch (error) {
      print(error);
    }
  }

  Widget _buildDialogButton(
      String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
