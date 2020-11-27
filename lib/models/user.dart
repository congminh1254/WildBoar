class Users {
  String uid;
  String email;
  String photoUrl;
  String displayName;
  String posts;
  String bio;
  String phone;

  Users(
      {this.uid,
      this.email,
      this.photoUrl,
      this.displayName,
      this.bio,
      this.posts,
      this.phone});

  Map toMap(Users user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['photoUrl'] = user.photoUrl;
    data['displayName'] = user.displayName;
    data['bio'] = user.bio;
    data['posts'] = user.posts;
    data['phone'] = user.phone;
    return data;
  }

  Users.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.photoUrl = mapData['photoUrl'];
    this.displayName = mapData['displayName'];
    this.bio = mapData['bio'];
    this.posts = mapData['posts'];
    this.phone = mapData['phone'];
  }
}
