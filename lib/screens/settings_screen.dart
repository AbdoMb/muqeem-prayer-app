import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/prayer_times_service.dart';
import '../services/adhan_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedCity = '16-الجزائر العاصمة';
  bool notificationsEnabled = true;
  bool autoLocation = false;
  bool gpsEnabled = false;
  bool adhanSound = true;
  bool vibrationEnabled = true;
  bool advancedNotifications = false;
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadCities();
    _checkGPSStatus();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('dark_mode') ?? false;
      selectedCity = prefs.getString('selected_city') ?? '16-الجزائر العاصمة';
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      autoLocation = prefs.getBool('auto_location') ?? false;
      gpsEnabled = prefs.getBool('gps_enabled') ?? false;
      adhanSound = prefs.getBool('adhan_sound') ?? true;
      vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      advancedNotifications = prefs.getBool('advanced_notifications') ?? false;
    });
  }

  Future<void> _loadCities() async {
    cities = PrayerTimesService.getCities();
  }

  Future<void> _checkGPSStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      gpsEnabled = serviceEnabled;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDarkMode);
    await prefs.setString('selected_city', selectedCity);
    await prefs.setBool('notifications_enabled', notificationsEnabled);
    await prefs.setBool('auto_location', autoLocation);
    await prefs.setBool('gps_enabled', gpsEnabled);
    await prefs.setBool('adhan_sound', adhanSound);
    await prefs.setBool('vibration_enabled', vibrationEnabled);
    await prefs.setBool('advanced_notifications', advancedNotifications);
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('يجب السماح بالوصول إلى الموقع لاستخدام هذه الميزة');
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _showSnackBar('تم رفض صلاحيات الموقع بشكل دائم');
      return;
    }

    setState(() {
      gpsEnabled = true;
    });
    _saveSettings();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // إعدادات المظهر
            _buildSectionCard(
              title: 'المظهر',
              icon: Icons.palette,
              children: [
                SwitchListTile(
                  title: const Text('الوضع المظلم'),
                  subtitle: const Text('تفعيل المظهر الداكن'),
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                    _saveSettings();
                    _showSnackBar('تم حفظ الإعدادات');
                  },
                  secondary: const Icon(Icons.dark_mode),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // إعدادات الموقع
            _buildSectionCard(
              title: 'الموقع',
              icon: Icons.location_on,
              children: [
                ListTile(
                  title: const Text('المدينة المختارة'),
                  subtitle: Text(selectedCity.split('-')[1]),
                  leading: const Icon(Icons.location_city),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showCityDialog();
                  },
                ),
                SwitchListTile(
                  title: const Text('تحديد الموقع تلقائياً'),
                  subtitle: const Text('استخدام GPS لتحديد الموقع'),
                  value: autoLocation,
                  onChanged: (value) {
                    if (value && !gpsEnabled) {
                      _requestLocationPermission();
                    } else {
                      setState(() {
                        autoLocation = value;
                      });
                      _saveSettings();
                      _showSnackBar('تم حفظ الإعدادات');
                    }
                  },
                  secondary: const Icon(Icons.gps_fixed),
                ),
                ListTile(
                  title: const Text('حالة GPS'),
                  subtitle: Text(gpsEnabled ? 'مفعل' : 'غير مفعل'),
                  leading: Icon(
                    gpsEnabled ? Icons.gps_fixed : Icons.gps_off,
                    color: gpsEnabled ? Colors.green : Colors.red,
                  ),
                  trailing: gpsEnabled ? null : TextButton(
                    onPressed: _requestLocationPermission,
                    child: const Text('تفعيل'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // إعدادات الإشعارات
            _buildSectionCard(
              title: 'الإشعارات',
              icon: Icons.notifications,
              children: [
                SwitchListTile(
                  title: const Text('تفعيل الإشعارات'),
                  subtitle: const Text('إشعارات مواقيت الصلاة'),
                  value: notificationsEnabled,
                  onChanged: (value) async {
                    setState(() {
                      notificationsEnabled = value;
                    });
                    _saveSettings();
                    
                    if (value) {
                      await AdhanService.startAdhanService();
                    } else {
                      await AdhanService.stopAdhanService();
                    }
                    
                    _showSnackBar('تم حفظ الإعدادات');
                  },
                  secondary: const Icon(Icons.notifications_active),
                ),
                SwitchListTile(
                  title: const Text('إعدادات الإشعارات المتقدمة'),
                  subtitle: const Text('تخصيص الإشعارات والأذان'),
                  value: advancedNotifications,
                  onChanged: (value) {
                    setState(() {
                      advancedNotifications = value;
                    });
                    _saveSettings();
                    _showSnackBar('تم حفظ الإعدادات');
                  },
                  secondary: const Icon(Icons.settings),
                ),
                if (advancedNotifications) ...[
                  SwitchListTile(
                    title: const Text('صوت الأذان'),
                    subtitle: const Text('تشغيل صوت الأذان عند دخول الوقت'),
                    value: adhanSound,
                    onChanged: (value) {
                      setState(() {
                        adhanSound = value;
                      });
                      _saveSettings();
                      _showSnackBar('تم حفظ الإعدادات');
                    },
                    secondary: const Icon(Icons.volume_up),
                  ),
                  SwitchListTile(
                    title: const Text('الاهتزاز'),
                    subtitle: const Text('اهتزاز الهاتف عند دخول وقت الصلاة'),
                    value: vibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        vibrationEnabled = value;
                      });
                      _saveSettings();
                      _showSnackBar('تم حفظ الإعدادات');
                    },
                    secondary: const Icon(Icons.vibration),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 16),
            
            // معلومات التطبيق
            _buildSectionCard(
              title: 'معلومات التطبيق',
              icon: Icons.info,
              children: [
                ListTile(
                  title: const Text('إصدار التطبيق'),
                  subtitle: const Text('1.0.0'),
                  leading: const Icon(Icons.app_settings_alt),
                ),
                ListTile(
                  title: const Text('حول التطبيق'),
                  subtitle: const Text('معلومات عن مقيم'),
                  leading: const Icon(Icons.info_outline),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
                ListTile(
                  title: const Text('سياسة الخصوصية'),
                  subtitle: const Text('قراءة سياسة الخصوصية'),
                  leading: const Icon(Icons.privacy_tip),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showPrivacyPolicy();
                  },
                ),
                ListTile(
                  title: const Text('شروط الاستخدام'),
                  subtitle: const Text('قراءة شروط الاستخدام'),
                  leading: const Icon(Icons.description),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showTermsOfService();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // دعم التطبيق
            _buildSectionCard(
              title: 'الدعم',
              icon: Icons.support_agent,
              children: [
                ListTile(
                  title: const Text('تواصل معنا'),
                  subtitle: const Text('إرسال رسالة للدعم'),
                  leading: const Icon(Icons.email),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showContactDialog();
                  },
                ),
                ListTile(
                  title: const Text('تقييم التطبيق'),
                  subtitle: const Text('ساعدنا بتحسين التطبيق'),
                  leading: const Icon(Icons.star),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showSnackBar('سيتم إضافة هذه الميزة قريباً');
                  },
                ),
                ListTile(
                  title: const Text('مشاركة التطبيق'),
                  subtitle: const Text('شارك التطبيق مع الأصدقاء'),
                  leading: const Icon(Icons.share),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showSnackBar('سيتم إضافة هذه الميزة قريباً');
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // زر إعادة تعيين الإعدادات
            ElevatedButton.icon(
              onPressed: () {
                _showResetDialog();
              },
              icon: const Icon(Icons.restore),
              label: const Text('إعادة تعيين الإعدادات'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.green, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showCityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر الولاية'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return ListTile(
                title: Text(city.split('-')[1]),
                subtitle: Text('ولاية رقم ${city.split('-')[0]}'),
                trailing: selectedCity == city ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  setState(() {
                    selectedCity = city;
                  });
                  _saveSettings();
                  Navigator.pop(context);
                  _showSnackBar('تم تغيير الولاية');
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول مقيم'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مقيم - تطبيق إسلامي شامل',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('تطبيق مجاني للمسلمين في الجزائر'),
            SizedBox(height: 8),
            Text('المميزات:'),
            Text('• مواقيت الصلاة الدقيقة'),
            Text('• اتجاه القبلة'),
            Text('• الأذكار والأدعية'),
            Text('• التسبيح'),
            Text('• أسماء الله الحسنى'),
            Text('• التقويم الهجري'),
            SizedBox(height: 8),
            Text('الإصدار: 1.0.0'),
            Text('المطور: فريق مقيم'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سياسة الخصوصية لتطبيق مقيم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('نحن نحترم خصوصيتك ونلتزم بحماية معلوماتك الشخصية.'),
              SizedBox(height: 8),
              Text('المعلومات التي نجمعها:'),
              Text('• معلومات الموقع لتحديد مواقيت الصلاة'),
              Text('• إعدادات التطبيق المحفوظة محلياً'),
              SizedBox(height: 8),
              Text('كيفية استخدام المعلومات:'),
              Text('• لحساب مواقيت الصلاة بدقة'),
              Text('• لتحسين تجربة المستخدم'),
              Text('• لتخصيص الإعدادات'),
              SizedBox(height: 8),
              Text('نحن لا نشارك معلوماتك مع أي طرف ثالث.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('شروط الاستخدام'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'شروط الاستخدام لتطبيق مقيم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('باستخدام هذا التطبيق، فإنك توافق على الشروط التالية:'),
              SizedBox(height: 8),
              Text('1. الاستخدام المقبول:'),
              Text('• استخدام التطبيق للأغراض الدينية فقط'),
              Text('• عدم إساءة استخدام التطبيق'),
              SizedBox(height: 8),
              Text('2. الدقة:'),
              Text('• نحن نبذل قصارى جهدنا لتوفير معلومات دقيقة'),
              Text('• لا نضمن دقة 100% لمواقيت الصلاة'),
              SizedBox(height: 8),
              Text('3. المسؤولية:'),
              Text('• المستخدم مسؤول عن استخدام التطبيق'),
              Text('• لا نتحمل مسؤولية أي أضرار'),
              SizedBox(height: 8),
              Text('4. التحديثات:'),
              Text('• قد نحدث هذه الشروط من وقت لآخر'),
              Text('• سيتم إخطارك بأي تغييرات مهمة'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تواصل معنا'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر سبب التواصل:'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'سبب التواصل',
              ),
              items: const [
                DropdownMenuItem(value: 'مشكلة', child: Text('مشكلة في التطبيق')),
                DropdownMenuItem(value: 'عطل', child: Text('عطل تقني')),
                DropdownMenuItem(value: 'فكرة', child: Text('فكرة جديدة')),
                DropdownMenuItem(value: 'استفسار', child: Text('استفسار عام')),
                DropdownMenuItem(value: 'أخرى', child: Text('أخرى')),
              ],
              onChanged: (value) {
                subjectController.text = value ?? '';
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'وصف المشكلة أو الرسالة',
                hintText: 'اكتب تفاصيل مشكلتك أو رسالتك هنا...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (subjectController.text.isNotEmpty && messageController.text.isNotEmpty) {
                final email = 'noobbot15dz@gmail.com';
                final subject = 'مقيم - ${subjectController.text}';
                final body = messageController.text;
                
                final url = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
                
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                  Navigator.pop(context);
                  _showSnackBar('تم فتح تطبيق البريد الإلكتروني');
                } else {
                  _showSnackBar('لا يمكن فتح تطبيق البريد الإلكتروني');
                }
              } else {
                _showSnackBar('يرجى ملء جميع الحقول');
              }
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة تعيين الإعدادات'),
        content: const Text('هل أنت متأكد من إعادة تعيين جميع الإعدادات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              setState(() {
                isDarkMode = false;
                selectedCity = '16-الجزائر العاصمة';
                notificationsEnabled = true;
                autoLocation = false;
                gpsEnabled = false;
                adhanSound = true;
                vibrationEnabled = true;
                advancedNotifications = false;
              });
              Navigator.pop(context);
              _showSnackBar('تم إعادة تعيين الإعدادات');
            },
            child: const Text('إعادة تعيين', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 