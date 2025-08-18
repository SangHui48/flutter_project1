import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import 'job_screen.dart';
import 'community_screen.dart';
import 'profile_screen.dart';
import 'work_log_screen.dart';
import 'login_screen.dart';
import 'team_support_screen.dart';
import 'team_support_write_screen.dart';

// 메인 화면 - 하단 내비게이션 바가 있는 메인 화면
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // 화면 목록
  final List<Widget> _screens = [
    const JobScreen(),
    const TeamSupportScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
    const WorkLogScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final titles = ['일자리', '팀 지원', '커뮤니티', '내 정보', '공수 관리'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: AppConstants.mediumPadding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'ODDO',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        title: Text(titles[_currentIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // 로그아웃 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('로그아웃'),
        content: Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authController.logout();
              Get.off(() => const LoginScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  // 하단 내비게이션 바 위젯
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.mediumPadding,
            vertical: AppConstants.smallPadding,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            final isTight = constraints.maxWidth < 360;
            final items = [
              _buildNavItem(0, Icons.work, '일자리'),
              _buildNavItem(1, Icons.group_add, '팀 지원'),
              _buildNavItem(2, Icons.people, '커뮤니티'),
              _buildNavItem(3, Icons.person, '내 정보'),
              _buildNavItem(4, Icons.assignment, '공수'),
            ];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items
                  .map((w) => Expanded(child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: isTight ? 2 : 4),
                        child: w,
                      )))
                  .toList(),
            );
          }),
        ),
      ),
    );
  }

  // 내비게이션 아이템 위젯
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.mediumPadding,
          vertical: AppConstants.smallPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? Color(AppConstants.accentColorHex).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? Color(AppConstants.accentColorHex)
                  : Color(AppConstants.grayColorHex),
              size: 24,
            ),
            SizedBox(height: AppConstants.smallPadding / 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppConstants.smallFontSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected 
                      ? Color(AppConstants.accentColorHex)
                      : Color(AppConstants.grayColorHex),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 팀 지원 탭에서만 노출되는 FAB
  Widget? _buildFloatingActionButton() {
    if (_currentIndex != 1) return null;
    final auth = Get.find<AuthController>();
    final canWrite = auth.selectedRole.value == 'employer' || (auth.user.value?.isTeamLeader ?? false);
    if (!canWrite) return null;
    return FloatingActionButton.extended(
      onPressed: () => Get.to(() => const TeamSupportWriteScreen()),
      backgroundColor: Color(AppConstants.primaryColorHex),
      icon: Icon(Icons.add, color: Colors.white),
      label: Text('팀 공고 작성', style: TextStyle(color: Colors.white)),
    );
  }
}
