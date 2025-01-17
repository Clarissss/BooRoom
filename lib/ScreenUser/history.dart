import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'navigation_bar.dart';
import 'package:bookingroom/utils/booking_model.dart';
import 'package:bookingroom/utils/restApi.dart';
import 'package:bookingroom/utils/config.dart';

class HistoryPage extends StatefulWidget {
  final String userData;
  const HistoryPage({Key? key, required this.userData}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, String>> _history = [];
  final int _itemsPerPage = 5;
  int _currentPage = 0;
  DataService ds = DataService();
  bool isLoading = true;

  // Add status tracking variables
  int stat1 = 0; // Approved count
  int stat2 = 0; // Rejected count
  int stat3 = 0; // Pending count

  List<Map<String, String>> get _paginatedHistory {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _history.length) return [];
    return _history.sublist(startIndex, endIndex > _history.length ? _history.length : endIndex);
  }

  int get _pageCount => (_history.length / _itemsPerPage).ceil();

  void _updateStatusCounts() {
    stat1 = _history.where((booking) => booking['status']?.toLowerCase() == 'approved').length;
    stat2 = _history.where((booking) => booking['status']?.toLowerCase() == 'rejected').length;
    stat3 = _history.where((booking) => booking['status']?.toLowerCase() == 'pending').length;
  }

  Future<void> _fetchHistory() async {
    try {
      String token = '675bbd40f853312de55091c5';
      String project = 'uas';
      String collection = 'booking';
      String appid = '675dc0a8f853312de550921e';
      String where_field = 'user';
      List<dynamic> userDataJson = jsonDecode(widget.userData);
      String where_value = userDataJson[0]['name'];

      if (where_value.isEmpty) {
        print('Error: userData kosong!');
        return;
      }

      String response = await ds.selectWhere(token, project, collection, appid, where_field, where_value);

      if (response != '[]' && response.isNotEmpty) {
        List<dynamic> data = jsonDecode(response);
        setState(() {
          _history.clear();
_history.addAll(data.map((e) => {
  'room': (e['room'] ?? '').toString(),
  'startDate': (e['date'] ?? '').toString(),
  'startTime': (e['start_time'] ?? '').toString(),
  'endTime': (e['end_time'] ?? '').toString(),
  'desc': (e['desc'] ?? '').toString(),
  'status': (e['status'] ?? '').toString(),
  'stat1': (e['stat1'] ?? '0').toString(),
  'stat2': (e['stat2'] ?? '0').toString(),
  'stat3': (e['stat3'] ?? '0').toString(),
}).toList());

          
          // Sort by date (newest first)
          _history.sort((a, b) {
            DateTime dateA = DateTime.parse(a['startDate'] ?? '');
            DateTime dateB = DateTime.parse(b['startDate'] ?? '');
            return dateB.compareTo(dateA);
          });
          
          // Update status counts
          _updateStatusCounts();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Tidak ada data ditemukan untuk user: $where_value');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error:$e');
    }
  }

  Widget _buildStatusTracker() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.cyan[700],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatusCard('Approved', stat1, Colors.green),
              _buildStatusCard('Rejected', stat2, Colors.red),
              _buildStatusCard('Pending', stat3, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, int count, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
          color: _currentPage > 0 ? Colors.cyan[700] : Colors.grey,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.cyan[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Page ${_currentPage + 1} of $_pageCount',
            style: TextStyle(
              color: Colors.cyan[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: _currentPage < _pageCount - 1
              ? () => setState(() => _currentPage++)
              : null,
          color: _currentPage < _pageCount - 1 ? Colors.cyan[700] : Colors.grey,
        ),
      ],
    );
  }

  void _showDetailDialog(Map<String, String> booking) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan[700]!, Colors.cyan[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Center(
              child: Text(
                'Booking Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailItem(Icons.meeting_room, 'Room', booking['room'] ?? ''),
                  _buildDetailItem(Icons.calendar_today, 'Date', booking['startDate'] ?? ''),
                  _buildDetailItem(Icons.access_time, 'Start Time', booking['startTime'] ?? ''),
                  _buildDetailItem(Icons.access_time_filled, 'End Time', booking['endTime'] ?? ''),
                  _buildDetailItem(Icons.description, 'Description', booking['desc'] ?? ''),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking['status'] ?? '').withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: _getStatusColor(booking['status'] ?? ''),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: _getStatusColor(booking['status'] ?? ''),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Status: ${booking['status']}',
                          style: TextStyle(
                            color: _getStatusColor(booking['status'] ?? ''),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Display the stats from booking data
                  _buildDetailItem(Icons.circle, 'Tahap 1', booking['stat1'] ?? '0'),
                  _buildDetailItem(Icons.circle, 'Tahap 2', booking['stat2'] ?? '0'),
                  _buildDetailItem(Icons.circle, 'Tahap 3', booking['stat3'] ?? '0'),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyan[700], size: 24),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.cyan[700]!, Colors.cyan[500]!],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SafeArea(
              child: Center(
                child: Text(
                  'Booking History',
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No booking history found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: _paginatedHistory.length,
                              itemBuilder: (context, index) {
                                final booking = _paginatedHistory[index];
                                return Card(
                                  elevation: 2,
                                  margin: EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () => _showDetailDialog(booking),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.cyan[50],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.meeting_room,
                                              color: Colors.cyan[700],
                                              size: 24,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  booking['room'] ?? '',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  booking['startDate'] ?? '',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(booking['status'] ?? '').withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              booking['status'] ?? '',
                                              style: TextStyle(
                                                color: _getStatusColor(booking['status'] ?? ''),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: _buildPagination(),
                          ),
                        ],
                      ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: 2,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        userData: widget.userData,
      ),
    );
  }
}