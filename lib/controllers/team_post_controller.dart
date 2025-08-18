import 'package:get/get.dart';
import '../models/team_post_model.dart';

// 팀 단위 공고 상태를 관리하는 컨트롤러
class TeamPostController extends GetxController {
  final RxList<TeamPostModel> teamPosts = <TeamPostModel>[].obs;
  final RxList<TeamPostModel> filteredTeamPosts = <TeamPostModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTeamPosts();
  }

  Future<void> loadTeamPosts() async {
    try {
      isLoading.value = true;
      await Future.delayed(Duration(milliseconds: 800));

      final temp = [
        TeamPostModel(
          id: 'team_1',
          title: '인테리어 팀원 모집',
          location: '서울시 용산구 (오프라인)',
          workRole: '도배/바닥 마감',
          description: '소규모 아파트 인테리어 현장. 성실하신 분 환영.',
          teamLeaderName: '홍팀장',
          teamLeaderPhone: '010-1111-2222',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        TeamPostModel(
          id: 'team_2',
          title: '온라인 콘텐츠 제작팀',
          location: '온라인 (재택)',
          workRole: '썸네일/간단 편집',
          description: '유튜브 채널 운영 지원. 협업툴 사용.',
          teamLeaderName: '김팀장',
          teamLeaderPhone: '010-3333-4444',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      teamPosts.value = temp;
      filteredTeamPosts.value = temp;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTeamPosts() async {
    await loadTeamPosts();
  }

  // 팀 공고 생성
  Future<void> createTeamPost({
    required String title,
    required String location,
    required String workRole,
    required String description,
    required String teamLeaderName,
    required String teamLeaderPhone,
  }) async {
    final now = DateTime.now();
    final newPost = TeamPostModel(
      id: 'team_${now.millisecondsSinceEpoch}',
      title: title,
      location: location,
      workRole: workRole,
      description: description,
      teamLeaderName: teamLeaderName,
      teamLeaderPhone: teamLeaderPhone,
      createdAt: now,
      updatedAt: now,
    );
    teamPosts.insert(0, newPost);
    filteredTeamPosts.insert(0, newPost);
  }
}


