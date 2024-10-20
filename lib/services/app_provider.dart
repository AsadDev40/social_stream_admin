import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:social_stream_admin/provider/category_provider.dart';
import 'package:social_stream_admin/provider/channel_provider.dart';
import 'package:social_stream_admin/provider/file_upload_provider.dart';
import 'package:social_stream_admin/provider/imagepicker_provider.dart';
import 'package:social_stream_admin/provider/promotion_provider.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
          ChangeNotifierProvider(create: (context) => ChannelProvider()),
          ChangeNotifierProvider(create: (context) => PromotionProvider()),
          ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
          ChangeNotifierProvider(create: (context) => FileUploadProvider()),
        ],
        child: child,
      );
}
