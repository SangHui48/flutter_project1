import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

// 사용자 프로필 관련 상태를 관리하는 컨트롤러
class ProfileController extends GetxController {
  // 사용자 정보
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  
  // 로딩 상태
  final RxBool isLoading = false.obs;
  
  // 선택된 기술 목록
  final RxList<String> selectedSkills = <String>[].obs;
  
  // 오늘 일 가능 상태
  final RxBool isAvailableToday = true.obs;
  
  // 프로필 이미지 파일
  final Rx<XFile?> profileImageFile = Rx<XFile?>(null);
  
  // 비자 종류
  final RxString visaType = ''.obs;
  
  // 국가 코드
  final RxString countryCode = '+82'.obs;

  @override
  void onInit() {
    super.onInit();
    // 앱 시작 시 사용자 정보 로드
    loadUserProfile();
  }

  // 사용자 프로필 로드
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      
      // TODO: 실제 API 호출
      await Future.delayed(Duration(seconds: 1)); // 시뮬레이션
      
      // 임시 사용자 데이터 생성
      final tempUser = UserModel(
        id: 'user_1',
        name: '김철수',
        phoneNumber: '010-1234-5678',
        skills: ['carpenter', 'plasterer'],
        isAvailableToday: true,
        visaType: 'E-9 비자',
        countryCode: '+82',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      user.value = tempUser;
      selectedSkills.value = List.from(tempUser.skills);
      isAvailableToday.value = tempUser.isAvailableToday;
      visaType.value = tempUser.visaType ?? '';
      countryCode.value = tempUser.countryCode ?? '+82';
      
    } catch (e) {
      print('사용자 프로필 로드 중 오류: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 이름 변경
  void updateName(String name) {
    if (user.value != null) {
      user.value = user.value!.copyWith(name: name);
    }
  }

  // 기술 선택/해제
  void toggleSkill(String skillId) {
    if (selectedSkills.contains(skillId)) {
      selectedSkills.remove(skillId);
    } else {
      selectedSkills.add(skillId);
    }
  }

  // 오늘 일 가능 상태 변경
  void toggleAvailability() {
    isAvailableToday.value = !isAvailableToday.value;
  }

  // 프로필 이미지 선택
  Future<void> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        profileImageFile.value = image;
      }
    } catch (e) {
      print('프로필 이미지 선택 중 오류: $e');
    }
  }

  // 프로필 이미지 촬영
  Future<void> takeProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        profileImageFile.value = image;
      }
    } catch (e) {
      print('프로필 이미지 촬영 중 오류: $e');
    }
  }

  // 비자 종류 변경
  void updateVisaType(String type) {
    visaType.value = type;
  }

  // 국가 코드 변경
  void updateCountryCode(String code) {
    countryCode.value = code;
  }

  // 프로필 저장
  Future<bool> saveProfile() async {
    try {
      isLoading.value = true;
      
      if (user.value == null) {
        return false;
      }
      
      // TODO: 실제 API 호출
      await Future.delayed(Duration(seconds: 2)); // 시뮬레이션
      
      // 사용자 정보 업데이트
      final updatedUser = user.value!.copyWith(
        name: user.value!.name,
        skills: selectedSkills.toList(),
        isAvailableToday: isAvailableToday.value,
        visaType: visaType.value,
        countryCode: countryCode.value,
        updatedAt: DateTime.now(),
      );
      
      user.value = updatedUser;
      
      return true;
    } catch (e) {
      print('프로필 저장 중 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 기술 목록에서 기술 이름 가져오기
  String getSkillName(String skillId) {
    final skill = AppConstants.skills.firstWhere(
      (skill) => skill['id'] == skillId,
      orElse: () => {'name': '알 수 없음', 'icon': '❓'},
    );
    return skill['name'];
  }

  // 기술 목록에서 기술 아이콘 가져오기
  String getSkillIcon(String skillId) {
    final skill = AppConstants.skills.firstWhere(
      (skill) => skill['id'] == skillId,
      orElse: () => {'name': '알 수 없음', 'icon': '❓'},
    );
    return skill['icon'];
  }

  // 선택된 기술의 이름 목록 가져오기
  List<String> getSelectedSkillNames() {
    return selectedSkills.map((skillId) => getSkillName(skillId)).toList();
  }

  // 선택된 기술의 아이콘 목록 가져오기
  List<String> getSelectedSkillIcons() {
    return selectedSkills.map((skillId) => getSkillIcon(skillId)).toList();
  }

  // 프로필 이미지 초기화
  void clearProfileImage() {
    profileImageFile.value = null;
  }
}
