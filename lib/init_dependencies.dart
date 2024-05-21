import 'package:blog_app_with_bloc_supabase_hive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/network/connection_checker.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/secrets/app_secrets.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/domain/usecases/user_signup.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/data/datasources/blog_remote_date_source.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/repositories/blog_repositories.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/usecases/get_all_blog.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.anonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  // core
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()));

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator
    // DataSource
    ..registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(serviceLocator()))

    // Repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
          serviceLocator(),
          serviceLocator(),
        ))
    // UseCases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userlogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    // DataSource
    ..registerFactory<BlogRemoteDataSource>(() => BlogRemoteDataSourcesImpl(serviceLocator()))
    ..registerFactory<BlogLocalDataSource>(() => BlogLocalDataSourceImpl(serviceLocator()))
    // Repository
    ..registerFactory<BlogRepositoriy>(
      () => BlogRepositoryImpl(serviceLocator(), serviceLocator(), serviceLocator()),
    )
    // UseCase
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
