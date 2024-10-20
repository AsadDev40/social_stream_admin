// ignore_for_file: use_build_context_synchronously

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:social_stream_admin/models/category.dart';
import 'package:social_stream_admin/models/channel.dart';
import 'package:social_stream_admin/provider/category_provider.dart';
import 'package:social_stream_admin/provider/channel_provider.dart';

class ExcelHandler {
  static Future<void> uploadFileFromAssets(BuildContext context) async {
    try {
      final bytes = await rootBundle.load('assets/channels.xlsx');
      final excel = Excel.decodeBytes(bytes.buffer.asUint8List());

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Uploading data, please wait...'),
                ],
              ),
            ),
          );
        },
      );

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet == null) continue;

        for (var row in sheet.rows.skip(1)) {
          String categoryName = row[0]?.value?.toString() ?? '';
          String channelName = row[1]?.value?.toString() ?? '';
          String channelDescription = row[2]?.value?.toString() ?? '';
          String channelLink = row[3]?.value?.toString() ?? '';
          String channelType = row[4]?.value?.toString() ?? '';

          if (categoryName.isEmpty || channelName.isEmpty) continue;

          await _processCategoryAndChannel(
            context,
            categoryName,
            channelName,
            channelDescription,
            channelLink,
            channelType,
          );
        }
      }

      // Hide loading indicator
      Navigator.of(context).pop();

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Data uploaded successfully.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to upload data: $e'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      rethrow;
    }
  }

  static Future<void> _processCategoryAndChannel(
    BuildContext context,
    String categoryName,
    String channelName,
    String channelDescription,
    String channelLink,
    String channelType,
  ) async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final channelProvider =
        Provider.of<ChannelProvider>(context, listen: false);

    try {
      Categorymodel? category =
          await categoryProvider.getCategoryByName(categoryName);
      if (category == null) {
        category = Categorymodel(
          name: categoryName,
          id: '',
        );
        await categoryProvider.addCategory(category);
        category = await categoryProvider.getCategoryByName(categoryName);
      }

      if (category != null) {
        Channel? existingChannel = await channelProvider.getChannelByName(
          channelName,
          category.id,
          channelType,
        );
        if (existingChannel == null) {
          Channel channel = Channel(
            name: channelName,
            description: channelDescription,
            link: channelLink,
            type: channelType,
            categoryId: category.id,
            id: '',
          );
          await channelProvider.addChannel(channel, category.id, channel.type);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
