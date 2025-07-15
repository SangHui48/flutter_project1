import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final String? title;

  const CommonAppBar({
    super.key,
    this.showBack = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF002B5B),
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 26),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(
        title ?? AppLocalizations.of(context)?.appTitle ?? 'ODDO',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w900,
          fontFamily: 'Roboto',
          letterSpacing: 2.5,
        ),
      ),
      centerTitle: true,
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 