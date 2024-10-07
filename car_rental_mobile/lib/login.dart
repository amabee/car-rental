import 'package:car_rental_mobile/showroom.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarLoginSignupPage extends StatefulWidget {
  @override
  _CarLoginSignupPageState createState() => _CarLoginSignupPageState();
}

class _CarLoginSignupPageState extends State<CarLoginSignupPage> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.network(
            'https://images.unsplash.com/photo-1484136063621-1acbc3b4ec98?q=80&w=1653&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const Icon(
                      Icons.directions_car,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Anster Car Rental',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Form
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              _isLogin ? 'Login' : 'Sign Up',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (!_isLogin) ...[
                              // First Name Field
                              TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  hintText: 'Firstname',
                                  prefixIcon: const Icon(Icons.person,
                                      color: Colors.black54),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your firstname';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              // Last Name Field
                              TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  hintText: 'Lastname',
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.black54),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your lastname';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              // License Number Field
                              TextFormField(
                                controller: _licenseController,
                                decoration: InputDecoration(
                                  hintText: 'License Number',
                                  prefixIcon: Icon(Icons.credit_card,
                                      color: Colors.black54),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your license number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              // Phone Number Field
                              TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  prefixIcon:
                                      Icon(Icons.phone, color: Colors.black54),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                filled: true,
                                fillColor: Colors.white70,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                filled: true,
                                fillColor: Colors.white70,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue[800],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                _isLogin ? 'Login' : 'Sign Up',
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_isLogin) {
                                    login(context, _emailController.text,
                                        _passwordController.text);
                                  } else {
                                    signup(
                                      context,
                                      _firstNameController.text,
                                      _lastNameController.text,
                                      _emailController.text,
                                      _phoneController.text,
                                      _licenseController.text,
                                      _passwordController.text,
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin =
                              !_isLogin; // Toggle between login and signup
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Don\'t have an account? Sign Up'
                            : 'Already have an account? Login',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login(BuildContext context, String email, String password) async {
    var link = "http://192.168.56.1/car-rental_api/customer/auth.php";
    const String userBox = 'userBox';
    try {
      final jsonData = {
        "email": email,
        "password": password,
      };
      final query = {"operation": "login", "json": jsonEncode(jsonData)};

      final response =
          await http.get(Uri.parse(link).replace(queryParameters: query));

      var result = jsonDecode(response.body);
      print(result);
      if (result['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error']),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // Save customer_id to Hive
        var customerId = result['customer_id'];
        var box = await Hive.openBox(userBox);
        await box.put('customer_id', customerId);

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => Showroom(),
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  void signup(BuildContext context, String firstName, String lastName,
      String email, String phone, String license, String password) async {
    var link = "http://192.168.56.1/car-rental_api/customer/auth.php";

    try {
      final jsonData = {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "driver_license": license,
        "password": password,
      };
      final query = {"operation": "signup", "json": jsonEncode(jsonData)};

      final response =
          await http.get(Uri.parse(link).replace(queryParameters: query));

      var result = jsonDecode(response.body);
      if (result['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error']),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Showroom(),
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }
}
