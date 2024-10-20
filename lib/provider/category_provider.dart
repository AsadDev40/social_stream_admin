import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_stream_admin/models/category.dart';
import 'package:social_stream_admin/models/channel.dart';

class CategoryProvider extends ChangeNotifier {
  //add category
  Future<void> addCategory(Categorymodel category) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .add(category.toMap());
    notifyListeners();
  }

  Future<List<Categorymodel>> fetchCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return querySnapshot.docs.map((doc) {
      return Categorymodel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

//Delete Categories
  Future<void> deleteCategory(String categoryId) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .delete();
    notifyListeners();
  }

  Future<Categorymodel?> getCategoryByName(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('name', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      return Categorymodel.fromMap(data, doc.id);
    }
  }

  Future<List<Channel>> fetchChannelsByCategory(
      String categoryId, String type) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('categories/$categoryId/channels/$type')
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Channel.fromMap(data, doc.id);
    }).toList();
  }
}
