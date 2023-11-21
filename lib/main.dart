import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hockey_news/news/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'on_boarding_screen.dart';
import 'news/fb_options.dart';
import 'news/hockey_news_data_source.dart';
import 'presentation/hockey_matches/data/hockey_repository.dart';
import 'presentation/hockey_matches/show_screen.dart';
import 'presentation/notification_fb.dart';
import 'package:in_app_review/in_app_review.dart';

late final SharedPreferences gfdhgfddf;
late SharedPreferences prefs;
final remoteConfig = FirebaseRemoteConfig.instance;
final inAppReview = InAppReview.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  gfdhgfddf = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: SettingsS.currentPlatform);
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 7),
    minimumFetchInterval: const Duration(seconds: 7),
  ));
  await NotificationServiceFb().activate();
  final bool showing = await checkMatchesData();
  prefs = await SharedPreferences.getInstance();
  starRate();
  runApp(MyApp(
    showMatches: showing,
  ));
}

Future<void> starRate() async {
  bool gfdsgfdsfds = gfdhgfddf.getBool('sgfdsdcas') ?? false;
  if (!gfdsgfdsfds) {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
      await gfdhgfddf.setBool('sgfdsdcas', true);
    }
  }
}

class MyApp extends StatelessWidget {
  final bool showMatches;
  const MyApp({super.key, required this.showMatches});

  @override
  Widget build(BuildContext context) {
    if (showMatches && isMatchesShow != '') {
      return ShowLiveHockeyMatch(
        show: isMatchesShow,
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF060606),
      ),
      home: FutureBuilder<bool>(
        future: isOnBoarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else {
            final bool boolValue = snapshot.data ?? false;
            if (boolValue) {
              return const MainS();
            } else {
              return const OnBoardingS();
            }
          }
        },
      ),
    );
  }

  Future<bool> isOnBoarding() async {
    final bool value = prefs.getBool('onBoarded') ?? false;
    await Future.delayed(const Duration(seconds: 3));
    return value;
  }
}
