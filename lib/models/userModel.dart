class UserModel {
  String userToken;
  String email;

  UserModel({this.email, this.userToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    this.email = json['email'];
    this.userToken = json['token'];
  }

  toMap() => {"email": this.email};
}
