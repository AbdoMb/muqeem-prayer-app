import 'package:flutter/material.dart';

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({Key? key}) : super(key: key);

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDhikrIndex = 0;
  int _currentCount = 0;
  int _targetCount = 0;

  // بيانات الأذكار
  static final List<Map<String, dynamic>> adhkarCategories = [
    {
      'title': 'أذكار الصباح',
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
      'adhkar': [
        {
          'text': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
          'count': 1,
          'benefit': 'من قالها في الصباح أعتق الله رقبته من النار',
        },
        {
          'text': 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
          'count': 1,
          'benefit': 'من قالها في الصباح والمساء كان له أجر عظيم',
        },
        {
          'text': 'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
          'count': 100,
          'benefit': 'حُطَّتْ خَطَايَاهُ وَإِنْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
        },
        {
          'text': 'لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          'count': 100,
          'benefit': 'كانت له عدل عشر رقاب، وكتبت له مائة حسنة، ومحيت عنه مائة سيئة',
        },
      ],
    },
    {
      'title': 'أذكار المساء',
      'icon': Icons.nightlight_round,
      'color': Colors.indigo,
      'adhkar': [
        {
          'text': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
          'count': 1,
          'benefit': 'من قالها في المساء أعتق الله رقبته من النار',
        },
        {
          'text': 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ',
          'count': 1,
          'benefit': 'من قالها في المساء كان له أجر عظيم',
        },
        {
          'text': 'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
          'count': 100,
          'benefit': 'حُطَّتْ خَطَايَاهُ وَإِنْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
        },
        {
          'text': 'لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          'count': 100,
          'benefit': 'كانت له عدل عشر رقاب، وكتبت له مائة حسنة، ومحيت عنه مائة سيئة',
        },
      ],
    },
    {
      'title': 'أذكار النوم',
      'icon': Icons.bedtime,
      'color': Colors.blue,
      'adhkar': [
        {
          'text': 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ',
          'count': 1,
          'benefit': 'من قالها عند النوم حفظه الله من الشيطان',
        },
        {
          'text': 'اللَّهُمَّ إِنِّي أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لاَ مَلْجَأَ وَلاَ مَنْجَا مِنْكَ إِلاَّ إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ',
          'count': 1,
          'benefit': 'من قالها عند النوم مات على الفطرة',
        },
        {
          'text': 'سُبْحَانَ اللهِ',
          'count': 33,
          'benefit': 'من قالها قبل النوم غفرت ذنوبه',
        },
        {
          'text': 'الْحَمْدُ لِلَّهِ',
          'count': 33,
          'benefit': 'من قالها قبل النوم غفرت ذنوبه',
        },
        {
          'text': 'اللهُ أَكْبَرُ',
          'count': 34,
          'benefit': 'من قالها قبل النوم غفرت ذنوبه',
        },
      ],
    },
    {
      'title': 'أذكار الاستيقاظ',
      'icon': Icons.wb_sunny,
      'color': Colors.green,
      'adhkar': [
        {
          'text': 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانِي بَعْدَ مَا أَمَاتَنِي وَإِلَيْهِ النُّشُورُ',
          'count': 1,
          'benefit': 'من قالها عند الاستيقاظ كان له أجر عظيم',
        },
        {
          'text': 'لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          'count': 100,
          'benefit': 'كانت له عدل عشر رقاب، وكتبت له مائة حسنة، ومحيت عنه مائة سيئة',
        },
      ],
    },
    {
      'title': 'أذكار دخول المسجد',
      'icon': Icons.mosque,
      'color': Colors.purple,
      'adhkar': [
        {
          'text': 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
          'count': 1,
          'benefit': 'من قالها عند دخول المسجد فتحت له أبواب الرحمة',
        },
        {
          'text': 'بِسْمِ اللهِ، وَالصَّلاَةُ وَالسَّلاَمُ عَلَى رَسُولِ اللهِ، اللَّهُمَّ اغْفِرْ لِي ذُنُوبِي، وَافْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
          'count': 1,
          'benefit': 'من قالها عند دخول المسجد غفرت ذنوبه',
        },
      ],
    },
    {
      'title': 'أذكار الخروج من المسجد',
      'icon': Icons.exit_to_app,
      'color': Colors.teal,
      'adhkar': [
        {
          'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ وَرَحْمَتِكَ',
          'count': 1,
          'benefit': 'من قالها عند الخروج من المسجد كان له أجر عظيم',
        },
        {
          'text': 'بِسْمِ اللهِ، وَالصَّلاَةُ وَالسَّلاَمُ عَلَى رَسُولِ اللهِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ، اللَّهُمَّ اعْصِمْنِي مِنَ الشَّيْطَانِ الرَّجِيمِ',
          'count': 1,
          'benefit': 'من قالها عند الخروج من المسجد حفظه الله من الشيطان',
        },
      ],
    },
    {
      'title': 'أذكار الطعام',
      'icon': Icons.restaurant,
      'color': Colors.amber,
      'adhkar': [
        {
          'text': 'بِسْمِ اللهِ',
          'count': 1,
          'benefit': 'من قالها قبل الطعام بارك الله له في طعامه',
        },
        {
          'text': 'بِسْمِ اللهِ وَعَلَى بَرَكَةِ اللهِ',
          'count': 1,
          'benefit': 'من قالها قبل الطعام بارك الله له في طعامه',
        },
        {
          'text': 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلاَ قُوَّةٍ',
          'count': 1,
          'benefit': 'من قالها بعد الطعام غفرت ذنوبه',
        },
      ],
    },
    {
      'title': 'أذكار السفر',
      'icon': Icons.flight,
      'color': Colors.red,
      'adhkar': [
        {
          'text': 'اللهُ أَكْبَرُ، اللهُ أَكْبَرُ، اللهُ أَكْبَرُ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنقَلِبُونَ',
          'count': 1,
          'benefit': 'من قالها عند السفر حفظه الله في سفره',
        },
        {
          'text': 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى، اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ',
          'count': 1,
          'benefit': 'من قالها عند السفر يسر الله له سفره',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: adhkarCategories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedDhikrIndex = 0;
        _currentCount = 0;
        _targetCount = 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار والأدعية'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: adhkarCategories.map((category) {
            return Tab(
              icon: Icon(category['icon']),
              text: category['title'],
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: adhkarCategories.map((category) {
          return _buildCategoryView(category);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryView(Map<String, dynamic> category) {
    final adhkar = category['adhkar'] as List<Map<String, dynamic>>;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (category['color'] as Color).withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // عداد الذكر الحالي
          if (_targetCount > 0) ...[
            Container(
              margin: const EdgeInsets.all(16),
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
                  Text(
                    'الذكر الحالي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: category['color'],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCounterButton(
                        icon: Icons.remove,
                        onPressed: _currentCount > 0 ? () {
                          setState(() {
                            _currentCount--;
                          });
                        } : null,
                        color: category['color'],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: (category['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: category['color'] as Color),
                        ),
                        child: Text(
                          '$_currentCount / $_targetCount',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: category['color'],
                          ),
                        ),
                      ),
                      _buildCounterButton(
                        icon: Icons.add,
                        onPressed: _currentCount < _targetCount ? () {
                          setState(() {
                            _currentCount++;
                          });
                        } : null,
                        color: category['color'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: _targetCount > 0 ? _currentCount / _targetCount : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(category['color']),
                  ),
                ],
              ),
            ),
          ],
          
          // قائمة الأذكار
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: adhkar.length,
              itemBuilder: (context, index) {
                final dhikr = adhkar[index];
                final isSelected = index == _selectedDhikrIndex;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isSelected ? 4 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected 
                        ? BorderSide(color: category['color'] as Color, width: 2)
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDhikrIndex = index;
                        _currentCount = 0;
                        _targetCount = dhikr['count'] as int;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  dhikr['text'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.6,
                                    fontFamily: 'Amiri',
                                  ),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (category['color'] as Color).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${dhikr['count']}',
                                  style: TextStyle(
                                    color: category['color'],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    dhikr['benefit'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green[700],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null ? color : Colors.grey[300],
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        icon: Icon(icon, color: onPressed != null ? Colors.white : Colors.grey[600]),
        onPressed: onPressed,
      ),
    );
  }
} 