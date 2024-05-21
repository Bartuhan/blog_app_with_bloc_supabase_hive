import 'package:blog_app_with_bloc_supabase_hive/core/error/failures.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/usecase/usecase.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/common/entities/user.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
