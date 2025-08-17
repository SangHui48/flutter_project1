import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../models/work_log_model.dart';
import '../controllers/work_log_controller.dart';

// 작업 내역 카드 위젯
class WorkLogCard extends StatelessWidget {
  final WorkLogModel workLog;

  const WorkLogCard({
    super.key,
    required this.workLog,
  });

  @override
  Widget build(BuildContext context) {
    final WorkLogController workLogController = Get.find<WorkLogController>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목과 상태
            Row(
              children: [
                Expanded(
                  child: Text(
                    workLog.jobTitle,
                    style: TextStyle(
                      fontSize: AppConstants.largeFontSize,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.textColorHex),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppConstants.smallPadding),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.smallPadding,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(workLog.statusColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(workLog.statusColor),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    workLog.statusText,
                    style: TextStyle(
                      fontSize: AppConstants.smallFontSize,
                      fontWeight: FontWeight.w500,
                      color: Color(workLog.statusColor),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppConstants.smallPadding),
            
            // 구인처와 위치
            Row(
              children: [
                Icon(
                  Icons.business,
                  size: 16,
                  color: Color(AppConstants.grayColorHex),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    workLog.employerName,
                    style: TextStyle(
                      fontSize: AppConstants.mediumFontSize,
                      color: Color(AppConstants.textColorHex),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppConstants.smallPadding),
            
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Color(AppConstants.grayColorHex),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    workLog.location,
                    style: TextStyle(
                      fontSize: AppConstants.mediumFontSize,
                      color: Color(AppConstants.grayColorHex),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppConstants.mediumPadding),
            
            // 작업일과 일당
            Row(
              children: [
                // 작업일
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Color(AppConstants.grayColorHex),
                      ),
                      SizedBox(width: 4),
                      Text(
                        workLog.formattedWorkDate,
                        style: TextStyle(
                          fontSize: AppConstants.mediumFontSize,
                          color: Color(AppConstants.textColorHex),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: AppConstants.mediumPadding),
                
                // 일당
                Text(
                  workLog.formattedWage,
                  style: TextStyle(
                    fontSize: AppConstants.largeFontSize,
                    fontWeight: FontWeight.bold,
                    color: Color(AppConstants.accentColorHex),
                  ),
                ),
              ],
            ),
            
            // 완료/지급 시간 정보
            if (workLog.completedAt != null || workLog.paidAt != null) ...[
              SizedBox(height: AppConstants.mediumPadding),
              if (workLog.completedAt != null)
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '완료: ${_formatDateTime(workLog.completedAt!)}',
                      style: TextStyle(
                        fontSize: AppConstants.smallFontSize,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              if (workLog.paidAt != null) ...[
                if (workLog.completedAt != null)
                  SizedBox(height: AppConstants.smallPadding),
                Row(
                  children: [
                    Icon(
                      Icons.payment,
                      size: 16,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '지급: ${_formatDateTime(workLog.paidAt!)}',
                      style: TextStyle(
                        fontSize: AppConstants.smallFontSize,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ],
            
            SizedBox(height: AppConstants.mediumPadding),
            
            // 작업 완료 버튼 (작업 중인 경우에만)
            if (workLog.status == 'in_progress')
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: workLogController.isLoading.value
                      ? null
                      : () => _requestWorkCompletion(workLogController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppConstants.primaryColorHex),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: workLogController.isLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 20),
                            SizedBox(width: AppConstants.smallPadding),
                            Text(
                              '작업 완료 요청',
                              style: TextStyle(
                                fontSize: AppConstants.mediumFontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              )),
          ],
        ),
      ),
    );
  }

  // 날짜/시간 포맷팅
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // 작업 완료 요청
  void _requestWorkCompletion(WorkLogController workLogController) async {
    final success = await workLogController.requestWorkCompletion(workLog.id);
    if (success) {
      Get.snackbar(
        '완료 요청',
        '작업 완료 요청이 전송되었습니다.',
        backgroundColor: Color(AppConstants.accentColorHex),
        colorText: Color(AppConstants.textColorHex),
      );
    } else {
      Get.snackbar(
        '요청 실패',
        '작업 완료 요청에 실패했습니다.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
