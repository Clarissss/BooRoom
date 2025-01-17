import 'package:flutter/material.dart';

class JadwalPage extends StatefulWidget {
  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final List<Map<String, String>> _schedules = [
    {
      'id_jadwal': '1',
      'nama_user': 'Alice Johnson',
      'nomer_ruangan': 'Rungan 40216',
      'tanggal_jam_waktu_mulai': '2024-12-13 09:00 AM',
      'tanggal_jam_waktu_selesai': '2024-12-13 10:00 AM',
      'deskripsi': 'Meeting with the team',
    },
    {
      'id_jadwal': '2',
      'nama_user': 'Bob Smith',
      'nomer_ruangan': 'Rungan 40217',
      'tanggal_jam_waktu_mulai': '2024-12-14 11:00 AM',
      'tanggal_jam_waktu_selesai': '2024-12-14 12:00 PM',
      'deskripsi': 'Project presentation',
    },
    {
      'id_jadwal': '3',
      'nama_user': 'Charlie Brown',
      'nomer_ruangan': 'Rungan 40218',
      'tanggal_jam_waktu_mulai': '2024-12-15 01:00 PM',
      'tanggal_jam_waktu_selesai': '2024-12-15 02:00 PM',
      'deskripsi': 'Client meeting',
    },
    {
      'id_jadwal': '4',
      'nama_user': 'David Wilson',
      'nomer_ruangan': 'Rungan 40219',
      'tanggal_jam_waktu_mulai': '2024-12-16 03:00 PM',
      'tanggal_jam_waktu_selesai': '2024-12-16 04:00 PM',
      'deskripsi': 'Workshop',
    },
    {
      'id_jadwal': '5',
      'nama_user': 'Eva Green',
      'nomer_ruangan': 'Rungan 40220',
      'tanggal_jam_waktu_mulai': '2024-12-17 10:00 AM',
      'tanggal_jam_waktu_selesai': '2024-12-17 11:00 AM',
      'deskripsi': 'Team building activity',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Top 15% dark cyan
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                color: Colors.black, // Match admin.dart background
                child: Stack(
                  children: [
                    // Darker circles in the background
                    Positioned(
                      left: -50,
                      top: -50,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.cyan[700]
                              ?.withOpacity(0.5), // Softer color for dark mode
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
                          color: Colors.cyan[700]?.withOpacity(0.5),
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
                          color: Colors.cyan[700]?.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Centered text "Schedules" with padding
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          'Schedules',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom 85% dark gray
              Expanded(
                child: Container(
                  color: Colors.black87, // Dark background for the list
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[850], // Dark card background
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Text('ID Jadwal',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Nama User',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Nomor Ruangan',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Waktu Mulai',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Waktu Selesai',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Deskripsi',
                                    style: TextStyle(color: Colors.white))),
                          ],
                          rows: _schedules.map((schedule) {
                            return DataRow(cells: [
                              DataCell(Text(schedule['id_jadwal']!,
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(schedule['nama_user']!,
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(schedule['nomer_ruangan']!,
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(
                                  schedule['tanggal_jam_waktu_mulai']!,
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(
                                  schedule['tanggal_jam_waktu_selesai']!,
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(schedule['deskripsi']!,
                                  style: TextStyle(color: Colors.white))),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Floating Action Button
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back when pressed
              },
              backgroundColor:
                  Colors.redAccent, // Button color matches admin.dart
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
