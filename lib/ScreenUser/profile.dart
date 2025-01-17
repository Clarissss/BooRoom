import 'dart:convert';
import 'package:bookingroom/utils/config.dart';
import 'package:bookingroom/utils/restApi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  final String userData;

  ProfilePage({required this.userData});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late dynamic user;
  DataService ds = DataService();
  String? userImg;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    try {
      user = jsonDecode(widget.userData);
      if (user is! Map) {
        if (user is List && user.isNotEmpty) {
          user = user[0];
        }
      }
      userImg = (user['user_img'] is String && user['user_img'].isNotEmpty)
          ? user['user_img']
          : 'default.jpg';
    } catch (e) {
      print('Error initializing user data: $e');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

   Future<void> _updateUserImage(String newImagePath) async {
    if (user['_id'] == null) {
      _showSnackBar('Cannot update image: User ID is missing', isError: true);
      return;
    }

    try {
      // Validate all required parameters before making the API call
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing');
      }
      
      if (project == null || project.isEmpty) {
        throw Exception('Project identifier is missing');
      }
      
      if (appid == null || appid.isEmpty) {
        throw Exception('App ID is missing');
      }

      
      final response = await ds.updateId(
        'user_img',
        newImagePath,
        token,
        project,
        'user',
        appid,
        user['_id'].toString(), 
      );

      // Check if the response indicates success
      if (response == null) {
        throw Exception('Server returned null response');
      }

      setState(() {
        userImg = newImagePath;
        user['user_img'] = newImagePath;
      });
      _showSnackBar('Profile picture updated successfully!');
    } catch (e) {
      print('Error updating user image: $e');
      _showSnackBar('Failed to update profile: ${e.toString()}', isError: true);
      setState(() {
        userImg = user['user_img'] ?? 'default.jpg';
      });
    }
  }

  Future<void> _handleImagePicker() async {
    try {
      String? newImagePath = await pickImage();
      if (newImagePath != null) {
        await _updateUserImage(newImagePath);
      }
    } catch (e) {
      _showSnackBar('Failed to update profile picture: $e', isError: true);
    }
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
        }
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', isError: true);
    }
    return null;
  }

  Widget _errorWidget(String message) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.cyan[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.cyan[700], size: 24),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return _errorWidget('Invalid user data format');
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.cyan[700]!,
                    Colors.cyan[500]!,
                  ],
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              fileUri + userImg!,
                            ),
                            onBackgroundImageError: (exception, stackTrace) {
                              print('Error loading image: $exception');
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.cyan[700]),
                              onPressed: _handleImagePicker,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      (user['name'] is String && user['name'].isNotEmpty) 
                          ? user['name'] 
                          : 'Unknown',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      (user['role'] is String && user['role'].isNotEmpty) 
                          ? user['role'] 
                          : 'Unknown',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildInfoCard(
                    context,
                    'Email',
                    (user['email'] is String && user['email'].isNotEmpty) 
                        ? user['email'] 
                        : 'Unknown',
                    Icons.email,
                  ),
                  SizedBox(height: 15),
                  _buildInfoCard(
                    context,
                    'Role',
                    (user['role'] is String && user['role'].isNotEmpty) 
                        ? user['role'] 
                        : 'Unknown',
                    Icons.work,
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'login_screen');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: 3,
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