import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../signin_with_linkedin.dart';
import '../core/authorize_user.dart';

typedef OnGetCode = void Function(String code);

typedef OnSignInError = void Function(LinkedInError error);

/// Web view page that handles url navigation and get the auth code when user
/// sign in successfully and then call access token and user profile API.
class LinkedInWebViewPage extends StatefulWidget {
  const LinkedInWebViewPage({
    super.key,
    this.appBar,
    required this.onGetCode,
    this.onSignInError,
  });

  final PreferredSizeWidget? appBar;
  final OnGetCode onGetCode;
  final OnSignInError? onSignInError;

  @override
  State<LinkedInWebViewPage> createState() => _LinkedInWebViewPageState();
}

class _LinkedInWebViewPageState extends State<LinkedInWebViewPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final isRedirect =
                request.url.startsWith(LinkedInApi.instance.config.redirectUrl);
            if (isRedirect) {
              _manageBack(request);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(LinkedInApi.instance.config.authorizationUrl));
  }

  Future<void> _manageBack(NavigationRequest request) async {
    await authorizeUser(
      request.url,
      onGetCode: widget.onGetCode,
      onSignInError: widget.onSignInError,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ??
          AppBar(
            title: const Text('Sign in with LinkedIn'),
          ),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
