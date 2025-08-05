import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:service_app/Location/map_page.dart';
import 'package:service_app/Posting_Village/home_village.dart';
import 'package:service_app/model/Screens_home/acccount_screen.dart';
import 'package:service_app/model/Screens_home/explore_screen.dart';
import 'package:service_app/model/Screens_home/inbox.dart';
import 'package:service_app/model/Screens_home/post.dart';
import 'package:service_app/model/Screens_home/saved.dart';
import 'package:service_app/views/Host_Screens/booking.dart';
import 'package:service_app/views/Host_Screens/my_poasting_screen.dart';

class HostHomeScreen extends StatefulWidget {
  int? Index;

  HostHomeScreen({super.key, this.Index});

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}

class _HostHomeScreenState extends State<HostHomeScreen> {
  int _selectedIndex = 0;

  final List<String> _screenTitles = [
    'Home',
    'Saved',
    'Book',
    'Offers',
    'Profile',
  ];

  final List<Widget> _screens = [
   const HomePage(),
    const MyPoastingScreen(),
     Booking(),
    const Post(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.Index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFC9DEC8), Color(0xFF5C815E)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          _screenTitles[_selectedIndex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.favorite_border, "Saved", 1),
              _buildNavItem(Icons.work_outline, "Book", 2),
              Stack(
                children: [
                  _buildNavItem(Icons.percent, "Offers", 3),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
              _buildNavItem(Icons.person_outline, "Profile", 4),
            ],
          ),
        ),
      ),
    );
  }

  /// Build each nav item (icon + optional label when selected)
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26, // increased icon size of bottom navigation

              color: isSelected ? Colors.purple : Colors.black,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
