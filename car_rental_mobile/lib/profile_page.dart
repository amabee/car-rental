import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// User profile Model
class UserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String driverLicense;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.driverLicense,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['customer_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      driverLicense: json['driver_license'] ?? '',
    );
  }
}

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  Future<UserProfile?> fetchUserProfile() async {
    var userBox = Hive.box('userBox');
    int? customerId = userBox.get('customer_id');

    if (customerId == null) {
      throw Exception("Customer ID not found in Hive.");
    }

    var url =
        Uri.parse('http://192.168.56.1/car-rental_api/customer/process.php');
    final query = {
      "operation": "getUserProfile",
      "json": jsonEncode({"customer_id": customerId})
    };

    final response = await http.get(url.replace(queryParameters: query));

    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return UserProfile.fromJson(jsonResponse['success']);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserProfile?>(
        future: fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No profile found'));
          }

          final profile = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/camaro_0.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const Positioned(
                      bottom: -50,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage:
                              AssetImage('assets/images/profile.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Text(
                  '${profile.firstName} ${profile.lastName}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  profile.email,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 20),
                _buildInfoTile(Icons.email, 'Email Address', profile.email),
                _buildInfoTile(Icons.phone, 'Phone Number', profile.phone),
                _buildInfoTile(Icons.verified_user, 'Driver License',
                    profile.driverLicense),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: Icon(icon, size: 25, color: Colors.white),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
