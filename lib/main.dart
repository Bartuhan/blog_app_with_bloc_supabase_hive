import 'package:blog_app_with_bloc_supabase_hive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/theme/theme.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app_with_bloc_supabase_hive/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<BlogBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}


// Supabase DB password = 'm+L?eH2awYsj!?F'
