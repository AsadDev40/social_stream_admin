import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class PromotionProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  Future<void> fetchUsers() async {
    try {
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final List<User> userList =
          await Future.wait(userSnapshot.docs.map((doc) async {
        final data = doc.data();

        final promotionsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .collection('promotions')
            .get();

        final List<Promotion> promotions =
            promotionsSnapshot.docs.map((promotionDoc) {
          final promotionData = promotionDoc.data();
          final promotionId = promotionDoc.id;
          return Promotion.fromMap(promotionId, promotionData);
        }).toList();

        final int pendingPromotionsCount =
            promotions.where((promo) => promo.status == 'pending').length;

        final userId = data['uid'] ?? '';
        final email = data['email'] ?? '';
        final name = data['userName'] ?? '';
        final isSubscribed = data['issubscribed'] ?? false;

        return User(
          userId: userId,
          email: email,
          name: name,
          isSubscribed: isSubscribed,
          howManyPromotionsLeft: pendingPromotionsCount,
          promotions: promotions,
        );
      }).toList());

      _users = userList;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updatePromotionStatus(
      String userId, String promotionId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('promotions')
          .doc(promotionId)
          .update({'status': newStatus});

      // Optionally, fetch users again to refresh the data
      await fetchUsers();
    } catch (error) {
      rethrow;
    }
  }
}
