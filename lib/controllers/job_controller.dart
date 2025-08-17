import 'package:get/get.dart';
import '../models/job_model.dart';
import '../constants/app_constants.dart';

// 일자리 관련 상태를 관리하는 컨트롤러
class JobController extends GetxController {
  // 전체 공고 목록
  final RxList<JobModel> jobList = <JobModel>[].obs;
  
  // 필터링된 공고 목록
  final RxList<JobModel> filteredJobList = <JobModel>[].obs;
  
  // 로딩 상태
  final RxBool isLoading = false.obs;
  
  // 지도 뷰/목록 뷰 상태
  final RxBool isMapView = false.obs;
  
  // 내 기술로 필터링 상태
  final RxBool filterByMySkills = false.obs;
  
  // 정렬 방식
  final RxString sortBy = 'latest'.obs; // 'latest', 'distance', 'wage'
  
  // 현재 위치
  final RxDouble currentLatitude = 37.5665.obs; // 서울 시청 기본값
  final RxDouble currentLongitude = 126.9780.obs;

  @override
  void onInit() {
    super.onInit();
    // 앱 시작 시 일자리 목록 로드
    loadJobs();
  }

  // 일자리 목록 로드
  Future<void> loadJobs() async {
    try {
      isLoading.value = true;
      
      // TODO: 실제 API 호출
      await Future.delayed(Duration(seconds: 2)); // 시뮬레이션
      
      // 임시 데이터 생성
      final tempJobs = [
        JobModel(
          id: 'job_1',
          title: '목수 작업 인력 모집',
          description: '신축 건물 목수 작업 인력을 모집합니다. 경험자 우대.',
          location: '서울시 강남구',
          latitude: 37.5665,
          longitude: 126.9780,
          requiredSkills: ['carpenter'],
          dailyWage: 150000,
          employerName: '김건설',
          employerPhone: '010-1234-5678',
          startDate: DateTime.now().add(Duration(days: 1)),
          duration: 5,
          status: 'active',
          isApplied: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        JobModel(
          id: 'job_2',
          title: '미장공 작업 인력 모집',
          description: '아파트 미장 작업 인력을 모집합니다.',
          location: '서울시 서초구',
          latitude: 37.4837,
          longitude: 127.0324,
          requiredSkills: ['plasterer'],
          dailyWage: 130000,
          employerName: '박건설',
          employerPhone: '010-2345-6789',
          startDate: DateTime.now().add(Duration(days: 2)),
          duration: 3,
          status: 'active',
          isApplied: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        JobModel(
          id: 'job_3',
          title: '철근공 작업 인력 모집',
          description: '빌딩 철근 작업 인력을 모집합니다.',
          location: '서울시 마포구',
          latitude: 37.5636,
          longitude: 126.9086,
          requiredSkills: ['rebar'],
          dailyWage: 140000,
          employerName: '이건설',
          employerPhone: '010-3456-7890',
          startDate: DateTime.now().add(Duration(days: 3)),
          duration: 7,
          status: 'active',
          isApplied: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      
      jobList.value = tempJobs;
      filteredJobList.value = tempJobs;
      
    } catch (e) {
      print('일자리 목록 로드 중 오류: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 뷰 모드 변경
  void toggleViewMode() {
    isMapView.value = !isMapView.value;
  }

  // 내 기술로 필터링 토글
  void toggleFilterByMySkills() {
    filterByMySkills.value = !filterByMySkills.value;
    applyFilters();
  }

  // 정렬 방식 변경
  void changeSortBy(String sortType) {
    sortBy.value = sortType;
    applyFilters();
  }

  // 필터 및 정렬 적용
  void applyFilters() {
    List<JobModel> filtered = List.from(jobList);
    
    // 내 기술로 필터링
    if (filterByMySkills.value) {
      // TODO: 실제 사용자 기술과 비교
      final userSkills = ['carpenter', 'plasterer']; // 임시 사용자 기술
      filtered = filtered.where((job) {
        return job.requiredSkills.any((skill) => userSkills.contains(skill));
      }).toList();
    }
    
    // 정렬
    switch (sortBy.value) {
      case 'latest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'distance':
        // TODO: 실제 거리 계산
        break;
      case 'wage':
        filtered.sort((a, b) => b.dailyWage.compareTo(a.dailyWage));
        break;
    }
    
    filteredJobList.value = filtered;
  }

  // 일자리 지원
  Future<bool> applyForJob(String jobId) async {
    try {
      isLoading.value = true;
      
      // TODO: 실제 지원 API 호출
      await Future.delayed(Duration(seconds: 1)); // 시뮬레이션
      
      // 지원 상태 업데이트
      final jobIndex = jobList.indexWhere((job) => job.id == jobId);
      if (jobIndex != -1) {
        final updatedJob = jobList[jobIndex].copyWith(isApplied: true);
        jobList[jobIndex] = updatedJob;
        applyFilters();
      }
      
      return true;
    } catch (e) {
      print('일자리 지원 중 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 일자리 지원 취소
  Future<bool> cancelJobApplication(String jobId) async {
    try {
      isLoading.value = true;
      
      // TODO: 실제 지원 취소 API 호출
      await Future.delayed(Duration(seconds: 1)); // 시뮬레이션
      
      // 지원 상태 업데이트
      final jobIndex = jobList.indexWhere((job) => job.id == jobId);
      if (jobIndex != -1) {
        final updatedJob = jobList[jobIndex].copyWith(isApplied: false);
        jobList[jobIndex] = updatedJob;
        applyFilters();
      }
      
      return true;
    } catch (e) {
      print('일자리 지원 취소 중 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 특정 일자리 정보 가져오기
  JobModel? getJobById(String jobId) {
    try {
      return jobList.firstWhere((job) => job.id == jobId);
    } catch (e) {
      return null;
    }
  }

  // 새로고침
  Future<void> refreshJobs() async {
    await loadJobs();
  }
}
