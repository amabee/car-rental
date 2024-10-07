import 'package:car_rental_mobile/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'showroom_home.dart';
import 'my_bookings.dart';
import 'profile_page.dart';
import 'constants.dart';

class Showroom extends StatefulWidget {
  @override
  _ShowroomState createState() => _ShowroomState();
}

class _ShowroomState extends State<Showroom> {
  List<NavigationItem> navigationItems = getNavigationItemList();
  late NavigationItem selectedItem;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ShowroomHome(),
    const MyBookings(),
    const MyProfile(),
  ];

  @override
  void initState() {
    super.initState();
    selectedItem = navigationItems[0];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      selectedItem = navigationItems[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Car Rental App",
          style: GoogleFonts.mulish(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.logout,
              color: Colors.black,
              size: 28,
            ),
          )
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildNavigationItems(),
        ),
      ),
    );
  }

  List<Widget> buildNavigationItems() {
    List<Widget> list = [];
    for (var i = 0; i < navigationItems.length; i++) {
      list.add(buildNavigationItem(navigationItems[i], i));
    }
    return list;
  }

  Widget buildNavigationItem(NavigationItem item, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 50,
        child: Stack(
          children: <Widget>[
            selectedItem == item
                ? Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColorShadow,
                      ),
                    ),
                  )
                : Container(),
            Center(
              child: Icon(
                item.iconData,
                color: selectedItem == item ? kPrimaryColor : Colors.grey[400],
                size: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
