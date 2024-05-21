import 'package:blog_app_with_bloc_supabase_hive/core/extensions/context_extensions.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/theme/calculate_reading_time.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/pages/blog_viever_page.dart';
import 'package:flutter/material.dart';

import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
  });

  final Blog blog;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(BlogViewer(blog: blog)),
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: blog.topics
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Chip(
                            label: Text(e),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Text(
              blog.title,
              style: context.mHeadline,
            ),
            const Spacer(),
            Text(
              '${calculateReadingTime(blog.content)} min',
              style: context.mLabel,
            ),
          ],
        ),
      ),
    );
  }
}
