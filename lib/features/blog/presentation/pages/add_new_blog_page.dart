import 'dart:io';

import 'package:blog_app_with_bloc_supabase_hive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/common/widgets/loader.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/constants/text/app_text.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/extensions/context_extensions.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/theme/app_palette.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/utils/pick_image.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/utils/show_snackbar.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/widgets/add_new_blog/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  Future<void> selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() && selectedTopics.isNotEmpty && image != null) {
      final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(BlogUpload(
            posterId: posterId,
            title: titleController.text,
            content: contentController.text,
            image: image!,
            topics: selectedTopics,
          ));
    } else if (selectedTopics.isEmpty) {
      showSnackBar(context, 'Topic is required!');
    } else if (image == null) {
      showSnackBar(context, 'Image is required!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            context.offAll(const BlogPage());
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(image!, fit: BoxFit.cover),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: DottedBorder(
                              color: AppPalette.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.folder_open, size: 40),
                                    const SizedBox(height: 15),
                                    Text(
                                      AppText.imageSelect,
                                      style: context.lBody,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Business',
                          'Programming',
                          'Entertainment',
                        ]
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopics.contains(e)) {
                                        selectedTopics.remove(e);
                                      } else {
                                        selectedTopics.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                      label: Text(e),
                                      color: selectedTopics.contains(e)
                                          ? const WidgetStatePropertyAll(
                                              AppPalette.gradient1,
                                            )
                                          : null,
                                      side: selectedTopics.contains(e)
                                          ? const BorderSide(
                                              color: AppPalette.gradient1,
                                            )
                                          : const BorderSide(
                                              color: AppPalette.borderColor,
                                            ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(controller: titleController, hintText: 'Blog Title'),
                    const SizedBox(height: 10),
                    BlogEditor(controller: contentController, hintText: 'Blog Content'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
