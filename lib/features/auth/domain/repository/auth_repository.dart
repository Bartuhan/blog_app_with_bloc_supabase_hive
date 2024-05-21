import 'package:blog_app_with_bloc_supabase_hive/core/error/failures.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> singUpWithEmailPassword({
    required String email,
    required String name,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
