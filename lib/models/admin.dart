class ChatData {
  int id;
  String firstName;
  String lastName;
  String email;
  bool isAdmin;
  bool isSuperAdmin;
  bool isActive;
  String token;

  ChatData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.isAdmin,
    this.isSuperAdmin,
    this.isActive,
    this.token,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    isAdmin: json["is_admin"],
    isSuperAdmin: json["is_super_admin"],
    isActive: json["is_active"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "is_admin": isAdmin,
    "is_super_admin": isSuperAdmin,
    "is_active": isActive,
    "token": token,
  };
}