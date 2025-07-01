import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PrayerTimesService {
  static const String _selectedCityKey = 'selected_city';
  static const String _latitudeKey = 'latitude';
  static const String _longitudeKey = 'longitude';
  
  // جميع ولايات الجزائر مرتبة حسب الرقم
  static final Map<String, Map<String, double>> algerianCities = {
    '01-أدرار': {'lat': 27.8743, 'lng': -0.2939},
    '02-الشلف': {'lat': 36.1690, 'lng': 1.3317},
    '03-الأغواط': {'lat': 33.8064, 'lng': 2.8833},
    '04-أم البواقي': {'lat': 35.8794, 'lng': 7.1135},
    '05-باتنة': {'lat': 35.5500, 'lng': 6.1667},
    '06-بجاية': {'lat': 36.7509, 'lng': 5.0567},
    '07-بسكرة': {'lat': 34.8504, 'lng': 5.7280},
    '08-بشار': {'lat': 31.6167, 'lng': -2.2167},
    '09-البليدة': {'lat': 36.4700, 'lng': 2.8300},
    '10-البويرة': {'lat': 36.3763, 'lng': 3.9000},
    '11-تمنراست': {'lat': 22.7850, 'lng': 5.5228},
    '12-تبسة': {'lat': 35.4042, 'lng': 8.1242},
    '13-تلمسان': {'lat': 34.8828, 'lng': -1.3160},
    '14-تيارت': {'lat': 35.3711, 'lng': 1.3211},
    '15-تيزي وزو': {'lat': 36.7167, 'lng': 4.0500},
    '16-الجزائر العاصمة': {'lat': 36.7538, 'lng': 3.0588},
    '17-الجلفة': {'lat': 34.6667, 'lng': 3.2500},
    '18-جيجل': {'lat': 36.8206, 'lng': 5.7667},
    '19-سطيف': {'lat': 36.1911, 'lng': 5.4136},
    '20-سعيدة': {'lat': 34.8415, 'lng': 0.1456},
    '21-سكيكدة': {'lat': 36.8796, 'lng': 6.9063},
    '22-سيدي بلعباس': {'lat': 35.2083, 'lng': -0.6333},
    '23-عنابة': {'lat': 36.9000, 'lng': 7.7667},
    '24-قالمة': {'lat': 36.4625, 'lng': 7.4333},
    '25-قسنطينة': {'lat': 36.3650, 'lng': 6.6147},
    '26-المدية': {'lat': 36.2667, 'lng': 2.7500},
    '27-مستغانم': {'lat': 35.9333, 'lng': 0.0833},
    '28-المسيلة': {'lat': 35.7000, 'lng': 4.5500},
    '29-معسكر': {'lat': 35.4000, 'lng': 0.1333},
    '30-ورقلة': {'lat': 31.9500, 'lng': 5.3167},
    '31-وهران': {'lat': 35.6971, 'lng': -0.6337},
    '32-البيض': {'lat': 33.6833, 'lng': 1.0167},
    '33-إليزي': {'lat': 26.4833, 'lng': 8.4667},
    '34-برج بوعريريج': {'lat': 36.0667, 'lng': 4.7667},
    '35-بومرداس': {'lat': 36.8167, 'lng': 3.4833},
    '36-الطارف': {'lat': 36.7667, 'lng': 8.3167},
    '37-تندوف': {'lat': 27.6741, 'lng': -8.1477},
    '38-تيسمسيلت': {'lat': 35.6167, 'lng': 1.8167},
    '39-الوادي': {'lat': 33.3683, 'lng': 6.8674},
    '40-خنشلة': {'lat': 35.4333, 'lng': 7.1500},
    '41-سوق أهراس': {'lat': 36.2833, 'lng': 7.9500},
    '42-تيبازة': {'lat': 36.5833, 'lng': 2.4500},
    '43-ميلة': {'lat': 36.4500, 'lng': 6.2667},
    '44-عين الدفلى': {'lat': 36.2667, 'lng': 1.9667},
    '45-النعامة': {'lat': 33.2667, 'lng': -0.3167},
    '46-عين تموشنت': {'lat': 35.3000, 'lng': -1.1333},
    '47-غرداية': {'lat': 32.4894, 'lng': 3.6731},
    '48-غليزان': {'lat': 35.7500, 'lng': 0.5500},
    '49-تيميمون': {'lat': 29.2500, 'lng': 0.2333},
    '50-برج باجي مختار': {'lat': 21.3333, 'lng': 1.0167},
    '51-أولاد جلال': {'lat': 34.4167, 'lng': 5.9167},
    '52-بني عباس': {'lat': 30.1333, 'lng': -2.1667},
    '53-إن صالح': {'lat': 27.2167, 'lng': 2.4667},
    '54-عين قزام': {'lat': 19.5667, 'lng': 5.7500},
    '55-تقرت': {'lat': 33.1167, 'lng': 6.0833},
    '56-جانت': {'lat': 24.5500, 'lng': 9.4833},
    '57-المغير': {'lat': 33.9500, 'lng': 5.9167},
    '58-المنيعة': {'lat': 30.5833, 'lng': 2.8833},
  };

  static List<String> getCities() => algerianCities.keys.toList();

  static Future<void> saveSelectedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedCityKey, city);
  }

  static Future<String> getSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedCityKey) ?? '16-الجزائر العاصمة';
  }

  static Future<Coordinates> getCoordinates({String? city}) async {
    if (city != null && algerianCities.containsKey(city)) {
      final coords = algerianCities[city]!;
      return Coordinates(coords['lat']!, coords['lng']!);
    }
    
    // إذا لم يتم تحديد مدينة، استخدم الموقع الحالي
    try {
      if (kIsWeb) {
        // على الويب، استخدم إحداثيات الجزائر العاصمة كافتراضي
        return Coordinates(36.7538, 3.0588);
      }
      
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return Coordinates(position.latitude, position.longitude);
    } catch (e) {
      // في حالة الخطأ، استخدم إحداثيات الجزائر العاصمة
      return Coordinates(36.7538, 3.0588);
    }
  }

  static CalculationParameters getAlgeriaParams() {
    // الجزائر تعتمد غالباً على رابطة العالم الإسلامي
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    return params;
  }

  static Future<PrayerTimes?> getPrayerTimes({String? city, DateTime? date}) async {
    final coords = await getCoordinates(city: city);
    final params = getAlgeriaParams();
    final dateComponents = DateComponents.from(date ?? DateTime.now());
    return PrayerTimes(coords, dateComponents, params);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  // مثال: جلب مواقيت الصلاة كنصوص
  static Future<Map<String, String>> getPrayerTimesMap({String? city, DateTime? date}) async {
    final prayerTimes = await getPrayerTimes(city: city, date: date);
    if (prayerTimes == null) return {};
    return {
      'الفجر': formatTime(prayerTimes.fajr),
      'الشروق': formatTime(prayerTimes.sunrise),
      'الظهر': formatTime(prayerTimes.dhuhr),
      'العصر': formatTime(prayerTimes.asr),
      'المغرب': formatTime(prayerTimes.maghrib),
      'العشاء': formatTime(prayerTimes.isha),
    };
  }

  // الحصول على الصلاة الحالية
  static String getCurrentPrayer(Map<String, String> prayerTimes) {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    // تحديد الصلاة الحالية
    if (prayerTimes.containsKey('الفجر') && currentTime.compareTo(prayerTimes['الفجر']!) < 0) {
      return 'العشاء';
    } else if (prayerTimes.containsKey('الظهر') && currentTime.compareTo(prayerTimes['الظهر']!) < 0) {
      return 'الفجر';
    } else if (prayerTimes.containsKey('العصر') && currentTime.compareTo(prayerTimes['العصر']!) < 0) {
      return 'الظهر';
    } else if (prayerTimes.containsKey('المغرب') && currentTime.compareTo(prayerTimes['المغرب']!) < 0) {
      return 'العصر';
    } else if (prayerTimes.containsKey('العشاء') && currentTime.compareTo(prayerTimes['العشاء']!) < 0) {
      return 'المغرب';
    } else {
      return 'العشاء';
    }
  }

  // الحصول على الوقت المتبقي للصلاة التالية
  static String getTimeUntilNextPrayer(Map<String, String> prayerTimes) {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    String nextPrayerTime = '';
    String prayerName = '';
    
    if (prayerTimes.containsKey('الفجر') && currentTime.compareTo(prayerTimes['الفجر']!) < 0) {
      nextPrayerTime = prayerTimes['الفجر']!;
      prayerName = 'الفجر';
    } else if (prayerTimes.containsKey('الظهر') && currentTime.compareTo(prayerTimes['الظهر']!) < 0) {
      nextPrayerTime = prayerTimes['الظهر']!;
      prayerName = 'الظهر';
    } else if (prayerTimes.containsKey('العصر') && currentTime.compareTo(prayerTimes['العصر']!) < 0) {
      nextPrayerTime = prayerTimes['العصر']!;
      prayerName = 'العصر';
    } else if (prayerTimes.containsKey('المغرب') && currentTime.compareTo(prayerTimes['المغرب']!) < 0) {
      nextPrayerTime = prayerTimes['المغرب']!;
      prayerName = 'المغرب';
    } else if (prayerTimes.containsKey('العشاء') && currentTime.compareTo(prayerTimes['العشاء']!) < 0) {
      nextPrayerTime = prayerTimes['العشاء']!;
      prayerName = 'العشاء';
    } else {
      // إذا كان الوقت بعد العشاء، فالوقت المتبقي للفجر غداً
      nextPrayerTime = prayerTimes['الفجر']!;
      prayerName = 'الفجر';
    }
    
    // حساب الوقت المتبقي
    final nextTimeParts = nextPrayerTime.split(':');
    final nextPrayerDateTime = DateTime(now.year, now.month, now.day, 
        int.parse(nextTimeParts[0]), int.parse(nextTimeParts[1]));
    
    if (nextPrayerDateTime.isBefore(now)) {
      // إذا كان الوقت المتبقي للغد
      final tomorrow = now.add(const Duration(days: 1));
      final nextPrayerTomorrow = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 
          int.parse(nextTimeParts[0]), int.parse(nextTimeParts[1]));
      final difference = nextPrayerTomorrow.difference(now);
      return '${difference.inHours} ساعة و ${difference.inMinutes % 60} دقيقة';
    } else {
      final difference = nextPrayerDateTime.difference(now);
      return '${difference.inHours} ساعة و ${difference.inMinutes % 60} دقيقة';
    }
  }
} 