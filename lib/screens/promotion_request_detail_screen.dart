// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_stream_admin/models/channel.dart';
import 'package:social_stream_admin/provider/channel_provider.dart';
import 'package:social_stream_admin/provider/promotion_provider.dart';
import '../models/user.dart';

class PromotionRequestDetailScreen extends StatefulWidget {
  final User user;
  final Promotion promotion;

  const PromotionRequestDetailScreen(
      {super.key, required this.user, required this.promotion});

  @override
  _PromotionRequestDetailScreenState createState() =>
      _PromotionRequestDetailScreenState();
}

class _PromotionRequestDetailScreenState
    extends State<PromotionRequestDetailScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<User> _fetchUserData() async {
    return widget.user;
  }

  Future<void> _refreshData() async {
    setState(() {
      _userFuture = _fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final promotionProvider = Provider.of<PromotionProvider>(context);
    final channelProvider = Provider.of<ChannelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotion Request Details'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              final user = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Name: ${user.name}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Email: ${user.email}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Subscribed: ${user.isSubscribed ? "Yes" : "No"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Promotions Left: ${user.howManyPromotionsLeft}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Promotion Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Channel Name: ${widget.promotion.channelName}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Description: ${widget.promotion.channelDescription}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Status: ${widget.promotion.status}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Channel Link: ${widget.promotion.channellink}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white)),
                      onPressed: () async {
                        await promotionProvider.updatePromotionStatus(
                            user.userId, widget.promotion.id, 'approved');
                        Channel channel = Channel(
                            id: widget.promotion.id,
                            name: widget.promotion.channelName,
                            description: widget.promotion.channelDescription,
                            link: widget.promotion.channellink,
                            type: widget.promotion.channeltype,
                            categoryId: widget.promotion.categoryId);

                        await channelProvider.addChannel(
                            channel,
                            widget.promotion.categoryId,
                            widget.promotion.channeltype);
                        _refreshData();
                      },
                      child: const Text(
                        'Approve',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white)),
                      onPressed: () async {
                        await promotionProvider.updatePromotionStatus(
                            user.userId, widget.promotion.id, 'Rejected');
                        _refreshData();
                      },
                      child: const Text(
                        'Deny',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Promotion History',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: user.promotions.length,
                        itemBuilder: (context, index) {
                          final pastPromotion = user.promotions[index];
                          return ListTile(
                            title: Text(pastPromotion.channelName),
                            subtitle: Text('Status: ${pastPromotion.status}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
