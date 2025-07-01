import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'prayer_times_service.dart';

class AdhanService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static Timer? _timer;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Skip notifications on web platform
    if (kIsWeb) {
      _isInitialized = true;
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _isInitialized = true;
  }

  static Future<void> startAdhanService() async {
    await initialize();
    
    // Skip timer on web platform
    if (kIsWeb) return;
    
    // إيقاف المؤقت السابق إذا كان موجوداً
    _timer?.cancel();
    
    // بدء المؤقت للتحقق من مواقيت الصلاة كل دقيقة
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkPrayerTimes();
    });
  }

  static Future<void> stopAdhanService() async {
    if (kIsWeb) return;
    
    _timer?.cancel();
    await _notifications.cancelAll();
  }

  static Future<void> _checkPrayerTimes() async {
    if (kIsWeb) return;
    
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    final advancedNotifications = prefs.getBool('advanced_notifications') ?? false;
    
    if (!notificationsEnabled) return;

    final selectedCity = prefs.getString('selected_city') ?? '16-الجزائر العاصمة';
    final prayerTimes = await PrayerTimesService.getPrayerTimesMap(city: selectedCity);
    
    if (prayerTimes.isEmpty) return;

    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    // التحقق من كل صلاة
    final prayers = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
    
    for (final prayer in prayers) {
      final prayerTime = prayerTimes[prayer];
      if (prayerTime == null) continue;
      
      final prayerTimeParts = prayerTime.split(':');
      final prayerDateTime = DateTime(now.year, now.month, now.day, 
          int.parse(prayerTimeParts[0]), int.parse(prayerTimeParts[1]));
      
      // التحقق من الوقت الحالي مع دقة دقيقة واحدة
      final difference = prayerDateTime.difference(now).inMinutes;
      
      if (difference == 0) {
        // وقت الصلاة
        await _showPrayerNotification(prayer, true);
      } else if (difference == 5 && advancedNotifications) {
        // تنبيه قبل 5 دقائق
        await _showPrayerNotification(prayer, false);
      }
    }
  }

  static Future<void> _showPrayerNotification(String prayer, bool isPrayerTime) async {
    if (kIsWeb) return;
    
    final prefs = await SharedPreferences.getInstance();
    final adhanSound = prefs.getBool('adhan_sound') ?? true;
    final vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    
    String title;
    String body;
    
    if (isPrayerTime) {
      title = 'حان الآن موعد $prayer';
      body = 'حان الآن موعد صلاة $prayer، أقم الصلاة';
    } else {
      title = 'تنبيه: $prayer';
      body = 'سيحين موعد صلاة $prayer خلال 5 دقائق';
    }

    const androidDetails = AndroidNotificationDetails(
      'prayer_times',
      'مواقيت الصلاة',
      channelDescription: 'إشعارات مواقيت الصلاة والأذان',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      prayer.hashCode,
      title,
      body,
      details,
    );

    // اهتزاز الهاتف
    if (vibrationEnabled && !kIsWeb) {
      try {
        if (isPrayerTime) {
          // اهتزاز طويل لوقت الصلاة
          Vibration.vibrate(duration: 1000);
        } else {
          // اهتزاز قصير للتنبيه
          Vibration.vibrate(duration: 500);
        }
      } catch (e) {
        // Ignore vibration errors
      }
    }
  }

  static Future<void> requestPermissions() async {
    if (kIsWeb) return;
    
    await initialize();
    
    final androidGranted = await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    final iosGranted = await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    
    return;
  }

  static Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;
    await _notifications.cancelAll();
  }

  static Future<void> cancelPrayerNotification(String prayer) async {
    if (kIsWeb) return;
    await _notifications.cancel(prayer.hashCode);
  }
} 