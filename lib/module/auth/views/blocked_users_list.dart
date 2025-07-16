import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unice_app/core/services/l10n/gen_l10n/app_localizations.dart';
import 'package:unice_app/core/utils/resource/r.dart';
import 'package:unice_app/core/utils/utitily_methods/utils.dart';
import 'package:unice_app/core/widgets/cache_network_image.dart';
import 'package:unice_app/module/home/bloc/invite_friend_bloc.dart';

class BlockedUsersList extends StatefulWidget {
  const BlockedUsersList({super.key});

  @override
  State<BlockedUsersList> createState() => _BlockedUsersListState();
}

class _BlockedUsersListState extends State<BlockedUsersList> {
  @override
  void initState() {
    super.initState();
    context.read<InviteFriendBloc>().add(ListBlockedUserEvent(''));
  }

  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context);
    return BlocConsumer<InviteFriendBloc, InviteFriendState>(listener: (context, state) {
      if (state is UnblockUserFailureState) {
        if (state.errMsg.isNotEmpty) {
          Utility.showError(context, state.errMsg);
        }
      }
      if (state is UnblockUserSuccessState) {
        context.read<InviteFriendBloc>().add(ListBlockedUserEvent(''));
      }
    }, builder: (context, state) {
      if (state.filteredBlockedUsers.isEmpty) return Center(child: Text(tr.no_blocked_users));
      return ListView.builder(
          itemCount: state.filteredBlockedUsers.length,
          itemBuilder: (context, index) {
            final blocked = state.filteredBlockedUsers[index];
            final isUnblocking = state.loading && state.unblockingUserId == blocked.user.userId;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                children: [
                  CircularCacheNetworkImage(
                    imageUrl:  state.filteredBlockedUsers[index].user.profilePicture ?? '',
                    size: 50.r,
                    height: 50.h,
                    width: 50.w,
                    backgroundColor: R.palette.white,
                    imageFit: BoxFit.cover,
                    errorIconPath: R.assets.graphics.svgIcons.avatarIcon,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    state.filteredBlockedUsers[index].user.username,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16.sp,
                          height: 20.sp / 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.read<InviteFriendBloc>().add(UnblockUserEvent(userId: state.filteredBlockedUsers[index].user.userId));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(28.r)),
                        border: Border.all(color: R.palette.disabledText, width: 1.w),
                      ),
                      child: isUnblocking
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: R.palette.primaryLight,
                              ),
                            )
                          : Text(
                              tr.unblock,
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          });
    });
  }
}
