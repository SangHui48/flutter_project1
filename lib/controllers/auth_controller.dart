import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

// 인증 관련 상태를 관리하는 컨트롤러
class AuthController extends GetxController {
  // 사용자 정보 상태
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  
  // 로딩 상태
  final RxBool isLoading = false.obs;
  
  // 로그인 상태
  final RxBool isLoggedIn = false.obs;
  
  // 선택된 역할 (구직자/구인처)
  final RxString selectedRole = 'jobseeker'.obs; // 'jobseeker' 또는 'employer'
  
  // 휴대폰 번호
  final RxString phoneNumber = ''.obs;
  
  // 국가 코드
  final RxString countryCode = '+82'.obs;
  
  // SMS 인증 코드
  final RxString smsCode = ''.obs;
  
  // SMS 인증 완료 여부
  final RxBool isSmsVerified = false.obs;
  
  // 외국인 여부
  final RxBool isForeigner = false.obs;
  
  // 비자 타입
  final RxString visaType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // 앱 시작 시 저장된 로그인 상태 확인
    checkLoginStatus();
  }

  // 저장된 로그인 상태 확인
  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      final isLoggedInValue = prefs.getBool('isLoggedIn') ?? false;
      
      if (isLoggedInValue && userJson != null) {
        // TODO: 실제로는 서버에서 사용자 정보를 다시 확인해야 함
        // user.value = UserModel.fromJson(jsonDecode(userJson));
        isLoggedIn.value = true;
      }
    } catch (e) {
      print('로그인 상태 확인 중 오류: $e');
    }
  }

  // 역할 선택
  void selectRole(String role) {
    selectedRole.value = role;
  }

  // 국가 코드 변경
  void changeCountryCode(String code) {
    countryCode.value = code;
  }

  // 휴대폰 번호 설정
  void setPhoneNumber(String number) {
    phoneNumber.value = number;
  }

  // SMS 인증 코드 설정
  void setSmsCode(String code) {
    smsCode.value = code;
  }

  // SMS 인증 요청 (실제 요청 없이 항상 성공)
  Future<bool> requestSmsVerification() async {
    try {
      isLoading.value = true;
      
      // 시뮬레이션을 위한 짧은 지연
      await Future.delayed(Duration(milliseconds: 500));
      
      // 항상 성공
      return true;
    } catch (e) {
      print('SMS 인증 요청 중 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // SMS 인증 코드 확인 (실제 검증 없이 항상 성공)
  Future<bool> verifySmsCode() async {
    try {
      isLoading.value = true;
      
      // 시뮬레이션을 위한 짧은 지연
      await Future.delayed(Duration(milliseconds: 500));
      
      // 입력만 있으면 항상 성공
      isSmsVerified.value = true;
      return true;
    } catch (e) {
      print('SMS 인증 코드 확인 중 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 로그인 처리
  Future<bool> login() async {
    try {
      isLoading.value = true;
      
      if (!isSmsVerified.value) {
        return false;
      }
      
      // TODO: 실제 로그인 API 호출
      await Future.delayed(Duration(seconds: 1)); // 시뮬레이션
      
      // 임시 사용자 데이터 생성
      final tempUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: '테스트 사용자',
        phoneNumber: '${countryCode.value}${phoneNumber.value}',
        skills: [],
        isAvailableToday: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      user.value = tempUser;
      isLoggedIn.value = true;
      
      // 로그인 상태 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('user', tempUser.toJson().toString());
      
      return true;
    } catch (e) {
      print('로그인 중 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 로그아웃 처리
  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      // TODO: 실제 로그아웃 API 호출
      await Future.delayed(Duration(seconds: 1)); // 시뮬레이션
      
      // 상태 초기화
      user.value = null;
      isLoggedIn.value = false;
      isSmsVerified.value = false;
      smsCode.value = '';
      phoneNumber.value = '';
      
      // 저장된 로그인 정보 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('user');
      
    } catch (e) {
      print('로그아웃 중 오류: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 휴대폰 번호 유효성 검사 (실제 검증 없이 입력만 있으면 통과)
  bool isValidPhoneNumber() {
    return phoneNumber.value.isNotEmpty;
  }

  // SMS 인증 코드 유효성 검사 (실제 검증 없이 입력만 있으면 통과)
  bool isValidSmsCode() {
    return smsCode.value.isNotEmpty;
  }

  // 외국인 여부 설정
  void setIsForeigner(bool value) {
    isForeigner.value = value;
  }

  // 비자 타입 업데이트
  void updateVisaType(String type) {
    visaType.value = type;
  }
}
