import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/team_post_controller.dart';
import '../controllers/auth_controller.dart';

class TeamSupportWriteScreen extends StatefulWidget {
  const TeamSupportWriteScreen({super.key});

  @override
  State<TeamSupportWriteScreen> createState() => _TeamSupportWriteScreenState();
}

class _TeamSupportWriteScreenState extends State<TeamSupportWriteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _workRoleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _workRoleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TeamPostController controller = Get.find<TeamPostController>();
    final AuthController auth = Get.find<AuthController>();

    final isAllowed = auth.selectedRole.value == 'employer' || (auth.user.value?.isTeamLeader ?? false);

    return Scaffold(
      appBar: AppBar(title: Text('팀 공고 작성')),
      body: LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        final padding = EdgeInsets.symmetric(
          horizontal: isWide ? AppConstants.largePadding : AppConstants.mediumPadding,
          vertical: AppConstants.mediumPadding,
        );
        return SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isAllowed)
                    Container(
                      padding: EdgeInsets.all(AppConstants.mediumPadding),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '팀 공고는 구인자 또는 팀장 권한 사용자만 작성할 수 있습니다.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: AppConstants.mediumFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(height: AppConstants.mediumPadding),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildField('제목', _titleController, '제목을 입력하세요'),
                        _buildField('근무지', _locationController, '근무지를 입력하세요 (온라인/오프라인 명시)'),
                        _buildField('담당 업무', _workRoleController, '담당 업무를 입력하세요'),
                        _buildField('설명', _descriptionController, '상세 설명을 입력하세요', maxLines: 6),
                        SizedBox(height: AppConstants.largePadding),
                        Container(
                          padding: EdgeInsets.all(AppConstants.mediumPadding),
                          decoration: BoxDecoration(
                            color: Color(AppConstants.primaryColorHex).withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '급여는 팀장과 직접 협의 후 결정됩니다.',
                            style: TextStyle(
                              fontSize: AppConstants.mediumFontSize,
                              color: Color(AppConstants.primaryColorHex),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: AppConstants.largePadding),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                child: Text('취소'),
                              ),
                            ),
                            SizedBox(width: AppConstants.mediumPadding),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isAllowed ? () => _submit(controller, auth) : null,
                                child: Text('등록하기'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppConstants.mediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: (v) => (v == null || v.trim().isEmpty) ? '$label 입력이 필요합니다' : null,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }

  void _submit(TeamPostController controller, AuthController auth) async {
    if (!_formKey.currentState!.validate()) return;
    await controller.createTeamPost(
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      workRole: _workRoleController.text.trim(),
      description: _descriptionController.text.trim(),
      teamLeaderName: auth.user.value?.name ?? '팀장',
      teamLeaderPhone: auth.user.value?.phoneNumber ?? '',
    );
    Get.back();
    Get.snackbar(
      '등록 완료',
      '팀 공고가 등록되었습니다.',
      backgroundColor: Color(AppConstants.accentColorHex),
      colorText: Color(AppConstants.textColorHex),
    );
  }
}


