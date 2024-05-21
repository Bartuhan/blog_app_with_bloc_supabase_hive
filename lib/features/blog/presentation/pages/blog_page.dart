import 'package:blog_app_with_bloc_supabase_hive/core/common/widgets/loader.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/extensions/context_extensions.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/theme/app_palette.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/utils/show_snackbar.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/widgets/blog/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(
            onPressed: () => context.push(const AddNewBlogPage()),
            icon: const Icon(
              CupertinoIcons.add_circled,
            ),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 0
                      ? AppPalette.gradient1
                      : index % 3 == 1
                          ? AppPalette.gradient2
                          : AppPalette.gradient3,
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
