import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

// 커뮤니티 화면
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 64,
              color: Color(AppConstants.grayColorHex),
            ),
            SizedBox(height: AppConstants.mediumPadding),
            Text(
              '커뮤니티',
              style: TextStyle(
                fontSize: AppConstants.titleFontSize,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.textColorHex),
              ),
            ),
            SizedBox(height: AppConstants.smallPadding),
            Text(
              '구직자들이 정보를 공유하고 소통하는 공간입니다.',
              style: TextStyle(
                fontSize: AppConstants.mediumFontSize,
                color: Color(AppConstants.grayColorHex),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.largePadding),
            Text(
              '준비 중입니다...',
              style: TextStyle(
                fontSize: AppConstants.largeFontSize,
                fontWeight: FontWeight.w500,
                color: Color(AppConstants.grayColorHex),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
