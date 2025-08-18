import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../models/job_model.dart';
import '../controllers/job_controller.dart';

// 일자리 공고 카드 위젯
class JobCard extends StatelessWidget {
  final JobModel job;

  const JobCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final JobController jobController = Get.find<JobController>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showJobDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목과 지원 상태
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.title,
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
                      color: job.isApplied
                          ? Color(AppConstants.accentColorHex)
                          : Color(AppConstants.primaryColorHex),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      job.isApplied ? '지원 완료' : '지원 가능',
                      style: TextStyle(
                        fontSize: AppConstants.smallFontSize,
                        fontWeight: FontWeight.w500,
                        color: job.isApplied
                            ? Color(AppConstants.textColorHex)
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppConstants.smallPadding),
              
              // 설명
              Text(
                job.description,
                style: TextStyle(
                  fontSize: AppConstants.mediumFontSize,
                  color: Color(AppConstants.grayColorHex),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: AppConstants.mediumPadding),
              
              // 기술 요구사항
              Wrap(
                spacing: AppConstants.smallPadding,
                runSpacing: AppConstants.smallPadding,
                children: job.requiredSkills.map((skill) {
                  final skillInfo = AppConstants.skills.firstWhere(
                    (s) => s['id'] == skill,
                    orElse: () => {'name': skill, 'icon': '🔧'},
                  );
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.smallPadding,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(AppConstants.primaryColorHex).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          skillInfo['icon'],
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 4),
                        Text(
                          skillInfo['name'],
                          style: TextStyle(
                            fontSize: AppConstants.smallFontSize,
                            fontWeight: FontWeight.w500,
                            color: Color(AppConstants.primaryColorHex),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              
              SizedBox(height: AppConstants.mediumPadding),
              
              // 하단 정보
              Row(
                children: [
                  // 위치
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color(AppConstants.grayColorHex),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            job.location,
                            style: TextStyle(
                              fontSize: AppConstants.smallFontSize,
                              color: Color(AppConstants.grayColorHex),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: AppConstants.mediumPadding),
                  
                  // 일당
                  Text(
                    job.formattedWage,
                    style: TextStyle(
                      fontSize: AppConstants.largeFontSize,
                      fontWeight: FontWeight.bold,
                      color: Color(AppConstants.accentColorHex),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppConstants.smallPadding),
              
              // 시작일과 기간
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Color(AppConstants.grayColorHex),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${job.formattedStartDate} 시작 • ${job.formattedDuration}',
                    style: TextStyle(
                      fontSize: AppConstants.smallFontSize,
                      color: Color(AppConstants.grayColorHex),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppConstants.mediumPadding),
              
              // 지원 버튼
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: jobController.isLoading.value
                      ? null
                      : () => _handleJobApplication(jobController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: job.isApplied
                        ? Colors.grey
                        : Color(AppConstants.primaryColorHex),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: jobController.isLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          job.isApplied ? '지원 완료' : '지원하기',
                          style: TextStyle(
                            fontSize: AppConstants.mediumFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  // 일자리 상세 정보 표시
  void _showJobDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 핸들 바
            Container(
              margin: EdgeInsets.only(top: AppConstants.mediumPadding),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppConstants.largePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    Text(
                      job.title,
                      style: TextStyle(
                        fontSize: AppConstants.titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Color(AppConstants.textColorHex),
                      ),
                    ),
                    
                    SizedBox(height: AppConstants.mediumPadding),
                    
                    // 설명
                    Text(
                      job.description,
                      style: TextStyle(
                        fontSize: AppConstants.mediumFontSize,
                        color: Color(AppConstants.textColorHex),
                        height: 1.5,
                      ),
                    ),
                    
                    SizedBox(height: AppConstants.largePadding),
                    
                    // 상세 정보
                    _buildDetailItem('위치', job.location, Icons.location_on),
                    _buildDetailItem('일당', job.formattedWage, Icons.attach_money),
                    _buildDetailItem('시작일', job.formattedStartDate, Icons.calendar_today),
                    _buildDetailItem('기간', job.formattedDuration, Icons.schedule),
                    _buildDetailItem('구인처', job.employerName, Icons.business),
                    _buildDetailItem('연락처', job.employerPhone, Icons.phone),
                    
                    SizedBox(height: AppConstants.largePadding),
                    
                    // 기술 요구사항
                    Text(
                      '필요 기술',
                      style: TextStyle(
                        fontSize: AppConstants.largeFontSize,
                        fontWeight: FontWeight.w600,
                        color: Color(AppConstants.textColorHex),
                      ),
                    ),
                    SizedBox(height: AppConstants.mediumPadding),
                    Wrap(
                      spacing: AppConstants.smallPadding,
                      runSpacing: AppConstants.smallPadding,
                      children: job.requiredSkills.map((skill) {
                        final skillInfo = AppConstants.skills.firstWhere(
                          (s) => s['id'] == skill,
                          orElse: () => {'name': skill, 'icon': '🔧'},
                        );
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.mediumPadding,
                            vertical: AppConstants.smallPadding,
                          ),
                          decoration: BoxDecoration(
                            color: Color(AppConstants.primaryColorHex).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                skillInfo['icon'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: AppConstants.smallPadding),
                              Text(
                                skillInfo['name'],
                                style: TextStyle(
                                  fontSize: AppConstants.mediumFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: Color(AppConstants.primaryColorHex),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 상세 정보 아이템
  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppConstants.mediumPadding),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Color(AppConstants.grayColorHex),
          ),
          SizedBox(width: AppConstants.smallPadding),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: AppConstants.mediumFontSize,
              fontWeight: FontWeight.w500,
              color: Color(AppConstants.textColorHex),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppConstants.mediumFontSize,
                color: Color(AppConstants.textColorHex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 일자리 지원 처리
  void _handleJobApplication(JobController jobController) async {
    if (job.isApplied) {
      // 지원 취소
      final success = await jobController.cancelJobApplication(job.id);
      if (success) {
        Get.snackbar(
          '지원 취소',
          '일자리 지원이 취소되었습니다.',
          backgroundColor: Color(AppConstants.accentColorHex),
          colorText: Color(AppConstants.textColorHex),
        );
      }
    } else {
      // 지원
      final success = await jobController.applyForJob(job.id);
      if (success) {
        Get.snackbar(
          '지원 완료',
          '일자리에 지원되었습니다.',
          backgroundColor: Color(AppConstants.accentColorHex),
          colorText: Color(AppConstants.textColorHex),
        );
      }
    }
  }
}
