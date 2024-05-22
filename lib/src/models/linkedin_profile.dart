import 'linkedin_access_token.dart';
import 'linkedin_user.dart';

class LinkedinProfile {
  LinkedinProfile({
    required this.accessToken,
    required this.user,
  });

  final LinkedInAccessToken accessToken;
  final LinkedInUser user;
}
