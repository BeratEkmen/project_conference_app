class UserModel {
  String userId;
  bool verified;
  String email;
  UserModel({this.userId, this.verified, this.email});

  UserModel.fromJson(Map<String, dynamic> json){
    this.userId = json["userId"];
    this.email = json["email"];
    this.verified = json["verified"];
  }

  Map<String, dynamic> toJson() {
    return{
      "userId": this.userId,
      "verified": this.verified,
      "email": this.email
    };
  }
}