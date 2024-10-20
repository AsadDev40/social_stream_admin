// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_stream_admin/models/channel.dart';
import 'package:social_stream_admin/provider/channel_provider.dart';
import 'package:social_stream_admin/widgets/edit_channel_sheet.dart';

class AddChannelSheet extends StatelessWidget {
  final String category;
  final String type;
  final String categoryId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  AddChannelSheet(
      {super.key,
      required this.category,
      required this.type,
      required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final channelprovider = Provider.of<ChannelProvider>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New ${type.capitalize()} Channel',
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
                Channel channel = Channel(
                    id: '',
                    name: name,
                    description: description,
                    link: link,
                    type: type,
                    categoryId: category);

                if (name.isNotEmpty &&
                    description.isNotEmpty &&
                    link.isNotEmpty) {
                  await channelprovider.addChannel(
                      channel, categoryId, channel.type);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Channel'),
            ),
          ],
        ),
      ),
    );
  }
}
