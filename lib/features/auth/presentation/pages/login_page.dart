import 'package:blog_app_with_bloc_supabase_hive/core/common/widgets/loader.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/constants/text/app_text.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/extensions/context_extensions.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/theme/app_palette.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/utils/show_snackbar.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app_with_bloc_supabase_hive/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              context.offAll(const BlogPage());
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppText.signIn,
                    style: context.lDisplay!.copyWith(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AuthField(
                    hintText: AppText.email,
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: AppText.password,
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    buttonText: AppText.signIn,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.push(const SignupPage());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: AppText.dontHaveAccount,
                        style: context.mTitle,
                        children: [
                          TextSpan(
                            text: AppText.signUp,
                            style: context.mTitle!.copyWith(
                              color: AppPalette.gradient2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
