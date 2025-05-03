abstract class AuthEvents {}

class LoginEvent extends AuthEvents {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvents {
  final firstname;
  final lastname;
  final email;
  final password;
  final profession;
  final phone;
  final pwd;
  final repwd;

  SignUpEvent(this.firstname, this.lastname, this.email, this.password,
      this.profession, this.phone, this.pwd, this.repwd);
}

class Logout extends AuthEvents {}
