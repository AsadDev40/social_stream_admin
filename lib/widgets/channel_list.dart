import 'package:flutter/material.dart';
import 'package:social_stream_admin/models/channel.dart';
import 'package:social_stream_admin/widgets/edit_channel_sheet.dart';
import 'package:social_stream_admin/provider/channel_provider.dart';
import 'package:provider/provider.dart';

class ChannelList extends StatelessWidget {
  final String category;
  final String categoryId;
  final String type;
  final Function(String) onChannelTap;

  const ChannelList({
    super.key,
    required this.category,
    required this.categoryId,
    required this.type,
    required this.onChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    final channelProvider = Provider.of<ChannelProvider>(context);

    return FutureBuilder<List<Channel>>(
      future: channelProvider.fetchChannelsByCategory(categoryId, type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading channels'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No channels found'));
        }

        final channels = snapshot.data ?? [];

        return ListView.builder(
          itemCount: channels.length,
          itemBuilder: (context, index) {
            final channel = channels[index];
            return ListTile(
              title: Text(channel.name),
              subtitle: Text('Type: ${channel.type.capitalize()}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return EditChannelSheet(
                            channel: Channel(
                              id: channel.id,
                              name: channel.name,
                              description: channel.description,
                              link: channel.link,
                              type: type,
                              categoryId: categoryId,
                            ),
                            categoryid: categoryId,
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      channelProvider.deleteChannel(
                          channel.id, categoryId, channel.type);
                    },
                  ),
                ],
              ),
              onTap: () {
                onChannelTap(channel.id);
              },
            );
          },
        );
      },
    );
  }
}
