import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/team_post_controller.dart';
import '../widgets/team_post_card.dart';

// 팀 지원 화면
class TeamSupportScreen extends StatelessWidget {
  const TeamSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TeamPostController controller = Get.find<TeamPostController>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;
          final horizontalPadding = isWide
              ? AppConstants.largePadding
              : AppConstants.mediumPadding;

          return Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(AppConstants.primaryColorHex),
                ),
              );
            }

            if (controller.filteredTeamPosts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_off,
                      size: 64,
                      color: Color(AppConstants.grayColorHex),
                    ),
                    SizedBox(height: AppConstants.mediumPadding),
                    Text(
                      '등록된 팀 공고가 없습니다',
                      style: TextStyle(
                        fontSize: AppConstants.largeFontSize,
                        color: Color(AppConstants.grayColorHex),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Responsive: Grid on wide, list on narrow
            if (isWide) {
              final crossAxisCount = constraints.maxWidth >= 900 ? 3 : 2;
              final childAspectRatio = constraints.maxWidth >= 900 ? 4 / 2.2 : 4 / 2.5;
              return Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppConstants.mediumPadding,
                    mainAxisSpacing: AppConstants.mediumPadding,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: controller.filteredTeamPosts.length,
                  itemBuilder: (context, index) {
                    final post = controller.filteredTeamPosts[index];
                    return TeamPostCard(post: post);
                  },
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.refreshTeamPosts(),
              color: Color(AppConstants.primaryColorHex),
              child: ListView.builder(
                padding: EdgeInsets.all(horizontalPadding),
                itemCount: controller.filteredTeamPosts.length,
                itemBuilder: (context, index) {
                  final post = controller.filteredTeamPosts[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppConstants.mediumPadding),
                    child: TeamPostCard(post: post),
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }
}


