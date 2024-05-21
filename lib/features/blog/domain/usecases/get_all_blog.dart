import 'package:blog_app_with_bloc_supabase_hive/core/error/failures.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/usecase/usecase.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/entities/blog.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  BlogRepositoriy blogRepositoriy;

  GetAllBlogs(this.blogRepositoriy);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepositoriy.getAllBlogs();
  }
}
