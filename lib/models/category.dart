class Categorymodel {
  final String id;
  final String name;
  final String? imageUrl;

  Categorymodel({required this.id, required this.name, this.imageUrl});

  factory Categorymodel.fromMap(Map<String, dynamic> data, String documentId) {
    return Categorymodel(
        id: documentId, name: data['name'] ?? '', imageUrl: data['imageUrl']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'imageUrl': imageUrl};
  }
}
