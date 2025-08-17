import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// 내 정보 관리 화면
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 관리'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context, authController),
          ),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(AppConstants.primaryColorHex),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 영역
              _buildProfileSection(profileController),
              
              SizedBox(height: AppConstants.largePadding),
              
              // 기술 선택 영역
              _buildSkillsSection(profileController),
              
              SizedBox(height: AppConstants.largePadding),
              
              // 오늘 일 가능 스위치
              _buildAvailabilitySection(profileController),
              
              SizedBox(height: AppConstants.largePadding),
              
              // 비자 정보
              _buildVisaSection(profileController),
              
              SizedBox(height: AppConstants.largePadding),
              
              // 저장 버튼
              CustomButton(
                onPressed: () => _saveProfile(profileController),
                text: '저장',
                icon: Icons.save,
              ),
            ],
          ),
        );
      }),
    );
  }

  // 프로필 섹션
  Widget _buildProfileSection(ProfileController controller) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '프로필 정보',
              style: TextStyle(
                fontSize: AppConstants.largeFontSize,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.textColorHex),
              ),
            ),
            SizedBox(height: AppConstants.mediumPadding),
            
            // 프로필 이미지
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(AppConstants.grayColorHex).withOpacity(0.1),
                    backgroundImage: controller.profileImageFile.value != null
                        ? null // TODO: 이미지 표시
                        : null,
                    child: controller.profileImageFile.value == null
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: Color(AppConstants.grayColorHex),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color(AppConstants.primaryColorHex),
                        shape: BoxShape.circle,
                      ),
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        onSelected: (value) {
                          if (value == 'camera') {
                            controller.takeProfileImage();
                          } else if (value == 'gallery') {
                            controller.pickProfileImage();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'camera',
                            child: Row(
                              children: [
                                Icon(Icons.camera_alt),
                                SizedBox(width: AppConstants.smallPadding),
                                Text('카메라'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'gallery',
                            child: Row(
                              children: [
                                Icon(Icons.photo_library),
                                SizedBox(width: AppConstants.smallPadding),
                                Text('갤러리'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppConstants.mediumPadding),
            
            // 이름 입력
            CustomTextField(
              hintText: '이름을 입력하세요',
              prefixIcon: Icons.person,
              onChanged: (value) => controller.updateName(value),
            ),
          ],
        ),
      ),
    );
  }

  // 기술 선택 섹션
  Widget _buildSkillsSection(ProfileController controller) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '보유 기술',
              style: TextStyle(
                fontSize: AppConstants.largeFontSize,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.textColorHex),
              ),
            ),
            SizedBox(height: AppConstants.smallPadding),
            Text(
              '보유하고 있는 기술을 선택해주세요',
              style: TextStyle(
                fontSize: AppConstants.mediumFontSize,
                color: Color(AppConstants.grayColorHex),
              ),
            ),
            SizedBox(height: AppConstants.mediumPadding),
            
            Wrap(
              spacing: AppConstants.smallPadding,
              runSpacing: AppConstants.smallPadding,
              children: AppConstants.skills.map((skill) {
                final skillId = skill['id'] as String;
                final skillName = skill['name'] as String;
                final skillIcon = skill['icon'] as String;
                
                return Obx(() {
                  final isSelected = controller.selectedSkills.contains(skillId);
                  
                  return GestureDetector(
                    onTap: () => controller.toggleSkill(skillId),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.mediumPadding,
                        vertical: AppConstants.smallPadding,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(AppConstants.primaryColorHex)
                            : Color(AppConstants.primaryColorHex).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Color(AppConstants.primaryColorHex)
                              : Color(AppConstants.grayColorHex).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            skillIcon,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: AppConstants.smallPadding),
                          Text(
                            skillName,
                            style: TextStyle(
                              fontSize: AppConstants.mediumFontSize,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : Color(AppConstants.primaryColorHex),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // 오늘 일 가능 섹션
  Widget _buildAvailabilitySection(ProfileController controller) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: Row(
          children: [
            Icon(
              Icons.work,
              color: Color(AppConstants.primaryColorHex),
              size: 24,
            ),
            SizedBox(width: AppConstants.mediumPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘 일 가능',
                    style: TextStyle(
                      fontSize: AppConstants.largeFontSize,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.textColorHex),
                    ),
                  ),
                  SizedBox(height: AppConstants.smallPadding),
                  Text(
                    '일자리 매칭에 노출됩니다',
                    style: TextStyle(
                      fontSize: AppConstants.mediumFontSize,
                      color: Color(AppConstants.grayColorHex),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => Switch(
              value: controller.isAvailableToday.value,
              onChanged: (value) => controller.toggleAvailability(),
              activeColor: Color(AppConstants.primaryColorHex),
            )),
          ],
        ),
      ),
    );
  }

  // 비자 정보 섹션
  Widget _buildVisaSection(ProfileController controller) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '비자 정보',
              style: TextStyle(
                fontSize: AppConstants.largeFontSize,
                fontWeight: FontWeight.w600,
                color: Color(AppConstants.textColorHex),
              ),
            ),
            SizedBox(height: AppConstants.mediumPadding),
            
            // 비자 종류 선택
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
              decoration: BoxDecoration(
                border: Border.all(color: Color(AppConstants.grayColorHex)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(() => DropdownButton<String>(
                  value: controller.visaType.value.isEmpty ? null : controller.visaType.value,
                  isExpanded: true,
                  hint: Text('비자 종류를 선택하세요'),
                  items: AppConstants.visaTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateVisaType(value);
                    }
                  },
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 프로필 저장
  void _saveProfile(ProfileController controller) async {
    final success = await controller.saveProfile();
    if (success) {
      Get.snackbar(
        '저장 완료',
        '프로필이 저장되었습니다.',
        backgroundColor: Color(AppConstants.accentColorHex),
        colorText: Color(AppConstants.textColorHex),
      );
    } else {
      Get.snackbar(
        '저장 실패',
        '프로필 저장에 실패했습니다.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // 로그아웃 다이얼로그
  void _showLogoutDialog(BuildContext context, AuthController authController) {
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
}
