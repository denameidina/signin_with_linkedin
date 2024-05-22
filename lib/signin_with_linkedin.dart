library signin_with_linkedin;

import 'dart:developer';

import 'package:flutter/material.dart';

import 'signin_with_linkedin.dart';
import 'src/helper/linkedin_core.dart';

export 'src/core/linkedin_api_handler.dart';
export 'src/models/linked_in_error.dart';
export 'src/models/linkedin_access_token.dart';
export 'src/models/linkedin_config.dart';
export 'src/models/linkedin_locale.dart';
export 'src/models/linkedin_profile.dart';
export 'src/models/linkedin_user.dart';
export 'src/ui/linkedin_web_view_page.dart';

final _linkedinCore = LinkedinCore.fromConfig();

final class SignInWithLinkedIn {
  SignInWithLinkedIn._();

  /// Sign in with LinkedIn.
  ///
  /// Provide callback [onGetCode] to get code from linkedin
  /// Provide callback [onSignInError] if you want to access error
  ///
  /// Customize the [appBar] for LinkedIn web view page
  static Future<void> signIn(
    BuildContext context, {
    required LinkedInConfig config,
    required OnGetCode onGetCode,
    OnSignInError? onSignInError,
    PreferredSizeWidget? appBar,
  }) async {
    LinkedInApi.instance.config = config;
    _linkedinCore.signIn(
      context,
      config: config,
      onGetCode: onGetCode,
      onSignInError: onSignInError,
    );
  }

  /// Logout from LinkedIn account
  static Future<bool> logout() async {
    return _linkedinCore.logout();
  }

  static Future<LinkedInAccessToken?> getAccessToken({
    required String code,
    required String clientSecret,
    OnSignInError? onSignInError,
  }) async {
    try {
      return LinkedInApi.instance.getAccessToken(
        code: code,
        clientSecret: clientSecret,
      );
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      final error =
          e is LinkedInError ? e : LinkedInError(message: e.toString());
      onSignInError?.call(error);
      return null;
    }
  }

  static Future<LinkedinProfile?> getProfile({
    required String code,
    required String clientSecret,
    OnSignInError? onSignInError,
  }) async {
    try {
      final accessToken = await getAccessToken(
        code: code,
        clientSecret: clientSecret,
        onSignInError: onSignInError,
      );
      if (accessToken == null) return null;

      final user = await LinkedInApi.instance.getUserInfo(
        tokenType: accessToken.tokenType ?? '',
        token: accessToken.accessToken ?? '',
      );

      return LinkedinProfile(accessToken: accessToken, user: user);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      final error =
          e is LinkedInError ? e : LinkedInError(message: e.toString());
      onSignInError?.call(error);
      return null;
    }
  }
}
