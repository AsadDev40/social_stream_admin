class Channel {
  final String id;
  final String name;
  final String description;
  final String link;
  final String type;
  final String categoryId;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.link,
    required this.type,
    required this.categoryId,
  });

  factory Channel.fromMap(Map<String, dynamic> data, String documentId) {
    return Channel(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      link: data['link'] ?? '',
      type: data['type'] ?? '',
      categoryId: data['categoryId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'link': link,
      'type': type,
      'categoryId': categoryId,
    };
  }
}
