import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign in with LinkedIn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInWithLinkedInPage(),
    );
  }
}

class SignInWithLinkedInPage extends StatefulWidget {
  const SignInWithLinkedInPage({super.key});

  @override
  State<SignInWithLinkedInPage> createState() => _SignInWithLinkedInPageState();
}

class _SignInWithLinkedInPageState extends State<SignInWithLinkedInPage> {
  // Modify the "scope" below as per your need
  final _linkedInConfig = LinkedInConfig(
    clientId: '<<CLIENT ID>>',
    redirectUrl: '<<REDIRECT URL>>',
    scope: ['openid', 'profile', 'email'],
  );
  LinkedInUser? _linkedInUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                SignInWithLinkedIn.signIn(
                  context,
                  config: _linkedInConfig,
                  onGetCode: (code) {
                    log('LinkedIn Code: $code');
                  },
                  onSignInError: (error) {
                    log('Error on sign in: $error');
                  },
                );
              },
              child: const Text('Sign in with LinkedIn'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await SignInWithLinkedIn.logout();
                setState(() => _linkedInUser = null);
              },
              child: const Text('Logout'),
            ),
            const SizedBox(height: 16),
            if (_linkedInUser != null)
              Column(
                children: [
                  if (_linkedInUser!.picture != null)
                    Image.network(_linkedInUser!.picture!, width: 100),
                  const SizedBox(height: 10),
                  Text(_linkedInUser!.name ?? ''),
                  Text(_linkedInUser!.email ?? ''),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
