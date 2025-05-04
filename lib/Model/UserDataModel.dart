class Userdatamodel {
  final String firstName;
  final String lastName;
  final String profession;
  final String phone;
  final String email;

  Userdatamodel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.profession,
  });

  factory Userdatamodel.fromJson(Map<String, dynamic> obj) {
    return Userdatamodel(
      firstName: obj['firstName'] ?? '',
      lastName: obj['lastName'] ?? '',
      email: obj['email'] ?? '',
      phone: obj['phone'] ?? '',
      profession: obj['profession'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'profession': profession,
    };
  }
}
