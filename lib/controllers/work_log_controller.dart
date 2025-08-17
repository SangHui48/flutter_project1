import 'package:get/get.dart';
import '../models/work_log_model.dart';

// 작업 완료 기록을 관리하는 컨트롤러
class WorkLogController extends GetxController {
  // 작업 내역 목록
  final RxList<WorkLogModel> workLogList = <WorkLogModel>[].obs;
  
  // 로딩 상태
  final RxBool isLoading = false.obs;
  
  // 선택된 탭 (전체, 완료된 작업, 지급 완료)
  final RxString selectedTab = 'all'.obs; // 'all', 'completed', 'paid'
  
  // 필터링된 작업 내역
  final RxList<WorkLogModel> filteredWorkLogList = <WorkLogModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 앱 시작 시 작업 내역 로드
    loadWorkLogs();
  }

  // 작업 내역 로드
  Future<void> loadWorkLogs() async {
    try {
      isLoading.value = true;
      
      // TODO: 실제 API 호출
      await Future.delayed(Duration(seconds: 2)); // 시뮬레이션
      
      // 임시 데이터 생성
      final tempWorkLogs = [
        WorkLogModel(
          id: 'work_1',
          jobId: 'job_1',
          jobTitle: '목수 작업 인력 모집',
          employerName: '김건설',
          location: '서울시 강남구',
          workDate: DateTime.now().subtract(Duration(days: 2)),
          dailyWage: 150000,
          status: 'completed',
          completedAt: DateTime.now().subtract(Duration(days: 1)),
          paidAt: DateTime.now().subtract(Duration(hours: 12)),
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 12)),
        ),
        WorkLogModel(
          id: 'work_2',
          jobId: 'job_2',
          jobTitle: '미장공 작업 인력 모집',
          employerName: '박건설',
          location: '서울시 서초구',
          workDate: DateTime.now().subtract(Duration(days: 1)),
          dailyWage: 130000,
          status: 'pending',
          completedAt: DateTime.now().subtract(Duration(hours: 6)),
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
        ),
        WorkLogModel(
          id: 'work_3',
          jobId: 'job_3',
          jobTitle: '철근공 작업 인력 모집',
          employerName: '이건설',
          location: '서울시 마포구',
          workDate: DateTime.now(),
          dailyWage: 140000,
          status: 'in_progress',
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          updatedAt: DateTime.now(),
        ),
      ];
      
      workLogList.value = tempWorkLogs;
      applyFilters();
      
    } catch (e) {
      print('작업 내역 로드 중 오류: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 탭 변경
  void changeTab(String tab) {
    selectedTab.value = tab;
    applyFilters();
  }

  // 필터 적용
  void applyFilters() {
    List<WorkLogModel> filtered = List.from(workLogList);
    
    switch (selectedTab.value) {
      case 'completed':
        filtered = filtered.where((workLog) => 
          workLog.status == 'pending' || workLog.status == 'completed'
        ).toList();
        break;
      case 'paid':
        filtered = filtered.where((workLog) => 
          workLog.status == 'completed'
        ).toList();
        break;
      case 'all':
      default:
        // 전체 표시
        break;
    }
    
    // 날짜순 정렬 (최신순)
    filtered.sort((a, b) => b.workDate.compareTo(a.workDate));
    
    filteredWorkLogList.value = filtered;
  }

  // 작업 완료 요청
  Future<bool> requestWorkCompletion(String workLogId) async {
    try {
      isLoading.value = true;
      
      // TODO: 실제 API 호출
      await Future.delayed(Duration(seconds: 2)); // 시뮬레이션
      
      // 작업 상태 업데이트
      final workLogIndex = workLogList.indexWhere((workLog) => workLog.id == workLogId);
      if (workLogIndex != -1) {
        final updatedWorkLog = workLogList[workLogIndex].copyWith(
          status: 'pending',
          completedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        workLogList[workLogIndex] = updatedWorkLog;
        applyFilters();
      }
      
      return true;
    } catch (e) {
      print('작업 완료 요청 중 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 특정 작업 내역 가져오기
  WorkLogModel? getWorkLogById(String workLogId) {
    try {
      return workLogList.firstWhere((workLog) => workLog.id == workLogId);
    } catch (e) {
      return null;
    }
  }

  // 총 수입 계산
  int getTotalEarnings() {
    return workLogList
        .where((workLog) => workLog.status == 'completed')
        .fold(0, (sum, workLog) => sum + workLog.dailyWage);
  }

  // 이번 달 수입 계산
  int getMonthlyEarnings() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    return workLogList
        .where((workLog) => 
          workLog.status == 'completed' && 
          workLog.workDate.isAfter(startOfMonth)
        )
        .fold(0, (sum, workLog) => sum + workLog.dailyWage);
  }

  // 대기 중인 작업 수
  int getPendingWorkCount() {
    return workLogList
        .where((workLog) => workLog.status == 'pending')
        .length;
  }

  // 완료된 작업 수
  int getCompletedWorkCount() {
    return workLogList
        .where((workLog) => workLog.status == 'completed')
        .length;
  }

  // 새로고침
  Future<void> refreshWorkLogs() async {
    await loadWorkLogs();
  }

  // 작업 내역 삭제 (필요한 경우)
  Future<bool> deleteWorkLog(String workLogId) async {
    try {
      isLoading.value = true;
      
      // TODO: 실제 API 호출
      await Future.delayed(Duration(seconds: 1)); // 시뮬레이션
      
      workLogList.removeWhere((workLog) => workLog.id == workLogId);
      applyFilters();
      
      return true;
    } catch (e) {
      print('작업 내역 삭제 중 오류: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
