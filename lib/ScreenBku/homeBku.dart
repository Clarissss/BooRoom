import 'package:flutter/material.dart';

import 'manage_jadwal.dart'; // Import halaman schedules
import 'manage_prospek.dart'; // Import halaman prospective bookings

class BkuDashboard extends StatelessWidget {
  const BkuDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.black, // Dark background for dark mode
        child: Stack(
          children: [
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'BKU Dashboard',
                    style: TextStyle(
                      fontFamily: 'Jaro',
                      color: Colors.white, // Light text for dark mode
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Centered Metrics Row
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMetricBox('Total Bookings', Icons.assignment),
                      const SizedBox(width: 15),
                      _buildMetricBox('Total Prospects', Icons.schedule),
                    ],
                  ),
                ),

                // Manage Metrics Grid
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 75),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: [
                        _buildManageCard(context, 'Manage Jadwal',
                            Icons.assignment, JadwalPage()),
                        _buildManageCard(context, 'Manage Prospek',
                            Icons.schedule, ProspectPage()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _logout(context);
        },
        child: Icon(Icons.logout),
        backgroundColor: Colors.redAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, 'login_screen');
  }

  Widget _buildMetricBox(String title, IconData icon) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[850], // Dark card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.cyan[300]), // Light icon color
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Jaro',
                fontSize: 18,
                color: Colors.white, // Light text color
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageCard(
      BuildContext context, String title, IconData icon, Widget navigateTo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850], // Dark card background
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.cyan[300]), // Light icon color
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Jaro',
                  fontSize: 18,
                  color: Colors.white, // Light text color
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
