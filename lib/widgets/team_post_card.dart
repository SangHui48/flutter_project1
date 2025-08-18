import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/team_post_model.dart';

class TeamPostCard extends StatelessWidget {
  final TeamPostModel post;

  const TeamPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isCompact = constraints.maxWidth < 340;
      final content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: AppConstants.largeFontSize,
                    fontWeight: FontWeight.w600,
                    color: Color(AppConstants.textColorHex),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppConstants.smallPadding),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Color(AppConstants.grayColorHex)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        post.location,
                        style: TextStyle(
                          fontSize: AppConstants.smallFontSize,
                          color: Color(AppConstants.grayColorHex),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConstants.smallPadding),
                Row(
                  children: [
                    Icon(Icons.assignment_ind, size: 16, color: Color(AppConstants.grayColorHex)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        post.workRole,
                        style: TextStyle(
                          fontSize: AppConstants.smallFontSize,
                          color: Color(AppConstants.grayColorHex),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConstants.mediumPadding),
                Text(
                  post.description,
                  style: TextStyle(
                    fontSize: AppConstants.mediumFontSize,
                    color: Color(AppConstants.textColorHex),
                  ),
                  maxLines: isCompact ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppConstants.mediumPadding),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppConstants.smallPadding),
                  decoration: BoxDecoration(
                    color: Color(AppConstants.primaryColorHex).withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '급여는 팀장과 직접 협의 후 결정됩니다.',
                    style: TextStyle(
                      fontSize: AppConstants.smallFontSize,
                      color: Color(AppConstants.primaryColorHex),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.smallPadding),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Color(AppConstants.grayColorHex)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${post.teamLeaderName} · ${post.teamLeaderPhone}',
                        style: TextStyle(
                          fontSize: AppConstants.smallFontSize,
                          color: Color(AppConstants.grayColorHex),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.mediumPadding),
          child: content,
        ),
      );
    });
  }
}


