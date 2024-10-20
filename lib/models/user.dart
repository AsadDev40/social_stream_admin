class User {
  final String userId;
  final String email;
  final String name;
  final bool isSubscribed;
  final int howManyPromotionsLeft;
  final List<Promotion> promotions;

  User({
    required this.userId,
    required this.email,
    required this.name,
    required this.isSubscribed,
    required this.howManyPromotionsLeft,
    required this.promotions,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['userName'] ?? '',
      isSubscribed: map['issubscribed'] ?? false,
      howManyPromotionsLeft: 0,
      promotions: map['promotions'] != null
          ? (map['promotions'] as Map<String, dynamic>).entries.map((entry) {
              return Promotion.fromMap(entry.key, entry.value);
            }).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': userId,
      'email': email,
      'userName': name,
      'issubscribed': isSubscribed,
      'promotions': promotions.map((x) => x.toMap()).toList(),
    };
  }
}

class Promotion {
  final String id;
  final String channelId;
  final String channelName;
  final String channelDescription;
  final String status;
  final String channellink;
  final String channeltype;
  final String categoryId;

  Promotion(
      {required this.id,
      required this.channelId,
      required this.channelName,
      required this.channelDescription,
      required this.status,
      required this.channellink,
      required this.categoryId,
      required this.channeltype});

  factory Promotion.fromMap(String id, Map<String, dynamic> map) {
    return Promotion(
        id: id,
        channelId: map['channelId'] ?? '',
        channelName: map['channelname'] ?? '',
        channelDescription: map['description'] ?? '',
        status: map['status'] ?? '',
        channellink: map['link'] ?? '',
        channeltype: map['type'] ?? '',
        categoryId: map['categoryId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'channelId': channelId,
      'channelname': channelName,
      'description': channelDescription,
      'status': status,
      'link': channellink,
      'categoryId': categoryId,
      'type': channeltype
    };
  }
}
