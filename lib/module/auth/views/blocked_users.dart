import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/widgets/base_widget.dart';
import 'package:unice_app/core/widgets/custom_search_widget.dart';
import 'package:unice_app/module/auth/views/blocked_users_list.dart';
import 'package:unice_app/module/home/bloc/invite_friend_bloc.dart';
import 'package:unice_app/module/home/widgets/manage_friends_top_bar.dart';

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({super.key});

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Background(
      safeAreaTop: true,
      child: Column(
        children: [
          const FriendsTopBar(title: 'Blocked Users'),
          CustomSearchWidget(
            controller: searchController,
            searchIcon: R.assets.graphics.svgIcons.searchIcon,
            onChanged: (value) => context.read<InviteFriendBloc>().add(SearchBlockedUsers(value)),
            onTap: () {},
          ),
          SizedBox(height: 20.h),
          const Expanded(child: BlockedUsersList()),
        ],
      ),
    );
  }
}
