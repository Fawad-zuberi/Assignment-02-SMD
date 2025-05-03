class Userdatamodel {
  final String firstname;
  final String lastname;
  final String profession;
  final String phone;
  final String email;

  Userdatamodel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.profession,
  });

  factory Userdatamodel.fromJson(Map<String, dynamic> obj) {
    return Userdatamodel(
      firstname: obj['firstname'] ?? '',
      lastname: obj['lastname'] ?? '',
      email: obj['email'] ?? '',
      phone: obj['phone'] ?? '',
      profession: obj['profession'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'profession': profession,
    };
  }
}
