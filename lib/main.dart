import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:async';
import 'screens/prayer_times_screen.dart';
import 'screens/tasbih_screen.dart';
import 'screens/adhkar_screen.dart';
import 'screens/qibla_screen.dart';
import 'screens/asma_ul_husna_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/hijri_calendar_screen.dart';
import 'services/prayer_times_service.dart';
import 'services/adhan_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muqeem | مقيم',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Amiri',
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'DZ'),
      ],
      locale: const Locale('ar', 'DZ'),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  Map<String, String> prayerTimes = {};
  String selectedCity = 'الجزائر العاصمة';
  String currentPrayer = '';
  String nextPrayer = '';
  String timeUntilNext = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    _startTimer();
    _initializeAdhanService();
  }

  Future<void> _initializeAdhanService() async {
    await AdhanService.requestPermissions();
    await AdhanService.startAdhanService();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _loadPrayerTimes();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final times = await PrayerTimesService.getPrayerTimesMap(city: selectedCity);
      setState(() {
        prayerTimes = times;
        isLoading = false;
        _updateCurrentPrayer();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateCurrentPrayer() {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    // تحديد الصلاة الحالية والقادمة
    if (prayerTimes.isNotEmpty) {
      final prayers = ['الفجر', 'الشروق', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
      String current = '';
      String next = '';
      
      for (int i = 0; i < prayers.length; i++) {
        final prayerTime = prayerTimes[prayers[i]];
        if (prayerTime != null && currentTime.compareTo(prayerTime) < 0) {
          if (current.isEmpty) {
            current = i > 0 ? prayers[i - 1] : prayers.last;
            next = prayers[i];
          }
        }
      }
      
      if (current.isEmpty) {
        current = prayers.last;
        next = prayers.first;
      }
      
      setState(() {
        currentPrayer = current;
        nextPrayer = next;
        _calculateTimeUntilNext();
      });
    }
  }

  void _calculateTimeUntilNext() {
    if (nextPrayer.isNotEmpty && prayerTimes.containsKey(nextPrayer)) {
      final nextTime = prayerTimes[nextPrayer]!;
      final now = DateTime.now();
      final nextTimeParts = nextTime.split(':');
      final nextDateTime = DateTime(now.year, now.month, now.day, 
          int.parse(nextTimeParts[0]), int.parse(nextTimeParts[1]));
      
      final difference = nextDateTime.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      
      setState(() {
        timeUntilNext = '${hours}س ${minutes}د';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.mosque,
                      size: 32,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'مقيم',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings, color: Colors.green),
                    ),
                  ],
                ),
              ),
              
              // Date and Time
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM yyyy', 'ar').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${HijriCalendar.now().hDay} ${_getHijriMonthName(HijriCalendar.now().hMonth)} ${HijriCalendar.now().hYear}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Prayer Times
              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                )
              else
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Next Prayer Highlight
                        if (nextPrayer.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'الصلاة القادمة: $nextPrayer',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'الوقت المتبقي: $timeUntilNext',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        
                        // Prayer Times List
                        Expanded(
                          child: ListView(
                            children: [
                              _buildPrayerTimeCard('الفجر', prayerTimes['الفجر'] ?? '--:--', Icons.wb_sunny_outlined),
                              _buildPrayerTimeCard('الشروق', prayerTimes['الشروق'] ?? '--:--', Icons.wb_sunny),
                              _buildPrayerTimeCard('الظهر', prayerTimes['الظهر'] ?? '--:--', Icons.wb_sunny_outlined),
                              _buildPrayerTimeCard('العصر', prayerTimes['العصر'] ?? '--:--', Icons.wb_sunny_outlined),
                              _buildPrayerTimeCard('المغرب', prayerTimes['المغرب'] ?? '--:--', Icons.nightlight_round),
                              _buildPrayerTimeCard('العشاء', prayerTimes['العشاء'] ?? '--:--', Icons.nightlight_round),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 20),
              
              // Navigation
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNavigationCard(
                        'مواقيت الصلاة',
                        Icons.access_time,
                        Colors.blue,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrayerTimesScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNavigationCard(
                        'اتجاه القبلة',
                        Icons.explore,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QiblaScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNavigationCard(
                        'الأذكار',
                        Icons.favorite,
                        Colors.orange,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdhkarScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNavigationCard(
                        'التسبيح',
                        Icons.favorite,
                        Colors.teal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TasbihScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNavigationCard(
                        'أسماء الله الحسنى',
                        Icons.star,
                        Colors.amber,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AsmaUlHusnaScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNavigationCard(
                        'التقويم الهجري',
                        Icons.calendar_today,
                        Colors.purple,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HijriCalendarScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimeCard(String name, String time, IconData icon) {
    final isNext = name == nextPrayer;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNext ? Colors.green : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNext ? Colors.green : Colors.grey[300]!,
          width: isNext ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isNext ? Colors.white : Colors.green,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isNext ? Colors.white : Colors.black,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isNext ? Colors.white : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getHijriMonthName(int month) {
    const months = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'
    ];
    return months[month - 1];
  }
}

 