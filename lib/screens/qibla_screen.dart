import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with TickerProviderStateMixin {
  double? _direction;
  double? _qiblaDirection;
  bool _isLoading = true;
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  // إحداثيات الكعبة المشرفة
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _initializeCompass();
    _calculateQiblaDirection();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeCompass() async {
    try {
      // على الويب، استخدم إحداثيات افتراضية
      if (kIsWeb) {
        setState(() {
          _direction = 0; // شمال
          _isLoading = false;
        });
        return;
      }

      // التحقق من صلاحيات الموقع
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'يجب السماح بالوصول إلى الموقع لمعرفة اتجاه القبلة';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'تم رفض صلاحيات الموقع بشكل دائم';
          _isLoading = false;
        });
        return;
      }

      // بدء الاستماع للبوصلة
      FlutterCompass.events?.listen((event) {
        setState(() {
          _direction = event.heading;
          _isLoading = false;
        });
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في البوصلة: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _calculateQiblaDirection() async {
    try {
      Position position;
      
      if (kIsWeb) {
        // على الويب، استخدم إحداثيات الجزائر العاصمة
        position = Position(
          latitude: 36.7538,
          longitude: 3.0588,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      } else {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }

      // حساب اتجاه القبلة
      double qiblaAngle = _calculateQiblaAngle(
        position.latitude,
        position.longitude,
        kaabaLat,
        kaabaLng,
      );

      setState(() {
        _qiblaDirection = qiblaAngle;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'لا يمكن الحصول على الموقع الحالي';
      });
    }
  }

  double _calculateQiblaAngle(double lat1, double lng1, double lat2, double lng2) {
    // تحويل الدرجات إلى راديان
    double lat1Rad = lat1 * math.pi / 180;
    double lng1Rad = lng1 * math.pi / 180;
    double lat2Rad = lat2 * math.pi / 180;
    double lng2Rad = lng2 * math.pi / 180;

    // حساب الفرق في الطول
    double deltaLng = lng2Rad - lng1Rad;

    // حساب اتجاه القبلة
    double y = math.sin(deltaLng) * math.cos(lat2Rad);
    double x = math.cos(lat1Rad) * math.sin(lat2Rad) - 
               math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(deltaLng);
    
    double qiblaAngle = math.atan2(y, x) * 180 / math.pi;
    
    // تحويل إلى اتجاه شمالي
    return (qiblaAngle + 360) % 360;
  }

  double _getRotationAngle() {
    if (_direction == null || _qiblaDirection == null) return 0;
    
    // حساب زاوية الدوران المطلوبة
    double rotation = _qiblaDirection! - _direction!;
    if (rotation < 0) rotation += 360;
    
    return rotation * math.pi / 180;
  }

  String _getDirectionName(double angle) {
    if (angle >= 315 || angle < 45) return 'شمال';
    if (angle >= 45 && angle < 135) return 'شرق';
    if (angle >= 135 && angle < 225) return 'جنوب';
    if (angle >= 225 && angle < 315) return 'غرب';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اتجاه القبلة'),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.green))
            : _errorMessage.isNotEmpty
                ? _buildErrorMessage()
                : _buildCompassView(),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = '';
                });
                _initializeCompass();
                _calculateQiblaDirection();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompassView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        
        // تعليمات
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue),
          ),
          child: Column(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 24),
              const SizedBox(height: 8),
              Text(
                kIsWeb 
                  ? 'هذا عرض تجريبي للقبلة. على الهاتف ستعمل البوصلة بشكل دقيق.'
                  : 'حرك الهاتف في اتجاه السهم الأخضر لمعرفة اتجاه القبلة',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 30),
        
        // البوصلة
        Expanded(
          child: Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // الاتجاهات
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: const Text(
                      'شمال',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: const Text(
                      'جنوب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 10,
                    child: const Center(
                      child: Text(
                        'غرب',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 10,
                    child: const Center(
                      child: Text(
                        'شرق',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  
                  // السهم الأخضر
                  Center(
                    child: Transform.rotate(
                      angle: _getRotationAngle(),
                      child: Container(
                        width: 4,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.green,
                              Colors.green.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  
                  // نقطة مركزية
                  Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // معلومات إضافية
        if (_qiblaDirection != null) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'اتجاه القبلة: ${_qiblaDirection!.toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'الاتجاه: ${_getDirectionName(_qiblaDirection!)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
} 