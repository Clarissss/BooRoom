import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bookingroom/utils/restApi.dart';
import 'package:bookingroom/utils/config.dart';

// UserModel remains the same
class UserModel {
  final String name;
  final String email;
  final String role;
  final String userImg;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.userImg,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      userImg: json['user_img'] ?? '',
    );
  }
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  bool isLoading = false;
  DataService ds = DataService();
  String searchQuery = '';
  String selectedRole = 'All';
  List<String> roles = ['All'];
  
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectAllUser();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> selectAllUser() async {
    setState(() => isLoading = true);
    try {
      String response = await ds.selectAll(token, project, 'user', appid);
      var data = jsonDecode(response);
      setState(() {
        users = data.map<UserModel>((e) => UserModel.fromJson(e)).toList();
        filteredUsers = users;
        roles = ['All', ...{...users.map((user) => user.role)}];
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading users: $e')),
      );
      setState(() => isLoading = false);
    }
  }

  void filterUsers() {
    setState(() {
      filteredUsers = users.where((user) {
        bool matchesSearch = user.name.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesRole = selectedRole == 'All' || user.role == selectedRole;
        return matchesSearch && matchesRole;
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
        child: Stack(
          children: [
            Column(
              children: [
                // Header
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
                          child: Text(
                            'Users Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.cyan[700]!, width: 1),
                        ),
                        child: TextField(
                          controller: searchController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search by name...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.cyan[700]),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                              filterUsers();
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      // Role Filter
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.cyan[700]!, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.grey[850],
                            value: selectedRole,
                            isExpanded: true,
                            icon: Icon(Icons.filter_list, color: Colors.cyan[700]),
                            style: TextStyle(color: Colors.white),
                            items: roles.map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedRole = newValue;
                                  filterUsers();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // User list
                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.cyanAccent,
                          ),
                        )
                      : filteredUsers.isEmpty
                          ? Center(
                              child: Text(
                                'No users found',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];
                                return UserCard(user: user);
                              },
                            ),
                ),
              ],
            ),
            // Back button
            Positioned(
              left: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
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

// UserCard remains the same
class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.grey[850],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.cyan[700],
              backgroundImage: user.userImg.isNotEmpty
                  ? NetworkImage(fileUri + user.userImg)
                  : null,
              child: user.userImg.isEmpty
                  ? Icon(Icons.person, size: 35, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.cyan[700]?.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.role.toUpperCase(),
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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