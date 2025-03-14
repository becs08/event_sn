import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
      ),
      child: Column(
        children: [
          _buildTopBar(),
          SizedBox(height: 16),
          _buildSearchBar(),
        ],
      ),
    );
  }

// ... Méthodes de construction des sous-widgets
}