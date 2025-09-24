import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool backButton;

  final Color backgroundColor;
  final double elevation;

  const CustomAppBar({
    Key? key,
    this.title,
    this.backButton = true,
    this.backgroundColor = Colors.white,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: IconButton(
        onPressed: () {
          if (backButton) {
            Navigator.pop(context);
          }
        },
        icon: Icon(Icons.arrow_back, color: Colors.black),
      ),
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            )
          : null,
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  // Required for PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
