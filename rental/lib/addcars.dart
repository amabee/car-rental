import 'package:flutter/material.dart';
import 'package:rental/homepage.dart';
import 'package:rental/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Addcars extends StatefulWidget {
  final String accountId;
  final String userFullname;

  // const ContactList({Key? key}) : super(key: key);
  Addcars({
    required this.accountId,
    required this.userFullname,
  });

  @override
  _AddcarsState createState() => _AddcarsState();
}

class _AddcarsState extends State<Addcars> {
  TextEditingController _model = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  height: 200,
                  width: 200,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Anster Autoworks ',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Add Car Form",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _model,
                decoration: const InputDecoration(
                  labelText: "Model",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.car_rental),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _description,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.abc),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _price,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.price_check),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  // login();
                  save();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    const Text("Save"),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homepage(
                          accountId: widget.accountId,
                          userFullname: widget.userFullname),
                    ),
                  );
                },
                child: const Text(
                  "Go Back",
                  style: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void save() async {
    Uri url = Uri.parse('http://localhost/rental/lib/api/contacts.php');

    Map<String, dynamic> jsonData = {
      'accountId': widget.accountId.toString(),
      'model': _model.text,
      'description': _description.text,
      'price': _price.text,
    };

    Map<String, dynamic> data = {
      "operation": "addContacts",
      "json": jsonEncode(jsonData),
    };
    print(data);

    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      print(response.body);
      if (response.body == "1") {
        showMessageBox(
            context, "Success !", "You have success successfully registered");
        _model.clear();
        _description.clear();
        _price.clear();
      } else {
        // showMessageBox(context, "Ërror", "Registration Failed");
        showMessageBox(
            context, "Success !", "You have success successfully registered");
      }
    } else {
      showMessageBox(context, "Ërror",
          "The server returns a ${response.statusCode} error.");
    }
  }
}
