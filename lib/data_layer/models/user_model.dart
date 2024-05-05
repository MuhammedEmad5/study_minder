class UserDataModel {
  String? uId;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? userImage;


  UserDataModel({
    this.uId,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.userImage,
  });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    userImage = json['userImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'email': email,
      'phone': phone,
      'password': password,
      'userImage': userImage,
    };
  }
}
