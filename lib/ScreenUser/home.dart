import 'dart:convert';
import 'package:bookingroom/ScreenBA/manage_room.dart';
import 'package:flutter/material.dart';
import 'booking_form.dart';
import 'navigation_bar.dart';
import 'room_selection_card.dart';
import 'package:bookingroom/utils/pending_model.dart';
import 'package:bookingroom/utils/restApi.dart';
import 'package:bookingroom/utils/config.dart';
import 'package:bookingroom/utils/notifikasi_model.dart';

class HomeScreen extends StatefulWidget {
  final String userData;

  const HomeScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late String userName;
  List<NotifikasiModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNotifications();
  }

  Widget _buildConfirmationDetail(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.cyan[700]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadNotifications() async {
    try {
      String token = '675bbd40f853312de55091c5';
      String project = 'uas';
      String collection = 'notifikasi';
      String appid = '675dc0a8f853312de550921e';
      String whereField = 'user';

      List<dynamic> userDataJson = [];
      try {
        userDataJson = jsonDecode(widget.userData);
      } catch (e) {
        print('Error decoding userData: $e');
        return;
      }

      if (userDataJson.isEmpty || !(userDataJson[0] is Map) || !userDataJson[0].containsKey('name')) {
        print('Error: Invalid userData format or missing name field');
        return;
      }

      String whereValue = userDataJson[0]['name'];
      if (whereValue.isEmpty) {
        print('Error: username is empty');
        return;
      }

      DataService ds = DataService();

      String? response = await ds.selectWhere(token, project, collection, appid, whereField, whereValue);

      if (response == null || response.isEmpty) {
        print('No notifications found or empty response');
        setState(() {
          notifications = [];
        });
        return;
      }

      List<dynamic> data;
      try {
        data = jsonDecode(response);
      } catch (e) {
        print('Error parsing notification data: $e');
        return;
      }

      setState(() {
        notifications = data.map((e) => NotifikasiModel(
          id: e['id']?.toString() ?? '',
          title: e['title']?.toString() ?? 'No Title',
          reason: e['reason']?.toString() ?? 'No Reason',
          user: e['user']?.toString() ?? ''
        )).toList();
      });

      print('Successfully loaded ${notifications.length} notifications');
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        notifications = [];
      });
    }
  }

  void _loadUserData() {
    try {
      if (widget.userData.isEmpty) {
        print("userData is empty!");
        userName = 'User';
        return;
      }

      print("Raw userData: ${widget.userData}");

      final List<dynamic> userArray = jsonDecode(widget.userData);
      print("Decoded userArray: $userArray");

      if (userArray.isNotEmpty && userArray[0] is Map<String, dynamic>) {
        final user = userArray[0] as Map<String, dynamic>;
        userName = user['name'] ?? 'User';
      } else {
        print("userArray is empty or invalid!");
        userName = 'User';
      }
    } catch (e) {
      print("Error decoding userData: $e");
      userName = 'User';
    }
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NotificationDialog(
          notifications: notifications,
          userName: userName,
        );
      },
    );
  }

void _showBookingFormDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(dialogContext).size.height * 0.8),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking Ruanganmu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: BookingForm(
                      userData: widget.userData,
                      onSubmit: (formData) async {
                        final innerContext = dialogContext;

                        // Show confirmation dialog first
                        showDialog(
                          context: innerContext,
                          barrierDismissible: false,
                          builder: (BuildContext confirmationContext) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.cyan.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 48,
                                            color: Colors.cyan[700],
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Konfirmasi Booking',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.cyan[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    _buildConfirmationDetail('Room', formData['room'] ?? '', Icons.meeting_room),
                                    _buildConfirmationDetail('Date', formData['date'] ?? '', Icons.calendar_today),
                                    _buildConfirmationDetail('Start Time', formData['start_time'] ?? '', Icons.access_time),
                                    _buildConfirmationDetail('End Time', formData['end_time'] ?? '', Icons.access_time_filled),
                                    _buildConfirmationDetail('Capacity', formData['capacity'] ?? '', Icons.people),
                                    _buildConfirmationDetail('Description', formData['desc'] ?? '', Icons.description),
                                    SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(confirmationContext),
                                          child: Text('Cancel'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.grey[600],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(confirmationContext); // Close confirmation dialog
                                            try {
                                              final user = userName;

                                              bool isAvailable = await checkRoomAvailability(
                                                formData['room'],
                                                formData['date'],
                                                formData['start_time'],
                                              );

                                              if (!isAvailable) {
                                                if (innerContext.mounted) {
                                                  ScaffoldMessenger.of(innerContext).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Room ${formData['room']} is already booked!",
                                                      ),
                                                      backgroundColor: Colors.red,
                                                      duration: Duration(seconds: 3),
                                                    ),
                                                  );
                                                }
                                                return;
                                              }

                                              DataService ds = DataService();
                                              List response = jsonDecode(await ds.insertPendingBookingProdi(
                                                appid,
                                                formData['date'],
                                                formData['start_time'],
                                                formData['end_time'],
                                                formData['status'],
                                                formData['desc'],
                                                formData['room'],
                                                formData['capacity'],
                                                user,
                                              ));

                                              if (response.isNotEmpty) {
                                                Navigator.of(innerContext).pop(); // Close dialog
                                                if (innerContext.mounted) {
                                                  ScaffoldMessenger.of(innerContext).showSnackBar(
                                                    SnackBar(
                                                      content: Text("Booking saved successfully!"),
                                                      backgroundColor: Colors.green,
                                                      duration: Duration(seconds: 3),
                                                    ),
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => HomeScreen(userData: widget.userData),
                                                    ),
                                                  );
                                                }
                                              }
                                            } catch (e) {
                                              print("Error: $e");
                                            }
                                          },
                                          child: Text('Confirm Booking'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.cyan[700],
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  

  int get _unreadNotificationCount {
    return notifications.length;
  }

  Future<bool> checkRoomAvailability(String room, String date, String startTime) async {
    try {
      DataService ds = DataService();
      final response = await ds.selectAll(token, project, 'pending_booking_prodi', appid);
      if (response != null) {
        final List bookingData = jsonDecode(response);
        List<PendingBookingModel> bookings =
            bookingData.map((e) => PendingBookingModel.fromJson(e)).toList();

        bool isBooked = bookings.any((booking) =>
            booking.room == room &&
            booking.date == date &&
            booking.start_time == startTime &&
            booking.status != 'cancelled');

        return !isBooked;
      }
      return true;
    } catch (e) {
      print("Error checking bookings: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.cyan,
            child: Stack(
              children: [
                Positioned(
                  left: -90,
                  top: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFF0BA8C7),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: -50,
                  bottom: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFF0BA8C7),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: -50,
                  top: 100,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFF0BA8C7),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome, $userName to building 4\nWhich room do you want to use?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: NotificationBadge(
                          count: _unreadNotificationCount,
                          onTap: _showNotificationDialog,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  color: Color(0xFFF8F8F8),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showBookingFormDialog,
                        icon: Icon(Icons.add),
                        label: Text('Book a Room'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'ROOM',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: 
                              RoomSelectionCard(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        userData: widget.userData,
      ),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const NotificationBadge({Key? key, required this.count, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications,
            color: Colors.white,
            size: 30,
          ),
          if (count > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NotificationDialog extends StatefulWidget {
  final List<NotifikasiModel> notifications;
  final String userName;

  const NotificationDialog({
    Key? key,
    required this.notifications,
    required this.userName,
  }) : super(key: key);

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  late List<NotifikasiModel> notifications;

  @override
  void initState() {
    super.initState();
    notifications = widget.notifications;
  }

  Future<void> _deleteAllNotifications() async {
    try {
      String token = '675bbd40f853312de55091c5';
      String project = 'uas';
      String collection = 'notifikasi';
      String appid = '675dc0a8f853312de550921e';
      String whereField = 'user';
      String whereValue = widget.userName;

      DataService ds = DataService();
      bool success = await ds.removeWhere(token, project, collection, appid, whereField, whereValue);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("All notifications deleted successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        await _loadNotifications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete notifications!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error deleting notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting notifications!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _loadNotifications() async {
    try {
      String token = '675bbd40f853312de55091c5';
      String project = 'uas';
      String collection = 'notifikasi';
      String appid = '675dc0a8f853312de550921e';
      String whereField = 'user';
      String whereValue = widget.userName;

      DataService ds = DataService();
      String? response = await ds.selectWhere(token, project, collection, appid, whereField, whereValue);

      if (response != null && response.isNotEmpty) {
        List<dynamic> data = jsonDecode(response);
        setState(() {
          notifications = data.map((e) => NotifikasiModel(
            id: e['id']?.toString() ?? '',
            title: e['title']?.toString() ?? 'No Title',
            reason: e['reason']?.toString() ?? 'No Reason',
            user: e['user']?.toString() ?? ''
          )).toList();
        });
      } else {
        setState(() {
          notifications = [];
        });
      }
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        notifications = [];
      });
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    }else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: notifications.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationItem(
                    title: notification.title,
                    message: notification.reason,
                    timestamp: DateTime.now().subtract(Duration(hours: index)),
                    userName: widget.userName,
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _deleteAllNotifications,
              child: Text('Delete All Notifications'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final DateTime timestamp;
  final String userName;

  const NotificationItem({
    Key? key,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.userName,
  }) : super(key: key);

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

    String _getNotificationMessage() {
    if (title == 'Booking Approved') {
      return 'Halo kak $userName, Bookingmu sudah disetujui nih, siap siap ya!';
    } else {
      return 'Halo kak $userName, Bookingmu ditolak nih karena $message';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Add notification tap handling here
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.only(top: 6, right: 12),
              decoration: BoxDecoration(
                color: Colors.cyan,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        _getTimeAgo(),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                   _getNotificationMessage(),
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
