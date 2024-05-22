import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../signin_with_linkedin.dart';
import 'linkedin_core.dart';

class LinkedinMobile implements LinkedinCore {
  @override
  Future<void> signIn(
    BuildContext context, {
    required LinkedInConfig config,
    OnGetCode? onGetCode,
    OnSignInError? onSignInError,
    PreferredSizeWidget? appBar,
  }) async {
    LinkedInApi.instance.config = config;
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LinkedInWebViewPage(
          appBar: appBar,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result is String) {
      onGetCode?.call(result);
    } else if (result is LinkedInError) {
      onSignInError?.call(result);
    }
  }

  @override
  Future<bool> logout() {
    return WebViewCookieManager().clearCookies();
  }
}

LinkedinCore getCoreConfig() => LinkedinMobile();
