import 'home.dart';
import 'package:flutter/material.dart';
import 'schedule.dart';
import 'history.dart';
import 'profile.dart'; // Import ProfilePage

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String userData; // Add userData parameter

  const CustomNavigationBar({
    Key? key,
    this.selectedIndex = 0,
    required this.onItemSelected,
    required this.userData, // Require userData
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 51,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home, 'Home', context),
          _buildNavItem(1, Icons.calendar_today, 'Schedules', context),
          _buildNavItem(2, Icons.history, 'History', context),
          _buildNavItem(3, Icons.person, 'Profile', context),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, BuildContext context) {
    final bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        if (index == 0) {
          // Navigate to HomePage when "Home" is tapped
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(userData: userData,)),
            (Route<dynamic> route) => false, // Removes all previous routes
          );
        } else if (index == 1) {
          // Navigate to SchedulePage when "Schedules" is tapped
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SchedulePage(userData: userData,)),
            (Route<dynamic> route) => false, // Removes all previous routes
          );
        } else if (index == 2) {
          // Navigate to HistoryPage when "History" is tapped
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HistoryPage(userData: userData,)),
            (Route<dynamic> route) => false, // Removes all previous routes
          );
        } else if (index == 3) {
          // Navigate to ProfilePage when "Profile" is tapped
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(userData: userData)), // Pass userData here
            (Route<dynamic> route) => false, // Removes all previous routes
          );
        } else {
          onItemSelected(index);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}