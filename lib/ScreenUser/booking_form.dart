import 'dart:convert';
import 'package:bookingroom/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:bookingroom/utils/restApi.dart';
import 'schedule.dart';
import 'package:bookingroom/utils/room_model.dart';

class BookingForm extends StatefulWidget {
  final String initialRoom;
  final DateTime? initialDate;
  final String initialCapacity;
  final String initialDescription;
  final String userData;
  final Function(Map<String, dynamic>)? onSubmit;

  const BookingForm({
    Key? key,
    this.initialRoom = '',
    this.initialDate,
    this.initialCapacity = '50',
    this.initialDescription = 'Meeting',
    required this.userData,
    this.onSubmit,
  }) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  late String _selectedRoom;
  late DateTime _selectedDate;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  late TextEditingController _capacityController;
  late TextEditingController _descriptionController;

  final List<String> _rooms = [];
  final DataService ds = DataService();

  @override
  void initState() {
    super.initState();
    _selectedRoom = widget.initialRoom;
    _selectedDate = widget.initialDate ?? DateTime.now();
    _capacityController = TextEditingController(text: widget.initialCapacity);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _selectedStartTime = TimeOfDay.fromDateTime(_selectedDate);
    _selectedEndTime = TimeOfDay.fromDateTime(_selectedDate.add(const Duration(hours: 1)));
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    String response = await ds.selectAll(token, project, 'room', appid);
    List<dynamic> data = jsonDecode(response);

    setState(() {
      _rooms.addAll(data.map((room) => RoomModel.fromJson(room).name).toList());
      if (_rooms.isNotEmpty) {
        _selectedRoom = _rooms.first;
      }
    });
  }

  @override
  void dispose() {
    _capacityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.cyan,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.cyan,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.cyan,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedStartDateTime =
    '${_selectedStartTime.hour}:${_selectedStartTime.minute.toString().padLeft(2, '0')}';
String selectedEndDateTime =
    '${_selectedEndTime.hour}:${_selectedEndTime.minute.toString().padLeft(2, '0')}';


    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Room Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedRoom,
              decoration: InputDecoration(
                labelText: 'Select Room',
                labelStyle: TextStyle(color: Colors.cyan),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: _rooms.map((String room) {
                return DropdownMenuItem<String>(
                  value: room,
                  child: Text(room),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRoom = newValue!;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Date & Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.cyan, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectStartTime(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Time',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.cyan, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '${_selectedStartTime.hour}:${_selectedStartTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectEndTime(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Time',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.cyan, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '${_selectedEndTime.hour}:${_selectedEndTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SchedulePage(userData: widget.userData),
                ),
              );
            },
            icon: Icon(Icons.schedule),
            label: Text('View Room Schedule'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.cyan,
              minimumSize: Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Additional Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _capacityController,
            decoration: InputDecoration(
              labelText: 'Capacity (Persons)',
              labelStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.people, color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.description, color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (widget.onSubmit != null) {
                  widget.onSubmit!({
                    'date': '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                    'start_time': selectedStartDateTime,
                    'end_time': selectedEndDateTime,
                    'status': 'Pending',
                    'desc': _descriptionController.text,
                    'room': _selectedRoom,
                    'capacity': _capacityController.text,
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.cyan,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Submit Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}