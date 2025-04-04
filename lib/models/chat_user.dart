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
  late final String images;
  late final String name;
  late final String about;
  late final bool isOnline;
  late final String lastActive;
  late final String id;
  late final String createAt;
  late final String pushToken;
  late final String email;

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