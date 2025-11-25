class UserModel {
  final String uid;
  final String email;

  UserModel({required this.uid, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }
}
