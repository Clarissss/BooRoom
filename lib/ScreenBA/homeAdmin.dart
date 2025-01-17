import 'package:flutter/material.dart';
import 'manage_user.dart';
import 'manage_room.dart'; // Import halaman rooms
import 'manage_jadwal.dart'; // Import halaman schedules
import 'manage_prospek.dart'; // Import halaman prospective bookings

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.black, // Dark background for dark mode
        child: Stack(
          children: [
            // Decorative circles with spacing
            _buildDecorativeCircle(-39, -34, spacing: 0),
            _buildDecorativeCircle(56, -24, spacing: 30),
            _buildDecorativeCircle(150, -50, spacing: 60),
            _buildDecorativeCircle(-39, -34, isBottom: true, spacing: 0),
            _buildDecorativeCircle(56, -24, isBottom: true, spacing: 30),
            _buildDecorativeCircle(150, -50, isBottom: true, spacing: 60),
            _buildDecorativeCircle(100, 20, isLeft: true, spacing: 0),
            _buildDecorativeCircle(200, 40, isLeft: true, spacing: 30),
            _buildDecorativeCircle(300, 60, isLeft: true, spacing: 60),
            _buildDecorativeCircle(400, 20,
                isBottom: true, isLeft: true, spacing: 0),
            _buildDecorativeCircle(500, 40,
                isBottom: true, isLeft: true, spacing: 30),
            _buildDecorativeCircle(-50, -34,
                isBottom: true, isLeft: true, spacing: 0),
            _buildDecorativeCircle(70, -24,
                isBottom: true, isLeft: true, spacing: 30),
            _buildDecorativeCircle(250, 50,
                isBottom: true, isLeft: true, spacing: 60),

            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      fontFamily: 'Jaro',
                      color: Colors.white, // Light text for dark mode
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Scrollable Metrics Row
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildMetricBox('Total Users', Icons.people),
                      const SizedBox(width: 15),
                      _buildMetricBox('Total Rooms', Icons.meeting_room),
                      const SizedBox(width: 15),
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
                        _buildManageCard(
                            context, 'Manage Users', Icons.people, UserPage()),
                        _buildManageCard(context, 'Manage Rooms',
                            Icons.meeting_room, RoomPage()),
                        _buildManageCard(context, 'Data Booking',
                            Icons.assignment, JadwalPage(userData: '')),
                        _buildManageCard(context, 'Data Prospective',
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
        child: Icon(Icons.logout,
            color: Colors.white), // Ubah warna ikon menjadi putih
        backgroundColor: Colors.redAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, 'login_screen');
  }

  Widget _buildDecorativeCircle(double top, double position,
      {bool isBottom = false, bool isLeft = false, double spacing = 0}) {
    return Positioned(
      top: isBottom ? null : top + spacing,
      bottom: isBottom ? top + spacing : null,
      left: isLeft ? position + spacing : null,
      right: isLeft ? null : position + spacing,
      child: Container(
        width: 131,
        height: 131,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              Colors.cyan[700]?.withOpacity(0.5), // Softer color for dark mode
        ),
      ),
    );
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
