import 'package:car_rental_mobile/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_mobile/constants.dart';
import 'package:car_rental_mobile/data.dart';
import 'package:intl/intl.dart';

class BookCar extends StatefulWidget {
  final Car car;

  BookCar({required this.car});

  @override
  _BookCarState createState() => _BookCarState();
}

class _BookCarState extends State<BookCar> {
  DateTime? startDate;
  DateTime? endDate;
  bool isBooked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  border: Border.all(
                                    color: Colors.grey[300] ?? Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.car.model,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.car.make,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Hero(
                            tag: widget.car.model,
                            child: Image.network(
                              widget.car.image,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildPricePerPeriod(
                              isBooked ? "Booked" : widget.car.status,
                              widget.car.price.toString(),
                              true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        "SPECIFICATIONS",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(top: 8, left: 16),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildSpecificationCar(
                            "Condition",
                            toBeginningOfSentenceCase(
                                isBooked ? "Booked" : widget.car.status),
                          ),
                          buildSpecificationCar("Brand", widget.car.make),
                          buildSpecificationCar("Model", widget.car.model),
                          buildSpecificationCar(
                              "Year", widget.car.year.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isBooked ? "Booked" : widget.car.status,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "PHP ${widget.car.price}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "/ Day",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isBooked
                    ? Colors.orange
                    : widget.car.status == "available"
                        ? kPrimaryColor
                        : widget.car.status == "rented"
                            ? Colors.orange
                            : Colors.red,
                disabledBackgroundColor:
                    widget.car.status == "rented" ? Colors.orange : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: (widget.car.status == "available" && !isBooked)
                  ? () {
                      _showBookingDialog();
                    }
                  : null,
              child: Text(
                isBooked
                    ? "Booked"
                    : widget.car.status == "available"
                        ? "Book this car"
                        : widget.car.status == "rented"
                            ? "Rented"
                            : "Maintenance",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPricePerPeriod(String condition, String price, bool selected) {
    return Expanded(
      child: Container(
        height: 110,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(
            color: Colors.grey[300] ?? Colors.grey,
            width: selected ? 0 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              condition,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: Container()),
            Text(
              price,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "PHP",
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSpecificationCar(String title, String? data) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Text(
              data ?? "",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox(context, setState),
            );
          },
        );
      },
    );
  }

  Widget contentBox(BuildContext context, StateSetter setInnerState) {
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
            "Book ${widget.car.model}",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          _buildDateTimePicker(
            "Rental Start",
            startDate,
            (picked) {
              if (picked != null && picked != startDate) {
                setInnerState(() {
                  startDate = picked;
                  if (endDate == null || endDate!.isBefore(startDate!)) {
                    endDate = startDate!.add(Duration(hours: 1));
                  }
                });
              }
            },
            Icons.calendar_today,
          ),
          SizedBox(height: 15),
          _buildDateTimePicker(
            "Rental End",
            endDate,
            (picked) {
              if (picked != null && picked != endDate) {
                setInnerState(() {
                  endDate = picked;
                });
              }
            },
            Icons.event_available,
          ),
          SizedBox(height: 20),
          Text(
            "Total Price: ${_calculateTotalPrice()}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDialogButton("Cancel", Colors.grey[300]!, Colors.black, () {
                Navigator.of(context).pop();
              }),
              _buildDialogButton("Book", kPrimaryColor, Colors.white, () {
                if (_areDatesValidForBooking()) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentDialog(
                        carID: widget.car.id,
                        dateTimeStart: startDate.toString(),
                        dateTimeEnd: endDate.toString(),
                        totalPrice: _calculateTotalPriceValue(),
                        onBookingSuccess: () {
                          setState(() {
                            isBooked = true;
                          });
                        },
                      );
                    },
                  );
                } else {
                  _showInvalidDatesAlert();
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker(String title, DateTime? dateTime,
      Function(DateTime?) onPicked, IconData icon) {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: dateTime ?? DateTime.now(),
          firstDate: title.contains("Start")
              ? DateTime.now()
              : (startDate ?? DateTime.now()),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: kPrimaryColor,
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                colorScheme: ColorScheme.light(primary: kPrimaryColor)
                    .copyWith(secondary: kPrimaryColor),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(dateTime ?? DateTime.now()),
          );

          if (pickedTime != null) {
            final DateTime pickedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            onPicked(pickedDateTime);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  dateTime != null
                      ? DateFormat('MMM dd, yyyy HH:mm').format(dateTime)
                      : "Select date and time",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(icon, color: kPrimaryColor),
          ],
        ),
      ),
    );
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

  bool _areDatesValidForBooking() {
    return startDate != null &&
        endDate != null &&
        endDate!.isAfter(startDate!) &&
        startDate!.isAfter(DateTime.now().subtract(Duration(minutes: 1)));
  }

  void _showInvalidDatesAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Invalid Dates"),
          content: const Text(
              "Please select valid start and end dates/times for your booking."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalPriceValue() {
    if (startDate == null || endDate == null) {
      return 0;
    }
    double hours = endDate!.difference(startDate!).inMinutes / 60;
    return hours * (widget.car.price / 24); // Assuming price is per day
  }

  String _calculateTotalPrice() {
    if (startDate == null || endDate == null) {
      return "PHP 0";
    }
    double hours = endDate!.difference(startDate!).inMinutes / 60;
    double totalPrice =
        hours * (widget.car.price / 24); // Assuming price is per day
    return "PHP ${totalPrice.toStringAsFixed(2)}";
  }
}
