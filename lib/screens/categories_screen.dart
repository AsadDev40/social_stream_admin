// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:social_stream_admin/models/category.dart';
import 'package:social_stream_admin/provider/category_provider.dart';
import 'package:social_stream_admin/screens/channels_screen.dart';
import 'package:social_stream_admin/services/excel_data_service.dart';
import 'package:social_stream_admin/utils/utils.dart';
import 'package:social_stream_admin/widgets/add_category_sheet.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Categorymodel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<Categorymodel>> _fetchCategories() {
    return Provider.of<CategoryProvider>(context, listen: false)
        .fetchCategories();
  }

  void _showAddCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const AddCategorySheet();
      },
    ).then((_) {
      setState(() {
        _categoriesFuture = _fetchCategories();
      });
    });
  }

  Future<void> _refreshCategories() async {
    setState(() {
      _categoriesFuture = _fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories - SocialStream'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshCategories,
                child: FutureBuilder<List<Categorymodel>>(
                  future: _categoriesFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Categorymodel>> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return GridView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 25.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemBuilder: (context, index) {
                        final category = snapshot.data?[index];
                        return GestureDetector(
                          onTap: () {
                            Utils.navigateTo(
                                context,
                                ChannelsScreen(
                                    category: category.name,
                                    categoryId: category.id));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Image with Loading Indicator
                              SizedBox(
                                height: 120,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: category!.imageUrl != null &&
                                              category.imageUrl!.isNotEmpty
                                          ? Image.network(
                                              category.imageUrl!,
                                              width: 160,
                                              height: 160,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                1)
                                                        : null,
                                                  ),
                                                );
                                              },
                                            )
                                          : Image.network(
                                              'https://via.placeholder.com/80',
                                              width: 160,
                                              height: 160,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        category.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        await Provider.of<CategoryProvider>(
                                                context,
                                                listen: false)
                                            .deleteCategory(category.id);
                                        _refreshCategories();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => _showAddCategorySheet(context),
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () async {
              await ExcelHandler.uploadFileFromAssets(context);
              _refreshCategories();
            },
            child: const Icon(Icons.upload),
          )
        ],
      ),
    );
  }
}
