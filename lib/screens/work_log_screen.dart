import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/work_log_controller.dart';
import '../widgets/work_log_card.dart';

// 공수 관리 화면
class WorkLogScreen extends StatefulWidget {
  const WorkLogScreen({super.key});

  @override
  State<WorkLogScreen> createState() => _WorkLogScreenState();
}

class _WorkLogScreenState extends State<WorkLogScreen> {
  bool _showHeader = true;
  final ScrollController _listController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final WorkLogController workLogController = Get.find<WorkLogController>();

    return Scaffold(
      body: Column(
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Visibility(
              visible: _showHeader,
              maintainState: true,
              child: Column(
                children: [
                  _buildStatisticsSection(workLogController),
                  _buildTabBar(workLogController),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (workLogController.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(AppConstants.primaryColorHex),
                      ),
                      SizedBox(height: AppConstants.mediumPadding),
                      Text(
                        '작업 내역을 불러오는 중...',
                        style: TextStyle(
                          fontSize: AppConstants.mediumFontSize,
                          color: Color(AppConstants.grayColorHex),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (notification.direction == ScrollDirection.reverse && _showHeader) {
                    setState(() => _showHeader = false);
                  } else if (notification.direction == ScrollDirection.forward && !_showHeader) {
                    setState(() => _showHeader = true);
                  }
                  return false;
                },
                child: _buildWorkLogList(workLogController, scrollController: _listController),
              );
            }),
          ),
        ],
      ),
    );
  }

  // 통계 정보 섹션
  Widget _buildStatisticsSection(WorkLogController controller) {
    return Container(
      padding: EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        color: Color(AppConstants.primaryColorHex),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 총 수입
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '총 수입',
                  '${controller.getTotalEarnings().toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]},'
                  )}원',
                  Icons.attach_money,
                  Colors.white,
                ),
              ),
              SizedBox(width: AppConstants.mediumPadding),
              Expanded(
                child: _buildStatCard(
                  '이번 달',
                  '${controller.getMonthlyEarnings().toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]},'
                  )}원',
                  Icons.calendar_today,
                  Colors.white,
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppConstants.mediumPadding),
          
          // 작업 상태
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '대기 중',
                  '${controller.getPendingWorkCount()}건',
                  Icons.pending,
                  Color(AppConstants.accentColorHex),
                ),
              ),
              SizedBox(width: AppConstants.mediumPadding),
              Expanded(
                child: _buildStatCard(
                  '완료',
                  '${controller.getCompletedWorkCount()}건',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 통계 카드
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: AppConstants.smallPadding),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.largeFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppConstants.smallPadding / 2),
          Text(
            title,
            style: TextStyle(
              fontSize: AppConstants.smallFontSize,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  // 탭 바
  Widget _buildTabBar(WorkLogController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.mediumPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: _buildTabItem(
              '전체',
              'all',
              controller.selectedTab.value,
              () => controller.changeTab('all'),
            ),
          ),
          SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: _buildTabItem(
              '완료된 작업',
              'completed',
              controller.selectedTab.value,
              () => controller.changeTab('completed'),
            ),
          ),
          SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: _buildTabItem(
              '지급 완료',
              'paid',
              controller.selectedTab.value,
              () => controller.changeTab('paid'),
            ),
          ),
        ],
      )),
    );
  }

  // 탭 아이템
  Widget _buildTabItem(String label, String value, String selectedTab, VoidCallback onTap) {
    final isSelected = selectedTab == value;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(AppConstants.primaryColorHex)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.mediumFontSize,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Colors.white
                  : Color(AppConstants.grayColorHex),
            ),
          ),
        ),
      ),
    );
  }

  // 작업 내역 목록
  Widget _buildWorkLogList(WorkLogController workLogController, {ScrollController? scrollController}) {
    return Obx(() {
      if (workLogController.filteredWorkLogList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 64,
                color: Color(AppConstants.grayColorHex),
              ),
              SizedBox(height: AppConstants.mediumPadding),
              Text(
                '작업 내역이 없습니다',
                style: TextStyle(
                  fontSize: AppConstants.largeFontSize,
                  fontWeight: FontWeight.w500,
                  color: Color(AppConstants.grayColorHex),
                ),
              ),
              SizedBox(height: AppConstants.smallPadding),
              Text(
                '일자리에 지원하고 작업을 완료하면\n여기에 표시됩니다.',
                style: TextStyle(
                  fontSize: AppConstants.mediumFontSize,
                  color: Color(AppConstants.grayColorHex),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => workLogController.refreshWorkLogs(),
        color: Color(AppConstants.primaryColorHex),
        child: ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.all(AppConstants.mediumPadding),
          itemCount: workLogController.filteredWorkLogList.length,
          itemBuilder: (context, index) {
            final workLog = workLogController.filteredWorkLogList[index];
            return Padding(
              padding: EdgeInsets.only(bottom: AppConstants.mediumPadding),
              child: WorkLogCard(workLog: workLog),
            );
          },
        ),
      );
    });
  }
}
