import 'package:blog_app_with_bloc_supabase_hive/core/constants/text/app_text.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/extensions/context_extensions.dart';
import 'package:blog_app_with_bloc_supabase_hive/core/theme/app_palette.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class SelectImageContainer extends StatelessWidget {
  const SelectImageContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppPalette.borderColor,
      dashPattern: const [10, 4],
      radius: const Radius.circular(10),
      borderType: BorderType.RRect,
      strokeCap: StrokeCap.round,
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 40),
            const SizedBox(height: 15),
            Text(
              AppText.imageSelect,
              style: context.lBody,
            )
          ],
        ),
      ),
    );
  }
}
