import 'dart:developer';

import '../../signin_with_linkedin.dart';
import 'extensions.dart';

/// Authorize the user and returns either auth token or profile details.
Future<dynamic> authorizeUser(
  String url, {
  required OnGetCode onGetCode,
  OnSignInError? onSignInError,
}) async {
  try {
    onGetCode.call(url.authCode);
    return url.authCode;
  } catch (e, stackTrace) {
    log(e.toString(), stackTrace: stackTrace);
    final error = e is LinkedInError ? e : LinkedInError(message: e.toString());
    onSignInError?.call(error);
    return error;
  }
}
