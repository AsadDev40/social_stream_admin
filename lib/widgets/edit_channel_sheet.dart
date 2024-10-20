// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_stream_admin/models/channel.dart';
import 'package:social_stream_admin/provider/channel_provider.dart';

class EditChannelSheet extends StatelessWidget {
  final String categoryid;
  final Channel channel;
  final TextEditingController _nameController;
  final TextEditingController _descriptionController;
  final TextEditingController _linkController;

  EditChannelSheet({super.key, required this.channel, required this.categoryid})
      : _nameController = TextEditingController(text: channel.name),
        _descriptionController =
            TextEditingController(text: channel.description),
        _linkController = TextEditingController(text: channel.link);

  @override
  Widget build(BuildContext context) {
    final channelProvider = Provider.of<ChannelProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 50.0,
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit ${channel.type.capitalize()} Channel',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Channel Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(
                labelText: 'Link',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text.trim();
                String description = _descriptionController.text.trim();
                String link = _linkController.text.trim();
                Channel updatedChannel = Channel(
                  id: channel.id,
                  name: name,
                  description: description,
                  link: link,
                  type: channel.type,
                  categoryId: channel.categoryId,
                );

                if (name.isNotEmpty &&
                    description.isNotEmpty &&
                    link.isNotEmpty) {
                  await channelProvider.editChannel(
                      updatedChannel, categoryid, channel.id, channel.type);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update Channel'),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
