import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/words_data.dart';
import '../models/heritage_word.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation('Asia/Riyadh'),
    ); 

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // لما اللاعب يضغط على الإشعار
        if (response.payload == 'daily_challenge') {
          print("🔥 اللاعب ضغط على الإشعار! جاري التوجيه...");

          HeritageWord? challengeWord = WordsData.getNextWord(
            selectedRegion: Region.south,
            selectedDifficulty: Difficulty.hard,
          );

          if (challengeWord != null) {}
        }
      },
    );

    // طلب إذن الإشعارات (Android 13+) وإذن المنبهات الدقيقة (Android 12+)
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
    }
  }

  static Future<void> showInstantChallengeNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_channel',
          'التحديات اليومية',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    await _notificationsPlugin.show(
      id: 0,
      title: 'تحدي اليومي نزل يا ذيب! 🔥 (فوري)',
      body: 'كلمة اليوم من الجنوب وصعوبتها (صعب) 🏔️.. تقدر تكسر الرقم؟',
      notificationDetails: NotificationDetails(android: androidDetails),
      payload: 'daily_challenge',
    );
  }

  static Future<void> scheduleDailyChallenge() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'scheduled_daily_channel',
          'التحديات المجدولة',
          importance: Importance.max,
          priority: Priority.high,
        );

    await _notificationsPlugin.zonedSchedule(
      id: 10,
      title: 'تحدي اليومي نزل يا ذيب!',
      body: 'كلمة اليوم من الجنوب وصعوبتها (صعب) 🏔️.. تقدر تكسر الرقم؟',
      scheduledDate: _nextInstanceOfTime(20, 5), // مبرمجة على الساعة 7:55 مساءً للتجربة
      notificationDetails: const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time, // تكرار يومي في نفس الوقت
      payload: 'daily_challenge', // نفس الـ payload عشان يوجهه لنفس الشاشة
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
