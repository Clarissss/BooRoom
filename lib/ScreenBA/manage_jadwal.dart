import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bookingroom/utils/booking_model.dart';
import 'package:bookingroom/utils/restApi.dart';
import 'package:bookingroom/utils/config.dart';

class JadwalPage extends StatefulWidget {
  final String userData;

  const JadwalPage({Key? key, required this.userData}) : super(key: key);

  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  List<BookingModel> bookings = [];
  List<BookingModel> filteredBookings = [];
  String searchQuery = '';
  String? _selectedRoom;
  DateTime? _selectedDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      String response =
          await DataService().selectAll(token, project, 'booking', appid);
      List<dynamic> data = jsonDecode(response);
      setState(() {
        bookings = data.map((e) => BookingModel.fromJson(e)).toList();
        filteredBookings = bookings;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching bookings: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterBookings() {
    setState(() {
      filteredBookings = bookings.where((booking) {
        final matchesRoom =
            _selectedRoom == null || booking.room == _selectedRoom;
        final matchesDate = _selectedDate == null ||
            booking.date == _selectedDate!.toIso8601String().split('T').first;
        final matchesSearch = searchQuery.isEmpty ||
            booking.desc.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesRoom && matchesDate && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Stack(
                        children: [
                          ...decorativeCircles(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Data Schedules',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Search Bar
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.cyan[700]!, width: 1),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by description...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.cyan[700]),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                            _filterBookings();
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    // Room Filter
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedRoom,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.meeting_room,
                                  color: Colors.cyan[700]),
                              labelText: 'Room',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.cyan[700]!),
                              ),
                              filled: true,
                              fillColor: Colors.grey[850],
                            ),
                            items: bookings
                                .map((booking) => booking.room)
                                .toSet()
                                .map((room) {
                              return DropdownMenuItem<String>(
                                value: room,
                                child: Text(room,
                                    style: TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRoom = newValue;
                                _filterBookings();
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.date_range,
                                    color: Colors.cyan[700]),
                                labelText: 'Date',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.cyan[700]!),
                                ),
                                filled: true,
                                fillColor: Colors.grey[850],
                              ),
                              child: Text(
                                _selectedDate != null
                                    ? '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'
                                    : 'Select a date',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: _fetchBookings,
                      tooltip: 'Refresh Data',
                    ),
                    // Booking List
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            color: Colors.grey[850],
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading:
                                  Icon(Icons.event, color: Colors.cyan[700]),
                              title: Text(booking.desc,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date: ${booking.date}',
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  Text('Start Time: ${booking.start_time}',
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  Text('End Time: ${booking.end_time}',
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  Text('Room: ${booking.room}',
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Floating Action Button in the bottom left corner
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigate back when pressed
                          },
                          backgroundColor: Colors.redAccent,
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _filterBookings();
      });
    }
  }

  List<Widget> decorativeCircles() {
    return [
      Positioned(
        left: -50,
        top: -50,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.cyan[700]?.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        right: -30,
        top: -30,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.cyan[600]?.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ];
  }
}
