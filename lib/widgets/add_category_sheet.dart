// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_stream_admin/provider/category_provider.dart';
import 'package:social_stream_admin/provider/file_upload_provider.dart';
import 'package:social_stream_admin/provider/imagepicker_provider.dart';
import 'package:social_stream_admin/utils/utils.dart';

import '../models/category.dart';

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categoryprovider = Provider.of<CategoryProvider>(context);
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final imageUploadProvider =
        Provider.of<FileUploadProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Choose a Photo',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                await imageProvider.pickImageFromCamera();
                                Utils.back(context);
                              },
                              icon: const Icon(
                                Icons.camera,
                                size: 30,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Camera',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton.icon(
                                onPressed: () async {
                                  await imageProvider.pickImageFromGallery();
                                  Utils.back(context);
                                },
                                icon: const Icon(
                                  Icons.image,
                                  color: Colors.black,
                                ),
                                label: const Text('Gallery',
                                    style: TextStyle(color: Colors.black)))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 30),
                child: Stack(
                  children: [
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black)),
                      child: imageProvider.selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                imageProvider.selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.category,
                              size: 80,
                              color: Colors.black,
                            ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: () async {},
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                            size: 30,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final imageurl = await imageUploadProvider.fileUpload(
                    file: imageProvider.selectedImage!,
                    fileName: _nameController.text,
                    folder: 'categories');
                String name = _nameController.text.trim();

                if (name.isNotEmpty) {
                  Categorymodel newCategory =
                      Categorymodel(id: '', name: name, imageUrl: imageurl);
                  await categoryprovider.addCategory(newCategory);
                  imageProvider.reset();

                  Navigator.pop(context);
                }
              },
              child: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
