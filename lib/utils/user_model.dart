class UserModel {
  final String id;
  final String name;
  final String role;
  final String email;
  final String password;
  final String user_img;

  UserModel(
      {required this.id,
      required this.name,
      required this.role,
      required this.email,
      required this.password,
      required this.user_img});

  factory UserModel.fromJson(Map data) {
    return UserModel(
        id: data['_id'],
        name: data['name'],
        role: data['role'],
        email: data['email'],
        password: data['password'],
        user_img: data['user_img']);
  }
}
