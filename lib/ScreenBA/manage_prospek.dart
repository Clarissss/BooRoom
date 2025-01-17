import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bookingroom/utils/pending_model.dart';
import 'package:bookingroom/utils/restApi.dart';
import 'package:bookingroom/utils/config.dart';
import 'package:bookingroom/utils/booking_model.dart';

class ProspectPage extends StatefulWidget {
  @override
  _ProspectPageState createState() => _ProspectPageState();
}

class _ProspectPageState extends State<ProspectPage> {
  List<PendingBookingModel> _prospects = [];
  List<BookingModel> _bookings = [];
  List<PendingBookingModel> _filteredProspects = [];
  String _selectedStatusFilter = 'All';
  String _selectedDateFilter = 'Newest';
  int _currentPage = 0;
  final int _itemsPerPage = 7;

  DataService ds = DataService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      selectAllSchedule(),
      selectAllBooking(),
    ]);
  }

  Future<void> selectAllSchedule() async {
    try {
      String response =
          await ds.selectAll(token, project, 'pending_booking', appid);
      List<dynamic> data = jsonDecode(response);
      setState(() {
        _prospects = data.map((e) => PendingBookingModel.fromJson(e)).toList();
        _filteredProspects = List.from(_prospects);
      });
      _applyFilters(); // Apply filters after loading data
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> selectAllBooking() async {
    try {
      String response = await ds.selectAll(token, project, 'booking', appid);
      List<dynamic> data = jsonDecode(response);
      setState(() {
        _bookings = data.map((e) => BookingModel.fromJson(e)).toList();
      });
    } catch (error) {
      print('Error fetching booking data: $error');
    }
  }

  void _applyFilters() {
    _filteredProspects = _prospects.where((prospect) {
      bool matchesStatus = _selectedStatusFilter == 'All' ||
          prospect.status.toLowerCase() == _selectedStatusFilter.toLowerCase();
      return matchesStatus;
    }).toList();

    // Sort by date based on the selected filter
    if (_selectedDateFilter == 'Newest') {
      _filteredProspects.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    } else {
      _filteredProspects.sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    }

    setState(() {});
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: _selectedStatusFilter,
              dropdownColor: Colors.grey[800],
              style: TextStyle(color: Colors.white),
              isExpanded: true,
              underline: SizedBox(),
              items: [
                DropdownMenuItem(child: Text('All'), value: 'All'),
                DropdownMenuItem(child: Text('Pending'), value: 'Pending'),
                DropdownMenuItem(child: Text('Approved'), value: 'Approved'),
                DropdownMenuItem(child: Text('Canceled'), value: 'Canceled'),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatusFilter = value!;
                  _applyFilters();
                });
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedDateFilter,
              dropdownColor: Colors.grey[800],
              style: TextStyle(color: Colors.white),
              isExpanded: true,
              underline: SizedBox(),
              items: [
                DropdownMenuItem(child: Text('Newest'), value: 'Newest'),
                DropdownMenuItem(child: Text('Oldest'), value: 'Oldest'),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDateFilter = value!;
                  _applyFilters();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    int pageCount = (_filteredProspects.length / _itemsPerPage).ceil();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed:
                _currentPage > 0 ? () => setState(() => _currentPage--) : null,
            color: _currentPage > 0 ? Colors.white : Colors.grey,
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Page ${_currentPage + 1} of $pageCount',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: _currentPage < pageCount - 1
                ? () => setState(() => _currentPage++)
                : null,
            color: _currentPage < pageCount - 1 ? Colors.white : Colors.grey,
          ),
        ],
      ),
    );
  }

  BookingModel? findMatchingBooking(PendingBookingModel prospect) {
    try {
      return _bookings.firstWhere(
        (booking) =>
            booking.date == prospect.date &&
            booking.start_time == prospect.start_time &&
            booking.end_time == prospect.end_time &&
            booking.room == prospect.room &&
            booking.user == prospect.user,
      );
    } catch (e) {
      print('No matching booking found: $e');
      return null;
    }
  }

  void _showDetailDialog(PendingBookingModel prospect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Detail Booking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildDetailRow('Date:', prospect.date),
                _buildDetailRow('Start Time:', prospect.start_time),
                _buildDetailRow('End Time:', prospect.end_time),
                _buildDetailRow('Status:', prospect.status),
                _buildDetailRow('Description:', prospect.desc),
                _buildDetailRow('Room:', prospect.room),
                _buildDetailRow('Capacity:', prospect.capacity.toString()),
                _buildDetailRow('User:', prospect.user),
                SizedBox(height: 16),
                if (prospect.status != 'Approved' &&
                    prospect.status != 'Canceled')
                  _buildStatusDropdown(prospect),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(PendingBookingModel prospect) {
    return DropdownButton<String>(
      value: prospect.status,
      dropdownColor: Colors.grey[800],
      style: TextStyle(color: Colors.white),
      items: <String>['Pending', 'Approved', 'Canceled']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          if (newValue == 'Canceled') {
            _showCancelDialog(prospect);
          } else {
            _updateStatus(_prospects.indexOf(prospect), newValue);
            Navigator.of(context).pop();
          }
        }
      },
    );
  }

  void _showCancelDialog(PendingBookingModel prospect) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cancel Booking',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: TextField(
                    controller: reasonController,
                    style: TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Please provide a reason for cancellation...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Colors.red[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (reasonController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please provide a reason for cancellation'),
                              backgroundColor: Colors.red[400],
                            ),
                          );
                          return;
                        }
                        _updateStatus(
                          _prospects.indexOf(prospect),
                          'Canceled',
                          reason: reasonController.text,
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateStatus(int index, String newStatus, {String reason = ''}) async {
    String updateField = 'status';
    String updateValue = newStatus;
    String id = _prospects[index].id;
    String user = _prospects[index].user;
    String notifikasiGagal = 'Booking Canceled';
    String notifikasiSukses = 'Booking Approved';
    String statCancel = 'Rejected By BA';
    String statApprove = 'Approved by BA';
    String statusField = 'stat3';
    String statusValue2 = statApprove;
    String statusValue = statCancel;

    try {
      BookingModel? matchingBooking = findMatchingBooking(_prospects[index]);

      if (matchingBooking == null) {
        print('No matching booking found for prospect');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: No matching booking found')),
        );
        return;
      }

      bool success = await ds.updateId(
        updateField,
        newStatus,
        token,
        project,
        'pending_booking',
        appid,
        id,
      );

      if (success) {
        if (newStatus == 'Approved') {
          await ds.updateId(
            statusField,
            statusValue2,
            token,
            project,
            'booking',
            appid,
            matchingBooking.id,
          );
          await ds.updateId(
            updateField,
            updateValue,
            token,
            project,
            'booking',
            appid,
            matchingBooking.id,
          );
          await ds.insertNotifikasi(
            appid,
            user,
            '',
            notifikasiSukses,
          );
        } else if (newStatus == 'Canceled') {
          await ds.updateId(
            statusField,
            statusValue,
            token,
            project,
            'booking',
            appid,
            matchingBooking.id,
          );
          await ds.updateId(
            updateField,
            updateValue,
            token,
            project,
            'booking',
            appid,
            matchingBooking.id,
          );
          await ds.insertNotifikasi(
            appid,
            user,
            reason,
            notifikasiGagal,
          );
        }

        setState(() {
          _prospects[index].status = newStatus;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status')),
        );
      }
    } catch (e) {
      print('Error in _updateStatus: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int itemCount =
        (_currentPage + 1) * _itemsPerPage > _filteredProspects.length
            ? _filteredProspects.length - _currentPage * _itemsPerPage
            : _itemsPerPage;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                color: Colors.black,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Manage Booking BA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildFilterOptions(), // Filter options
                      Expanded(
                        child: ListView.builder(
                          itemCount: itemCount,
                          itemBuilder: (context, index) {
                            final prospect = _filteredProspects[
                                index + _currentPage * _itemsPerPage];
                            return Card(
                              color: Colors.grey[850],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                title: Text(prospect.date,
                                    style: TextStyle(color: Colors.white)),
                                subtitle: Text(prospect.user,
                                    style: TextStyle(color: Colors.white)),
                                onTap: () => _showDetailDialog(prospect),
                                trailing: Icon(Icons.chevron_right,
                                    color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                      _buildPagination(), // Pagination controls
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'admin_screen');
              },
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
