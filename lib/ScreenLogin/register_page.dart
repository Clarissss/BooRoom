import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:bookingroom/ScreenLogin/RoundedButton.dart';
import 'package:bookingroom/utils/config.dart';
import 'package:bookingroom/utils/user_model.dart';
import 'package:bookingroom/utils/restApi.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  late String name;
  late String email;
  late String password;
  String? role;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DataService ds = DataService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        // Create user in Firebase Auth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user details to Firestore
        await _firestore.collection('user').add({
          'name': name,
          'role': role,
          'email': email,
          'password': password,
          'user_img': '',
        });

        // Prepare user data for the API
        Map<String, dynamic> userData = {
          'name': name,
          'role': role,
          'email': email,
          'password': password,
          'user_img': '',
        };

        // Insert user data into the database
        String response = await ds.insertUser(
          appid,
          userData['name'],
          userData['role'],
          userData['email'],
          userData['password'],
          userData['user_img'],
        );

        // Decode the response
        List<dynamic> decodedResponse = jsonDecode(response);
        List<UserModel> users = decodedResponse
            .map((e) => UserModel.fromJson(e))
            .toList();

        setState(() => isLoading = false);

        // Handle the response
        if (users.length == 1) {
          Navigator.pop(context, true);
        } else {
          if (kDebugMode) {
            print(decodedResponse);
          }
        }
      } catch (e) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.cyan.shade300,
              Colors.white,
              Colors.cyan.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Welcome Section
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Hero(
                            tag: 'logo',
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/flutter.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan.shade700,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Sign up to get started',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Registration Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name Field
                          _buildInputField(
                            hintText: 'Full Name',
                            icon: Icons.person_outline,
                            onChanged: (value) => name = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Role Dropdown
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: DropdownButtonFormField<String>(
                              value: role,
                              hint: Text('Select Role'),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.work_outline, color: Colors.cyan),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.cyan, width: 1),
                                ),
                              ),
                              items: ['Dosen', 'Mahasiswa']
                                  .map((role) => DropdownMenuItem(
                                        value: role,
                                        child: Text(role),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  role = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select your role';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),

                          // Email Field
                          _buildInputField(
                            hintText: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => email = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@(mhs\.)?itenas\.ac\.id$').hasMatch(value)) {
                                return 'Invalid Email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Password Field
                          _buildInputField(
                            hintText: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            onChanged: (value) => password = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$').hasMatch(value)) {
                                return 'Password must contain letters and numbers';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.cyan,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Register Button
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Login Link
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Colors.cyan,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.cyan),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.cyan, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }
}