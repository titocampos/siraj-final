class User {

  final String name;
  final String email;
  final String password;

  User({this.name, this.email, this.password});

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "name" : this.name,
      "email" : this.email,
      "totalCredit": 0
    };
    return map;
  }
}