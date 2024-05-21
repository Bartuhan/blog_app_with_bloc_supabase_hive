import 'dart:io';

import 'package:blog_app_with_bloc_supabase_hive/core/network/connection_checker.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import 'package:blog_app_with_bloc_supabase_hive/core/error/exceptions.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/error/failures.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/data/datasources/blog_remote_date_source.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/data/models/blog_model.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/entities/blog.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/repositories/blog_repositories.dart';

class BlogRepositoryImpl implements BlogRepositoriy {
  final BlogRemoteDataSource blogRemoteDataSources;
  final BlogLocalDataSource blogLocalDataSouce;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(
    this.blogRemoteDataSources,
    this.blogLocalDataSouce,
    this.connectionChecker,
  );
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      // Check Intenet Connection
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection!'));
      }

      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSources.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uploadedBlog = await blogRemoteDataSources.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      // Check Intenet Connection
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSouce.loadBlogs();
        return right(blogs);
      }

      final blogs = await blogRemoteDataSources.getAllBlogs();
      blogLocalDataSouce.uploadLocalBlogs(blogs: blogs);

      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
