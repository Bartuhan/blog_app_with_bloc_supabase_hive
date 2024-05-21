import 'dart:io';
import 'package:blog_app_with_bloc_supabase_hive/core/usecase/usecase.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/entities/blog.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/usecases/get_all_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlog);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );
    res.fold(
      (error) => emit(BlogFailure(error.message)),
      (blogs) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlog(BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (error) => emit(BlogFailure(error.message)),
      (blogs) => emit(BlogDisplaySuccess(blogs)),
    );
  }
}
