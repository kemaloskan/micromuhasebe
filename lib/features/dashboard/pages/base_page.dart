import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  const BasePage({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryMain,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: showBackButton,
        actions: actions,
      ),
      body: content,
      floatingActionButton: floatingActionButton != null 
        ? FloatingActionButton(
            onPressed: (floatingActionButton as FloatingActionButton).onPressed,
            backgroundColor: AppColors.primaryMain,
            foregroundColor: Colors.white,
            child: (floatingActionButton as FloatingActionButton).child,
          )
        : null,
    );
  }
} 