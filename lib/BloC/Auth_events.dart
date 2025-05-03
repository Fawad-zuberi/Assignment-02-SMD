abstract class AuthEvents {}

class LoginEvent extends AuthEvents {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvents {}
