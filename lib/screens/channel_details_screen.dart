// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_stream_admin/models/channel.dart';
import 'package:social_stream_admin/provider/channel_provider.dart';

class ChannelDetailScreen extends StatefulWidget {
  final String categoryId;
  final String channelId;
  final String channelType;

  const ChannelDetailScreen({
    super.key,
    required this.categoryId,
    required this.channelId,
    required this.channelType,
  });

  @override
  _ChannelDetailScreenState createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  late Future<Channel> _channelFuture;

  @override
  void initState() {
    super.initState();
    final channelProvider =
        Provider.of<ChannelProvider>(context, listen: false);
    _channelFuture = channelProvider.getChannelByIdSync(
        widget.categoryId, widget.channelId, widget.channelType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Details'),
      ),
      body: FutureBuilder<Channel>(
        future: _channelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No channel details found.'));
          }

          final channel = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Channel Name: ${channel.name}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Description: ${channel.description}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Link: ${channel.link}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white)),
                  onPressed: () {
                    Provider.of<ChannelProvider>(context, listen: false)
                        .copyToClipboard(channel.link, context);
                  },
                  child: const Text(
                    'Copy Link',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
