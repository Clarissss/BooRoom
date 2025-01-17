import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bookingroom/utils/config.dart';
import 'package:bookingroom/utils/room_model.dart';
import 'package:bookingroom/utils/restApi.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

DataService ds = DataService();

class _RoomPageState extends State<RoomPage> {
  List<RoomModel> rooms = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectAllRoom();
  }

  Future<String?> pickImage() async {
    try {
      var picked = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (picked != null) {
        var imageBytes = picked.files.first.bytes!;
        String ext = picked.files.first.extension.toString();

        String? response = await ds.upload(token, project, imageBytes, ext);
        if (response != null) {
          var file = jsonDecode(response);
          return file['file_name'];
        } else {
          _showSnackBar('Upload failed');
        }
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
    return null;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> selectAllRoom() async {
    setState(() => isLoading = true);
    try {
      String response = await ds.selectAll(token, project, 'room', appid);
      var data = jsonDecode(response);
      setState(() {
        rooms = data.map<RoomModel>((e) => RoomModel.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      _showSnackBar('Error loading rooms: $e');
      setState(() => isLoading = false);
    }
  }

  Widget _buildRoomCard(RoomModel room) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Image
                Container(
                  height: 200,
                  width: double.infinity,
                  child: room.room_img.isNotEmpty
                      ? Image.network(
                          fileUri + room.room_img,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(child: Icon(Icons.error)),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                ),
                // Room Details
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Room ${room.name}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${room.capacity} Seats',
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ID: ${room.id}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.edit),
                            label: Text('Edit'),
                            onPressed: () =>
                                _showAddRoomDialog(roomToEdit: room),
                          ),
                          SizedBox(width: 8),
                          TextButton.icon(
                            icon: Icon(Icons.delete, color: Colors.red),
                            label: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () => _deleteRoom(room),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRoomDialog({RoomModel? roomToEdit}) {
    String name = roomToEdit?.name ?? '';
    String capacity = roomToEdit?.capacity ?? '';
    String newRoomImg = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            roomToEdit == null ? 'Add New Room' : 'Edit Room',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  onChanged: (value) => name = value,
                  decoration: InputDecoration(
                    labelText: 'Room Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.meeting_room),
                  ),
                  controller: TextEditingController(text: name),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value) => capacity = value,
                  decoration: InputDecoration(
                    labelText: 'Capacity',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.people),
                  ),
                  controller: TextEditingController(text: capacity),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.photo_camera),
                  label: Text('Choose Image'),
                  onPressed: () async {
                    String? pickedImage = await pickImage();
                    if (pickedImage != null) {
                      newRoomImg = pickedImage;
                      _showSnackBar('Image selected successfully');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text(roomToEdit == null ? 'Add Room' : 'Update Room'),
              onPressed: () async {
                if (name.isEmpty || capacity.isEmpty) {
                  _showSnackBar('Please fill all required fields');
                  return;
                }

                if (roomToEdit == null && newRoomImg.isEmpty) {
                  _showSnackBar('Please select an image');
                  return;
                }

                try {
                  if (roomToEdit == null) {
                    await ds.insertRoom(appid, name, capacity, newRoomImg);
                  } else {
                    await ds.updateId('name', name, token, project, 'room',
                        appid, roomToEdit.id.toString());
                    await ds.updateId('capacity', capacity, token, project,
                        'room', appid, roomToEdit.id.toString());
                    if (newRoomImg.isNotEmpty) {
                      await ds.updateId('room_img', newRoomImg, token, project,
                          'room', appid, roomToEdit.id.toString());
                    }
                  }
                  Navigator.of(context).pop();
                  selectAllRoom();
                  _showSnackBar(
                      roomToEdit == null ? 'Room added' : 'Room updated');
                } catch (e) {
                  _showSnackBar('Error: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteRoom(RoomModel room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Room'),
          content: Text('Are you sure you want to delete Room ${room.name}?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                try {
                  await ds.removeId(
                      token, project, 'room', appid, room.id.toString());
                  Navigator.of(context).pop();
                  selectAllRoom();
                  _showSnackBar('Room deleted successfully');
                } catch (e) {
                  _showSnackBar('Error deleting room: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.only(top: 48, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Room Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      onChanged: (value) {
                        setState(() => searchQuery = value.toLowerCase());
                      },
                      decoration: InputDecoration(
                        hintText: 'Search rooms...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Room List
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : rooms.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.meeting_room_outlined,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No rooms available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: rooms
                              .where((room) =>
                                  room.name.toLowerCase().contains(searchQuery))
                              .length,
                          itemBuilder: (context, index) {
                            final filteredRooms = rooms
                                .where((room) => room.name
                                    .toLowerCase()
                                    .contains(searchQuery))
                                .toList();
                            return _buildRoomCard(filteredRooms[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 50, bottom: 16), // Geser ke kanan
              child: FloatingActionButton(
                heroTag: 'back_button',
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.red,
                child: Icon(Icons.arrow_back, color: Colors.white),
                tooltip: 'Go Back',
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                heroTag: 'add_button',
                onPressed: () => _showAddRoomDialog(),
                backgroundColor: Colors.green,
                child: Icon(Icons.add, color: Colors.white),
                tooltip: 'Add New Room',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
