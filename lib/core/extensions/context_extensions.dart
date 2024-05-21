import 'package:flutter/material.dart';

extension BuildContextExtension<T> on BuildContext {
  // Size
  double get _width => MediaQuery.of(this).size.width;
  double get _height => MediaQuery.of(this).size.height;

  /// 1 - 100 Arası bir değer alır bu değer yüzdesini belirler
  double width(int? size) => this._width * (size ?? 100 / 100);

  /// 1 - 100 Arası bir değer alır bu değer yüzdesini belirler
  double height(int? size) => this._height * (size ?? 100 / 100);

  // TextStyles
  // - Display Size
  TextStyle? get sDisplay => Theme.of(this).textTheme.displaySmall;
  TextStyle? get mDisplay => Theme.of(this).textTheme.displayMedium;
  TextStyle? get lDisplay => Theme.of(this).textTheme.displayLarge;

  // - Headline Size
  TextStyle? get sHeadline => Theme.of(this).textTheme.headlineSmall;
  TextStyle? get mHeadline => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get lHeadline => Theme.of(this).textTheme.headlineLarge;

  // - Title Size
  TextStyle? get sTitle => Theme.of(this).textTheme.titleSmall;
  TextStyle? get mTitle => Theme.of(this).textTheme.titleMedium;
  TextStyle? get lTitle => Theme.of(this).textTheme.titleLarge;

  // - Body Size
  TextStyle? get sBody => Theme.of(this).textTheme.bodySmall;
  TextStyle? get mBody => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get lBody => Theme.of(this).textTheme.bodyLarge;

  // - Label Size
  TextStyle? get sLabel => Theme.of(this).textTheme.labelSmall;
  TextStyle? get mLabel => Theme.of(this).textTheme.labelMedium;
  TextStyle? get lLabel => Theme.of(this).textTheme.labelLarge;

  //#region Colors
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorDark => Theme.of(this).primaryColorDark;
  Color get primaryColorLight => Theme.of(this).primaryColorLight;
  Color get primaryColorSheme => Theme.of(this).colorScheme.primary;
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;
  Color get secondaryColorSheme => Theme.of(this).colorScheme.secondary;
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;
  //#endregion

  // Navigate
  /// Belirtilen sayfaya yönlendirme sağlar
  Future<T?> push(Widget page) {
    return Navigator.of(this).push(MaterialPageRoute(
      builder: (context) => page,
    ));
  }

  /// Belirtilen sayfa ismine yönlendirme sağlar
  Future<T?> pushNamed(String routeName) {
    return Navigator.of(this).pushNamed(routeName);
  }

  /// Belirtilen sayfaya yönlendirme sağlar ve önceki bütün sayfaları kapatır
  Future<T?> offAll(Widget page) {
    return Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
  }

  /// Bir sayfa geri gidilmesini sağlar
  void back() {
    Navigator.of(this).pop();
  }

  /// Custom BottomSheet
  Future<T?> showBottomSheet(
    Widget child, {
    bool isScrolledControlled = true,
    Color? backGroundColor,
    Color? barrierColor,
  }) {
    return showModalBottomSheet(
      context: this,
      barrierColor: barrierColor,
      backgroundColor: backGroundColor,
      isScrollControlled: isScrolledControlled,
      builder: (context) => Wrap(children: [child]),
    );
  }

  /// Custom Snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(String message) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
