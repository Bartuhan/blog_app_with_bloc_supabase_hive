import 'package:blog_app_with_bloc_supabase_hive/core/extensions/context_extensions.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/theme/app_palette.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/theme/calculate_reading_time.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/utils/format_date.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewer extends StatelessWidget {
  const BlogViewer({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: context.sBody!.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${blog.posterName}',
                  style: context.sBody!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                  style: context.sBody!.copyWith(
                    color: AppPalette.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(10),
                //   child: Image.network(blog.imageUrl),
                // ),
                const Placeholder(
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  blog.content,
                  style: context.sBody!.copyWith(
                    height: 2,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
