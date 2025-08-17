import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/job_controller.dart';
import '../widgets/job_card.dart';
import '../widgets/job_map_view.dart';

// 일자리 신청 화면
class JobScreen extends StatelessWidget {
  const JobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JobController jobController = Get.find<JobController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('일자리 신청'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => jobController.refreshJobs(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 필터 및 정렬 영역
          _buildFilterSection(jobController),
          
          // 뷰 모드 토글
          _buildViewModeToggle(jobController),
          
          // 일자리 목록 또는 지도
          Expanded(
            child: Obx(() {
              if (jobController.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(AppConstants.primaryColorHex),
                      ),
                      SizedBox(height: AppConstants.mediumPadding),
                      Text(
                        '일자리를 불러오는 중...',
                        style: TextStyle(
                          fontSize: AppConstants.mediumFontSize,
                          color: Color(AppConstants.grayColorHex),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              if (jobController.isMapView.value) {
                return JobMapView();
              } else {
                return _buildJobList(jobController);
              }
            }),
          ),
        ],
      ),
    );
  }

  // 필터 및 정렬 섹션
  Widget _buildFilterSection(JobController jobController) {
    return Container(
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 내 기술로 필터링 스위치
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: Color(AppConstants.primaryColorHex),
                size: 20,
              ),
              SizedBox(width: AppConstants.smallPadding),
              Text(
                '내 기술로 필터링',
                style: TextStyle(
                  fontSize: AppConstants.mediumFontSize,
                  fontWeight: FontWeight.w500,
                  color: Color(AppConstants.textColorHex),
                ),
              ),
              Spacer(),
              Obx(() => Switch(
                value: jobController.filterByMySkills.value,
                onChanged: (value) => jobController.toggleFilterByMySkills(),
                activeColor: Color(AppConstants.primaryColorHex),
              )),
            ],
          ),
          
          SizedBox(height: AppConstants.mediumPadding),
          
          // 정렬 옵션
          Row(
            children: [
              Text(
                '정렬:',
                style: TextStyle(
                  fontSize: AppConstants.mediumFontSize,
                  fontWeight: FontWeight.w500,
                  color: Color(AppConstants.textColorHex),
                ),
              ),
              SizedBox(width: AppConstants.mediumPadding),
              Expanded(
                child: Obx(() => DropdownButton<String>(
                  value: jobController.sortBy.value,
                  isExpanded: true,
                  underline: Container(),
                  items: [
                    DropdownMenuItem(
                      value: 'latest',
                      child: Text('최신순'),
                    ),
                    DropdownMenuItem(
                      value: 'distance',
                      child: Text('거리순'),
                    ),
                    DropdownMenuItem(
                      value: 'wage',
                      child: Text('일당순'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      jobController.changeSortBy(value);
                    }
                  },
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 뷰 모드 토글
  Widget _buildViewModeToggle(JobController jobController) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.mediumPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => jobController.toggleViewMode(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
                decoration: BoxDecoration(
                  color: !jobController.isMapView.value
                      ? Color(AppConstants.primaryColorHex)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list,
                        color: !jobController.isMapView.value
                            ? Colors.white
                            : Color(AppConstants.grayColorHex),
                        size: 20,
                      ),
                      SizedBox(width: AppConstants.smallPadding),
                      Text(
                        '목록',
                        style: TextStyle(
                          fontSize: AppConstants.mediumFontSize,
                          fontWeight: FontWeight.w500,
                          color: !jobController.isMapView.value
                              ? Colors.white
                              : Color(AppConstants.grayColorHex),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: GestureDetector(
              onTap: () => jobController.toggleViewMode(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
                decoration: BoxDecoration(
                  color: jobController.isMapView.value
                      ? Color(AppConstants.primaryColorHex)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        color: jobController.isMapView.value
                            ? Colors.white
                            : Color(AppConstants.grayColorHex),
                        size: 20,
                      ),
                      SizedBox(width: AppConstants.smallPadding),
                      Text(
                        '지도',
                        style: TextStyle(
                          fontSize: AppConstants.mediumFontSize,
                          fontWeight: FontWeight.w500,
                          color: jobController.isMapView.value
                              ? Colors.white
                              : Color(AppConstants.grayColorHex),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  // 일자리 목록
  Widget _buildJobList(JobController jobController) {
    return Obx(() {
      if (jobController.filteredJobList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.work_off,
                size: 64,
                color: Color(AppConstants.grayColorHex),
              ),
              SizedBox(height: AppConstants.mediumPadding),
              Text(
                '조건에 맞는 일자리가 없습니다',
                style: TextStyle(
                  fontSize: AppConstants.largeFontSize,
                  fontWeight: FontWeight.w500,
                  color: Color(AppConstants.grayColorHex),
                ),
              ),
              SizedBox(height: AppConstants.smallPadding),
              Text(
                '필터 조건을 변경해보세요',
                style: TextStyle(
                  fontSize: AppConstants.mediumFontSize,
                  color: Color(AppConstants.grayColorHex),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => jobController.refreshJobs(),
        color: Color(AppConstants.primaryColorHex),
        child: ListView.builder(
          padding: EdgeInsets.all(AppConstants.mediumPadding),
          itemCount: jobController.filteredJobList.length,
          itemBuilder: (context, index) {
            final job = jobController.filteredJobList[index];
            return Padding(
              padding: EdgeInsets.only(bottom: AppConstants.mediumPadding),
              child: JobCard(job: job),
            );
          },
        ),
      );
    });
  }
}
