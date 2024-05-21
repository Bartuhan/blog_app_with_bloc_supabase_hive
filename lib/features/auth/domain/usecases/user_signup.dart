import 'package:blog_app_with_bloc_supabase_hive/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

import 'package:blog_app_with_bloc_supabase_hive/core/error/failures.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/usecase/usecase.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.singUpWithEmailPassword(
      email: params.email,
      name: params.name,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
