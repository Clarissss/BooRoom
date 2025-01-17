import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bookingroom/utils/booking_model.dart';
import 'package:bookingroom/utils/restApi.dart';
import 'package:bookingroom/utils/config.dart';
import 'navigation_bar.dart';

class SchedulePage extends StatefulWidget {
  final String userData;

  const SchedulePage({Key? key, required this.userData}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
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
      String response = await DataService().selectAll(token, project, 'booking', appid);
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
        final matchesRoom = _selectedRoom == null || booking.room == _selectedRoom;
        final matchesDate = _selectedDate == null || booking.date == _selectedDate!.toIso8601String().split('T').first;
        final matchesSearch = searchQuery.isEmpty || booking.desc.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesRoom && matchesDate && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchBookings,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Search by description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        _filterBookings();
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedRoom,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.meeting_room),
                            labelText: 'Room',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: bookings.map((booking) => booking.room).toSet().map((room) {
                            return DropdownMenuItem<String>(
                              value: room,
                              child: Text(room),
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
                              prefixIcon: Icon(Icons.date_range),
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'
                                  : 'Select a date',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            leading: Icon(Icons.event, color: Colors.cyan),
                            title: Text(booking.desc, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: ${booking.date}'),
                                Text('Start Time: ${booking.start_time}'),
                                Text('End Time: ${booking.end_time}'),
                                Text('Room: ${booking.room}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: 1,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        userData: widget.userData,
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
}
