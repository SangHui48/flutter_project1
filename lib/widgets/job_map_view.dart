import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/job_controller.dart';

// 지도 뷰 위젯 (임시 구현)
class JobMapView extends StatelessWidget {
  const JobMapView({super.key});

  @override
  Widget build(BuildContext context) {
    final JobController jobController = Get.find<JobController>();

    return Obx(() {
      if (jobController.filteredJobList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map,
                size: 64,
                color: Color(AppConstants.grayColorHex),
              ),
              SizedBox(height: AppConstants.mediumPadding),
              Text(
                '지도에 표시할 일자리가 없습니다',
                style: TextStyle(
                  fontSize: AppConstants.largeFontSize,
                  fontWeight: FontWeight.w500,
                  color: Color(AppConstants.grayColorHex),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        color: Colors.grey.withOpacity(0.1),
        child: Stack(
          children: [
            // 지도 배경 (임시)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://maps.googleapis.com/maps/api/staticmap?center=37.5665,126.9780&zoom=12&size=600x400&maptype=roadmap&markers=color:red%7C37.5665,126.9780&key=YOUR_API_KEY',
                  ),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // 지도 이미지 로드 실패 시 기본 배경 사용
                  },
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 64,
                        color: Colors.white,
                      ),
                      SizedBox(height: AppConstants.mediumPadding),
                      Text(
                        '지도 뷰',
                        style: TextStyle(
                          fontSize: AppConstants.titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: AppConstants.smallPadding),
                      Text(
                        'Google Maps API 연동 필요',
                        style: TextStyle(
                          fontSize: AppConstants.mediumFontSize,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 일자리 마커들 (임시)
            ...jobController.filteredJobList.asMap().entries.map((entry) {
              final index = entry.key;
              final job = entry.value;
              
              // 간단한 위치 계산 (실제로는 위도/경도 기반)
              final left = 50.0 + (index * 80.0) % 300.0;
              final top = 100.0 + (index * 60.0) % 200.0;
              
              return Positioned(
                left: left,
                top: top,
                child: GestureDetector(
                  onTap: () => _showJobInfo(context, job),
                  child: Container(
                    padding: EdgeInsets.all(AppConstants.smallPadding),
                    decoration: BoxDecoration(
                      color: Color(AppConstants.primaryColorHex),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.work,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(height: 2),
                        Text(
                          job.formattedWage,
                          style: TextStyle(
                            fontSize: AppConstants.smallFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            
            // 현재 위치 버튼
            Positioned(
              bottom: AppConstants.largePadding,
              right: AppConstants.largePadding,
              child: FloatingActionButton(
                onPressed: () {
                  // 현재 위치로 이동
                  Get.snackbar(
                    '위치 업데이트',
                    '현재 위치로 지도가 이동합니다.',
                    backgroundColor: Color(AppConstants.accentColorHex),
                    colorText: Color(AppConstants.textColorHex),
                  );
                },
                backgroundColor: Color(AppConstants.primaryColorHex),
                child: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // 일자리 정보 표시
  void _showJobInfo(BuildContext context, job) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppConstants.largePadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 핸들 바
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            SizedBox(height: AppConstants.mediumPadding),
            
            // 일자리 정보
            Text(
              job.title,
              style: TextStyle(
                fontSize: AppConstants.largeFontSize,
                fontWeight: FontWeight.bold,
                color: Color(AppConstants.textColorHex),
              ),
            ),
            
            SizedBox(height: AppConstants.smallPadding),
            
            Text(
              job.location,
              style: TextStyle(
                fontSize: AppConstants.mediumFontSize,
                color: Color(AppConstants.grayColorHex),
              ),
            ),
            
            SizedBox(height: AppConstants.mediumPadding),
            
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.formattedWage,
                    style: TextStyle(
                      fontSize: AppConstants.largeFontSize,
                      fontWeight: FontWeight.bold,
                      color: Color(AppConstants.accentColorHex),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // 지원 처리
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppConstants.primaryColorHex),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('지원하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
