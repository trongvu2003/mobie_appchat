class ChatUser {
  ChatUser({
    required this.images,
    required this.name,
    required this.about,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.createAt,
    required this.pushToken,
    required this.email,
  });
  late String images;
  late String name;
  late String about;
  late bool isOnline;
  late String lastActive;
  late String id;
  late String createAt;
  late String pushToken;
  late String email;

  ChatUser.fromJson(Map<String, dynamic> json){
    images = json['images'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? '';
    id = json['id'] ?? '';
    createAt = json['create_at'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['images'] = images;
    data['name'] = name;
    data['about'] = about;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['id'] = id;
    data['create_at'] = createAt;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}