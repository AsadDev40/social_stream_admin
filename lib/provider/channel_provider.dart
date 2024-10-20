import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_stream_admin/models/channel.dart';

class ChannelProvider extends ChangeNotifier {
  // Add channel
  Future<void> addChannel(
      Channel channel, String categoryId, String channeltype) async {
    await FirebaseFirestore.instance
        .collection('categories/$categoryId/$channeltype')
        .add(channel.toMap());
    notifyListeners();
  }

  Future<void> addPromotionChannel(
      Channel channel, String categoryId, String channelType) async {
    await FirebaseFirestore.instance
        .collection('categories') // Main collection
        .doc(categoryId) // Document ID within the collection
        .collection(channelType) // Sub-collection within the document
        .add(channel.toMap());
    notifyListeners();
  }

  // Edit channel
  Future<void> editChannel(Channel channel, String categoryId, String channelId,
      String channeltype) async {
    await FirebaseFirestore.instance
        .collection('categories/$categoryId/$channeltype')
        .doc(channelId)
        .update(channel.toMap());
    notifyListeners();
  }

  // Get channels by category as a Future
  Future<List<Channel>> fetchChannelsByCategory(
      String categoryId, String type) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('categories/$categoryId/$type')
        .where('type', isEqualTo: type)
        .get();

    return snapshot.docs.map((doc) {
      final id = doc.id;
      final data = doc.data() as Map<String, dynamic>;
      return Channel.fromMap(data, id);
    }).toList();
  }

// Fetch single channel by ID synchronously
  Future<Channel> getChannelByIdSync(
      String categoryId, String channelId, String type) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('categories/$categoryId/$type')
        .doc(channelId)
        .get();

    final data = docSnapshot.data() as Map<String, dynamic>;
    return Channel.fromMap(data, docSnapshot.id);
  }

  // Delete channel
  Future<void> deleteChannel(
      String channelId, String categoryId, String channeltype) async {
    await FirebaseFirestore.instance
        .collection('categories/$categoryId/$channeltype')
        .doc(channelId)
        .delete();
    notifyListeners();
  }

  // Get channel by name
  Future<Channel?> getChannelByName(
      String categoryId, String channelName, String channeltype) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('categories/$categoryId/$channeltype')
        .where('name', isEqualTo: channelName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      return Channel.fromMap(data, doc.id);
    }

    return null;
  }

  // Copy to clipboard
  void copyToClipboard(String link, BuildContext context) {
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard')),
    );
  }
}
