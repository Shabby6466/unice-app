import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @tokenizing_your_emotion.
  ///
  /// In en, this message translates to:
  /// **'TOKENIZING YOUR EMOTION'**
  String get tokenizing_your_emotion;

  /// No description provided for @login_google.
  ///
  /// In en, this message translates to:
  /// **'Login using Google'**
  String get login_google;

  /// No description provided for @login_apple.
  ///
  /// In en, this message translates to:
  /// **'Login using Apple'**
  String get login_apple;

  /// No description provided for @alpha_v1.
  ///
  /// In en, this message translates to:
  /// **'ALPHA v1.01'**
  String get alpha_v1;

  /// No description provided for @hello_my_name_is_areum.
  ///
  /// In en, this message translates to:
  /// **'Hello, my name is Areum.\nNice to meet you.\nI want to know about you.\nCan you tell me about\nyourself in 30 seconds?'**
  String get hello_my_name_is_areum;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'CALL'**
  String get call;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter confirm password'**
  String get confirmPassword;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @areum.
  ///
  /// In en, this message translates to:
  /// **'Areum'**
  String get areum;

  /// No description provided for @friends_recommendation.
  ///
  /// In en, this message translates to:
  /// **'Friends Recommendations'**
  String get friends_recommendation;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh '**
  String get refresh;

  /// No description provided for @recommend_friends.
  ///
  /// In en, this message translates to:
  /// **'Recommend Friends'**
  String get recommend_friends;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submit;

  /// No description provided for @login_email.
  ///
  /// In en, this message translates to:
  /// **'Login with Email'**
  String get login_email;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enter_password;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @no_calls_found.
  ///
  /// In en, this message translates to:
  /// **'No call logs found'**
  String get no_calls_found;

  /// No description provided for @forgotPwd.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPwd;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enter_email;

  /// No description provided for @match_names.
  ///
  /// In en, this message translates to:
  /// **'Match Names'**
  String get match_names;

  /// No description provided for @manage_friends.
  ///
  /// In en, this message translates to:
  /// **'Manage Friends'**
  String get manage_friends;

  /// No description provided for @blocked_friends.
  ///
  /// In en, this message translates to:
  /// **'Blocked Friends'**
  String get blocked_friends;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @search_by_name_or_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Search by Name or Phone Numer'**
  String get search_by_name_or_phone_number;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @privacy_setting.
  ///
  /// In en, this message translates to:
  /// **'Privacy Setting'**
  String get privacy_setting;

  /// No description provided for @chat_setting.
  ///
  /// In en, this message translates to:
  /// **'Chat Setting'**
  String get chat_setting;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profile_info.
  ///
  /// In en, this message translates to:
  /// **'Profile info'**
  String get profile_info;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @set_who_can_see.
  ///
  /// In en, this message translates to:
  /// **'Set who can see'**
  String get set_who_can_see;

  /// No description provided for @last_seen.
  ///
  /// In en, this message translates to:
  /// **'Last Seen'**
  String get last_seen;

  /// No description provided for @profile_picture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profile_picture;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @list_of_contacts_you_blocked.
  ///
  /// In en, this message translates to:
  /// **'List of contacts you Blocked'**
  String get list_of_contacts_you_blocked;

  /// No description provided for @blocked_profiles.
  ///
  /// In en, this message translates to:
  /// **'Blocked Profiles'**
  String get blocked_profiles;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @everyone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get everyone;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'contacts'**
  String get contacts;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @skip_capital.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip_capital;

  /// No description provided for @buy_nft.
  ///
  /// In en, this message translates to:
  /// **'Buy NFT'**
  String get buy_nft;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @unice_capital.
  ///
  /// In en, this message translates to:
  /// **'UNICE'**
  String get unice_capital;

  /// No description provided for @unice.
  ///
  /// In en, this message translates to:
  /// **'unice'**
  String get unice;

  /// No description provided for @areum_capital.
  ///
  /// In en, this message translates to:
  /// **'AREUM'**
  String get areum_capital;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @transfer_capital.
  ///
  /// In en, this message translates to:
  /// **'TRANSFER'**
  String get transfer_capital;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'DEPOSIT'**
  String get deposit;

  /// No description provided for @swap.
  ///
  /// In en, this message translates to:
  /// **'SWAP'**
  String get swap;

  /// No description provided for @qr_code.
  ///
  /// In en, this message translates to:
  /// **'QR CODE'**
  String get qr_code;

  /// No description provided for @arm.
  ///
  /// In en, this message translates to:
  /// **'ARM'**
  String get arm;

  /// No description provided for @reward_details.
  ///
  /// In en, this message translates to:
  /// **'REWARD DETAILS'**
  String get reward_details;

  /// No description provided for @total_call_time.
  ///
  /// In en, this message translates to:
  /// **'TOTAL CALL TIME'**
  String get total_call_time;

  /// No description provided for @total_words.
  ///
  /// In en, this message translates to:
  /// **'TOTAL WORDS'**
  String get total_words;

  /// No description provided for @total_rewards.
  ///
  /// In en, this message translates to:
  /// **'TOTAL REWARDS'**
  String get total_rewards;

  /// No description provided for @data_nft.
  ///
  /// In en, this message translates to:
  /// **'DATA NFT'**
  String get data_nft;

  /// No description provided for @areum_nft.
  ///
  /// In en, this message translates to:
  /// **'AREUM NFT'**
  String get areum_nft;

  /// No description provided for @my_referral_reward.
  ///
  /// In en, this message translates to:
  /// **'MY REFERRALS / REWARD'**
  String get my_referral_reward;

  /// No description provided for @address_or_domain_name.
  ///
  /// In en, this message translates to:
  /// **'Address or Domain Name'**
  String get address_or_domain_name;

  /// No description provided for @friends_list.
  ///
  /// In en, this message translates to:
  /// **'Friends List'**
  String get friends_list;

  /// No description provided for @continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_button;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @minimum_transfer.
  ///
  /// In en, this message translates to:
  /// **'Minimum Transfer'**
  String get minimum_transfer;

  /// No description provided for @network_fee.
  ///
  /// In en, this message translates to:
  /// **'Network Fee'**
  String get network_fee;

  /// No description provided for @areum_arm.
  ///
  /// In en, this message translates to:
  /// **'AREUM (ARM)'**
  String get areum_arm;

  /// No description provided for @unice_unice.
  ///
  /// In en, this message translates to:
  /// **'UNICE (UNICE)'**
  String get unice_unice;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @hate_is_heavy_let_it_go.
  ///
  /// In en, this message translates to:
  /// **'Hate is heavy, let it go'**
  String get hate_is_heavy_let_it_go;

  /// No description provided for @general_settings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get general_settings;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @enter_recommender_email.
  ///
  /// In en, this message translates to:
  /// **'Enter recommender Email'**
  String get enter_recommender_email;

  /// No description provided for @there_are_benefits_if_you_enter_a_recommender.
  ///
  /// In en, this message translates to:
  /// **'There are benefits if you enter a recommender.'**
  String get there_are_benefits_if_you_enter_a_recommender;

  /// No description provided for @select_age.
  ///
  /// In en, this message translates to:
  /// **'Select Age'**
  String get select_age;

  /// No description provided for @provides_age_appropriate_information.
  ///
  /// In en, this message translates to:
  /// **'Provides age-appropriate information.'**
  String get provides_age_appropriate_information;

  /// No description provided for @gender_selection.
  ///
  /// In en, this message translates to:
  /// **'Gender Selection'**
  String get gender_selection;

  /// No description provided for @we_provide_gender_specific_information.
  ///
  /// In en, this message translates to:
  /// **'We provide gender-specific information.'**
  String get we_provide_gender_specific_information;

  /// No description provided for @arem_capital.
  ///
  /// In en, this message translates to:
  /// **'AREUM'**
  String get arem_capital;

  /// No description provided for @hello_how_was_your_day.
  ///
  /// In en, this message translates to:
  /// **'Hello! How was your day?\nWhat happned today?'**
  String get hello_how_was_your_day;

  /// No description provided for @connect_meta_mask.
  ///
  /// In en, this message translates to:
  /// **'Connect Meta Mask'**
  String get connect_meta_mask;

  /// No description provided for @wallet_capital.
  ///
  /// In en, this message translates to:
  /// **'WALLET'**
  String get wallet_capital;

  /// No description provided for @add_to_friend.
  ///
  /// In en, this message translates to:
  /// **'Add to friend'**
  String get add_to_friend;

  /// No description provided for @lucky_box.
  ///
  /// In en, this message translates to:
  /// **'Lucky Box'**
  String get lucky_box;

  /// No description provided for @add_as_contact.
  ///
  /// In en, this message translates to:
  /// **'Add as\ncontact'**
  String get add_as_contact;

  /// No description provided for @add_by_id.
  ///
  /// In en, this message translates to:
  /// **'Add by\nId'**
  String get add_by_id;

  /// No description provided for @id_recommended.
  ///
  /// In en, this message translates to:
  /// **'ID\nrecommend'**
  String get id_recommended;

  /// No description provided for @qr_code_two_lines.
  ///
  /// In en, this message translates to:
  /// **'QR\nCODE'**
  String get qr_code_two_lines;

  /// No description provided for @refer_your_3_friends_get_lucky_box.
  ///
  /// In en, this message translates to:
  /// **'Refer your 3 friends & get lucky box'**
  String get refer_your_3_friends_get_lucky_box;

  /// No description provided for @reward_points.
  ///
  /// In en, this message translates to:
  /// **'Reward points'**
  String get reward_points;

  /// No description provided for @share_the_link.
  ///
  /// In en, this message translates to:
  /// **'Share the link'**
  String get share_the_link;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claim;

  /// No description provided for @recentHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent History'**
  String get recentHistory;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recording;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @you_have_received.
  ///
  /// In en, this message translates to:
  /// **'You have received'**
  String get you_have_received;

  /// No description provided for @claimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get claimed;

  /// No description provided for @invite_a_friend.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend'**
  String get invite_a_friend;

  /// No description provided for @share_link.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get share_link;

  /// No description provided for @id_recommend.
  ///
  /// In en, this message translates to:
  /// **'ID Recommend'**
  String get id_recommend;

  /// No description provided for @one_line_qr_code.
  ///
  /// In en, this message translates to:
  /// **'QR CODE'**
  String get one_line_qr_code;

  /// No description provided for @your_address.
  ///
  /// In en, this message translates to:
  /// **'Your address'**
  String get your_address;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @add_by_id_header.
  ///
  /// In en, this message translates to:
  /// **'Add by ID'**
  String get add_by_id_header;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @my_id.
  ///
  /// In en, this message translates to:
  /// **'My ID'**
  String get my_id;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @add_as_contact_single_line.
  ///
  /// In en, this message translates to:
  /// **'Add as contact'**
  String get add_as_contact_single_line;

  /// No description provided for @select_country.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get select_country;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @do_not_include_hyphen.
  ///
  /// In en, this message translates to:
  /// **'Do not include “-”'**
  String get do_not_include_hyphen;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get home;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'CHATS'**
  String get chats;

  /// No description provided for @calls.
  ///
  /// In en, this message translates to:
  /// **'CALLS'**
  String get calls;

  /// No description provided for @nfts.
  ///
  /// In en, this message translates to:
  /// **'NFTs'**
  String get nfts;

  /// No description provided for @type_your_message.
  ///
  /// In en, this message translates to:
  /// **'Type your message'**
  String get type_your_message;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clear_all;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @refer_code.
  ///
  /// In en, this message translates to:
  /// **'Refer code'**
  String get refer_code;

  /// No description provided for @create_an_account.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get create_an_account;

  /// No description provided for @connect_with_your_friends_today.
  ///
  /// In en, this message translates to:
  /// **'Connect with your friends today!'**
  String get connect_with_your_friends_today;

  /// No description provided for @create_profile.
  ///
  /// In en, this message translates to:
  /// **'Create Profile'**
  String get create_profile;

  /// No description provided for @enter_your_username.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Username'**
  String get enter_your_username;

  /// No description provided for @enter_your_email.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enter_your_email;

  /// No description provided for @enter_your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enter_your_phone_number;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @enter_your_full_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Full Name'**
  String get enter_your_full_name;

  /// No description provided for @enter_your_date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get enter_your_date_of_birth;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @by_time.
  ///
  /// In en, this message translates to:
  /// **'By Time'**
  String get by_time;

  /// No description provided for @by_favorites.
  ///
  /// In en, this message translates to:
  /// **'By Favorites'**
  String get by_favorites;

  /// No description provided for @by_unread_chats.
  ///
  /// In en, this message translates to:
  /// **'By Unread Chats'**
  String get by_unread_chats;

  /// No description provided for @emailSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email Sent Successfully.'**
  String get emailSentSuccess;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-Enter Password'**
  String get reEnterPassword;

  /// No description provided for @passwordReSet.
  ///
  /// In en, this message translates to:
  /// **'Password has been reset successfully'**
  String get passwordReSet;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create password'**
  String get createPassword;

  /// No description provided for @sort_chatrooms.
  ///
  /// In en, this message translates to:
  /// **'Sort Chatrooms'**
  String get sort_chatrooms;

  /// No description provided for @new_chat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get new_chat;

  /// No description provided for @new_group.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get new_group;

  /// No description provided for @new_contact.
  ///
  /// In en, this message translates to:
  /// **'New Contact'**
  String get new_contact;

  /// No description provided for @recommend_friends_to_your_friends.
  ///
  /// In en, this message translates to:
  /// **'Recommend friends to your friends'**
  String get recommend_friends_to_your_friends;

  /// No description provided for @match_names_with_your_friends.
  ///
  /// In en, this message translates to:
  /// **'Match names with your friends'**
  String get match_names_with_your_friends;

  /// No description provided for @no_suggestions_found.
  ///
  /// In en, this message translates to:
  /// **'No suggestions found'**
  String get no_suggestions_found;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @forgotPassword_.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword_;

  /// No description provided for @forgotPassword_sub.
  ///
  /// In en, this message translates to:
  /// **'Enter the email associated with your account.'**
  String get forgotPassword_sub;

  /// No description provided for @rememberPass.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberPass;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in.'**
  String get signIn;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password has been changed Successfully.'**
  String get passwordChanged;

  /// No description provided for @passwordChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Password Change Failed, Try Again...'**
  String get passwordChangeFailed;

  /// No description provided for @no_messages.
  ///
  /// In en, this message translates to:
  /// **'No Messages Yet'**
  String get no_messages;

  /// No description provided for @friends_requests.
  ///
  /// In en, this message translates to:
  /// **'Friends\nRequests'**
  String get friends_requests;

  /// No description provided for @friend_requests_single.
  ///
  /// In en, this message translates to:
  /// **'Friend Requests'**
  String get friend_requests_single;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @no_blocked_users.
  ///
  /// In en, this message translates to:
  /// **'No blocked users'**
  String get no_blocked_users;

  /// No description provided for @no_friend_requests_found.
  ///
  /// In en, this message translates to:
  /// **'No friend requests found'**
  String get no_friend_requests_found;

  /// No description provided for @enter_address.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enter_address;

  /// No description provided for @copied_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied_to_clipboard;

  /// No description provided for @referred_by.
  ///
  /// In en, this message translates to:
  /// **'Referred by'**
  String get referred_by;

  /// No description provided for @enterCorrectUserName.
  ///
  /// In en, this message translates to:
  /// **'Enter Correct Username'**
  String get enterCorrectUserName;

  /// No description provided for @enterCorrectEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Correct Email'**
  String get enterCorrectEmail;

  /// No description provided for @scan_to_add_me_as_friend.
  ///
  /// In en, this message translates to:
  /// **'SCAN TO ADD ME AS FRIEND'**
  String get scan_to_add_me_as_friend;

  /// No description provided for @request_sent.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get request_sent;

  /// No description provided for @noChatsFound.
  ///
  /// In en, this message translates to:
  /// **'No Chats Found'**
  String get noChatsFound;

  /// No description provided for @noUser.
  ///
  /// In en, this message translates to:
  /// **'No Users'**
  String get noUser;

  /// No description provided for @found_user.
  ///
  /// In en, this message translates to:
  /// **'Found user'**
  String get found_user;

  /// No description provided for @scan_to_add_friend.
  ///
  /// In en, this message translates to:
  /// **'SCAN TO ADD FRIEND'**
  String get scan_to_add_friend;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @unfriend.
  ///
  /// In en, this message translates to:
  /// **'Unfriend'**
  String get unfriend;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @join_me_on_unice.
  ///
  /// In en, this message translates to:
  /// **'JOIN ME ON UNICE TODAY!'**
  String get join_me_on_unice;

  /// No description provided for @referral_code.
  ///
  /// In en, this message translates to:
  /// **'REFERRAL CODE'**
  String get referral_code;

  /// No description provided for @transactions_history.
  ///
  /// In en, this message translates to:
  /// **'Transactions History'**
  String get transactions_history;

  /// No description provided for @translation_service_payment.
  ///
  /// In en, this message translates to:
  /// **'Translation Service Payment'**
  String get translation_service_payment;

  /// No description provided for @open_metamask.
  ///
  /// In en, this message translates to:
  /// **'Open Metamask'**
  String get open_metamask;

  /// No description provided for @thankYouForReporting.
  ///
  /// In en, this message translates to:
  /// **'Thanks for reporting'**
  String get thankYouForReporting;

  /// No description provided for @thanksDes.
  ///
  /// In en, this message translates to:
  /// **'While you wait for our decision, there are other steps that you can take now'**
  String get thanksDes;

  /// No description provided for @pay_on_this_address_using_metamask.
  ///
  /// In en, this message translates to:
  /// **'Pay on this address by Metamask to enable translation'**
  String get pay_on_this_address_using_metamask;

  /// No description provided for @my_address.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get my_address;

  /// No description provided for @connect_wallet.
  ///
  /// In en, this message translates to:
  /// **'Connect Wallet'**
  String get connect_wallet;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get see_all;

  /// No description provided for @recordStart.
  ///
  /// In en, this message translates to:
  /// **'Please press the button and tell me'**
  String get recordStart;

  /// No description provided for @recordSend.
  ///
  /// In en, this message translates to:
  /// **'Please press the button to send.'**
  String get recordSend;

  /// No description provided for @my_personal_profile.
  ///
  /// In en, this message translates to:
  /// **'My personal profile'**
  String get my_personal_profile;

  /// No description provided for @remove_friend.
  ///
  /// In en, this message translates to:
  /// **'Remove friend'**
  String get remove_friend;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @cancel_request.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get cancel_request;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @add_bio.
  ///
  /// In en, this message translates to:
  /// **'Add bio'**
  String get add_bio;

  /// No description provided for @edit_bio.
  ///
  /// In en, this message translates to:
  /// **'Edit bio'**
  String get edit_bio;

  /// No description provided for @write_your_bio.
  ///
  /// In en, this message translates to:
  /// **'Write your bio'**
  String get write_your_bio;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add_user_to_friend.
  ///
  /// In en, this message translates to:
  /// **'Add user to friend'**
  String get add_user_to_friend;

  /// No description provided for @send_friend_request.
  ///
  /// In en, this message translates to:
  /// **'Send friend request'**
  String get send_friend_request;

  /// No description provided for @do_you_want_to_send_a_friend_request_to.
  ///
  /// In en, this message translates to:
  /// **'Do you want to send a friend request to'**
  String get do_you_want_to_send_a_friend_request_to;

  /// No description provided for @are_you_sure_you_want_to_cancel_this_friend_request.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this friend request?'**
  String get are_you_sure_you_want_to_cancel_this_friend_request;

  /// No description provided for @are_you_sure_you_want_to_remove_this_friend.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this friend?'**
  String get are_you_sure_you_want_to_remove_this_friend;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
