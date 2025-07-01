import 'package:flutter/material.dart';

class AsmaUlHusnaScreen extends StatefulWidget {
  const AsmaUlHusnaScreen({Key? key}) : super(key: key);

  @override
  State<AsmaUlHusnaScreen> createState() => _AsmaUlHusnaScreenState();
}

class _AsmaUlHusnaScreenState extends State<AsmaUlHusnaScreen> {
  int selectedNameIndex = -1;

  // أسماء الله الحسنى الـ 99
  static final List<Map<String, dynamic>> asmaUlHusna = [
    {'name': 'الله', 'arabic': 'الله', 'english': 'Allah', 'meaning': 'الله تعالى', 'description': 'الاسم الأعظم الذي لا يسمى به غيره', 'color': Colors.purple},
    {'name': 'الرَّحْمَٰنُ', 'arabic': 'الرَّحْمَٰنُ', 'english': 'Ar-Rahman', 'meaning': 'الرحمن', 'description': 'الذي وسعت رحمته كل شيء', 'color': Colors.blue},
    {'name': 'الرَّحِيمُ', 'arabic': 'الرَّحِيمُ', 'english': 'Ar-Raheem', 'meaning': 'الرحيم', 'description': 'الذي يرحم عباده المؤمنين', 'color': Colors.green},
    {'name': 'الْمَلِكُ', 'arabic': 'الْمَلِكُ', 'english': 'Al-Malik', 'meaning': 'الملك', 'description': 'المالك لكل شيء والمتصرف فيه', 'color': Colors.amber},
    {'name': 'الْقُدُّوسُ', 'arabic': 'الْقُدُّوسُ', 'english': 'Al-Quddus', 'meaning': 'القدوس', 'description': 'الطاهر من كل عيب ونقص', 'color': Colors.indigo},
    {'name': 'السَّلَامُ', 'arabic': 'السَّلَامُ', 'english': 'As-Salam', 'meaning': 'السلام', 'description': 'المسلم من كل عيب وآفة', 'color': Colors.teal},
    {'name': 'الْمُؤْمِنُ', 'arabic': 'الْمُؤْمِنُ', 'english': 'Al-Mu\'min', 'meaning': 'المؤمن', 'description': 'المؤمن لعباده من كل خوف', 'color': Colors.orange},
    {'name': 'الْمُهَيْمِنُ', 'arabic': 'الْمُهَيْمِنُ', 'english': 'Al-Muhaymin', 'meaning': 'المهيمن', 'description': 'الشاهد على خلقه بأعمالهم', 'color': Colors.red},
    {'name': 'الْعَزِيزُ', 'arabic': 'الْعَزِيزُ', 'english': 'Al-Aziz', 'meaning': 'العزيز', 'description': 'الذي لا يغلب ولا يرد أمره', 'color': Colors.pink},
    {'name': 'الْجَبَّارُ', 'arabic': 'الْجَبَّارُ', 'english': 'Al-Jabbar', 'meaning': 'الجبار', 'description': 'الذي يجبر كسر الضعفاء', 'color': Colors.brown},
    {'name': 'الْمُتَكَبِّرُ', 'arabic': 'الْمُتَكَبِّرُ', 'english': 'Al-Mutakabbir', 'meaning': 'المتكبر', 'description': 'المتعالي عن صفات الخلق', 'color': Colors.cyan},
    {'name': 'الْخَالِقُ', 'arabic': 'الْخَالِقُ', 'english': 'Al-Khaliq', 'meaning': 'الخالق', 'description': 'الذي خلق كل شيء فقدره تقديراً', 'color': Colors.deepPurple},
    {'name': 'الْبَارِئُ', 'arabic': 'الْبَارِئُ', 'english': 'Al-Bari', 'meaning': 'البارئ', 'description': 'الذي خلق الخلق من غير مثال', 'color': Colors.deepOrange},
    {'name': 'الْمُصَوِّرُ', 'arabic': 'الْمُصَوِّرُ', 'english': 'Al-Musawwir', 'meaning': 'المصور', 'description': 'الذي صور جميع الموجودات', 'color': Colors.lime},
    {'name': 'الْغَفَّارُ', 'arabic': 'الْغَفَّارُ', 'english': 'Al-Ghaffar', 'meaning': 'الغفار', 'description': 'الذي يغفر الذنوب ويستر العيوب', 'color': Colors.lightBlue},
    {'name': 'الْقَهَّارُ', 'arabic': 'الْقَهَّارُ', 'english': 'Al-Qahhar', 'meaning': 'القهار', 'description': 'الذي قهر كل شيء وغلبه', 'color': Colors.greenAccent},
    {'name': 'الْوَهَّابُ', 'arabic': 'الْوَهَّابُ', 'english': 'Al-Wahhab', 'meaning': 'الوهاب', 'description': 'الذي يهب العطايا بلا عوض', 'color': Colors.cyanAccent},
    {'name': 'الرَّزَّاقُ', 'arabic': 'الرَّزَّاقُ', 'english': 'Ar-Razzaq', 'meaning': 'الرزاق', 'description': 'الذي يرزق الخلق كافة', 'color': Colors.pinkAccent},
    {'name': 'الْفَتَّاحُ', 'arabic': 'الْفَتَّاحُ', 'english': 'Al-Fattah', 'meaning': 'الفتاح', 'description': 'الذي يفتح أبواب الرزق والرحمة', 'color': Colors.orangeAccent},
    {'name': 'الْعَلِيمُ', 'arabic': 'الْعَلِيمُ', 'english': 'Al-Alim', 'meaning': 'العليم', 'description': 'الذي يعلم كل شيء', 'color': Colors.blueGrey},
    {'name': 'الْقَابِضُ', 'arabic': 'الْقَابِضُ', 'english': 'Al-Qabid', 'meaning': 'القابض', 'description': 'الذي يقبض الأرزاق والأرواح', 'color': Colors.deepPurpleAccent},
    {'name': 'الْبَاسِطُ', 'arabic': 'الْبَاسِطُ', 'english': 'Al-Basit', 'meaning': 'الباسط', 'description': 'الذي يبسط الرزق لمن يشاء', 'color': Colors.lightGreen},
    {'name': 'الْخَافِضُ', 'arabic': 'الْخَافِضُ', 'english': 'Al-Khafid', 'meaning': 'الخافض', 'description': 'الذي يخفض الجبارين والمتكبرين', 'color': Colors.redAccent},
    {'name': 'الرَّافِعُ', 'arabic': 'الرَّافِعُ', 'english': 'Ar-Rafi', 'meaning': 'الرافع', 'description': 'الذي يرفع المؤمنين بالطاعات', 'color': Colors.blueAccent},
    {'name': 'الْمُعِزُّ', 'arabic': 'الْمُعِزُّ', 'english': 'Al-Mu\'izz', 'meaning': 'المعز', 'description': 'الذي يعز من يشاء من عباده', 'color': Colors.amberAccent},
    {'name': 'الْمُذِلُّ', 'arabic': 'الْمُذِلُّ', 'english': 'Al-Mudhill', 'meaning': 'المذل', 'description': 'الذي يذل من يشاء من خلقه', 'color': Colors.grey},
    {'name': 'السَّمِيعُ', 'arabic': 'السَّمِيعُ', 'english': 'As-Sami', 'meaning': 'السميع', 'description': 'الذي يسمع كل شيء', 'color': Colors.indigoAccent},
    {'name': 'الْبَصِيرُ', 'arabic': 'الْبَصِيرُ', 'english': 'Al-Basir', 'meaning': 'البصير', 'description': 'الذي يبصر كل شيء', 'color': Colors.tealAccent},
    {'name': 'الْحَكَمُ', 'arabic': 'الْحَكَمُ', 'english': 'Al-Hakam', 'meaning': 'الحكم', 'description': 'الذي يحكم بين عباده', 'color': Colors.purpleAccent},
    {'name': 'الْعَدْلُ', 'arabic': 'الْعَدْلُ', 'english': 'Al-Adl', 'meaning': 'العدل', 'description': 'الذي يحكم بالعدل', 'color': Colors.green},
    {'name': 'اللَّطِيفُ', 'arabic': 'اللَّطِيفُ', 'english': 'Al-Latif', 'meaning': 'اللطيف', 'description': 'الذي يعلم دقائق الأمور', 'color': Colors.lightBlueAccent},
    {'name': 'الْخَبِيرُ', 'arabic': 'الْخَبِيرُ', 'english': 'Al-Khabir', 'meaning': 'الخبير', 'description': 'الذي يعلم خفايا الأمور', 'color': Colors.orange},
    {'name': 'الْحَلِيمُ', 'arabic': 'الْحَلِيمُ', 'english': 'Al-Halim', 'meaning': 'الحليم', 'description': 'الذي لا يعجل بالعقوبة', 'color': Colors.cyan},
    {'name': 'الْعَظِيمُ', 'arabic': 'الْعَظِيمُ', 'english': 'Al-Azim', 'meaning': 'العظيم', 'description': 'الذي له العظمة في صفاته', 'color': Colors.deepOrange},
    {'name': 'الْغَفُورُ', 'arabic': 'الْغَفُورُ', 'english': 'Al-Ghafur', 'meaning': 'الغفور', 'description': 'الذي يغفر الذنوب', 'color': Colors.pink},
    {'name': 'الشَّكُورُ', 'arabic': 'الشَّكُورُ', 'english': 'Ash-Shakur', 'meaning': 'الشكور', 'description': 'الذي يشكر القليل من العمل', 'color': Colors.limeAccent},
    {'name': 'الْعَلِيُّ', 'arabic': 'الْعَلِيُّ', 'english': 'Al-Ali', 'meaning': 'العلي', 'description': 'الذي له العلو المطلق', 'color': Colors.blue},
    {'name': 'الْكَبِيرُ', 'arabic': 'الْكَبِيرُ', 'english': 'Al-Kabir', 'meaning': 'الكبير', 'description': 'الذي له الكبرياء في صفاته', 'color': Colors.red},
    {'name': 'الْحَفِيظُ', 'arabic': 'الْحَفِيظُ', 'english': 'Al-Hafiz', 'meaning': 'الحفيظ', 'description': 'الذي يحفظ عباده من المهالك', 'color': Colors.greenAccent},
    {'name': 'الْمُقِيتُ', 'arabic': 'الْمُقِيتُ', 'english': 'Al-Muqit', 'meaning': 'المقيت', 'description': 'الذي يوصل الأرزاق إلى عباده', 'color': Colors.amber},
    {'name': 'الْحَسِيبُ', 'arabic': 'الْحَسِيبُ', 'english': 'Al-Hasib', 'meaning': 'الحسيب', 'description': 'الذي يحسب أعمال عباده', 'color': Colors.indigo},
    {'name': 'الْجَلِيلُ', 'arabic': 'الْجَلِيلُ', 'english': 'Al-Jalil', 'meaning': 'الجليل', 'description': 'الذي له الجلال والعظمة', 'color': Colors.teal},
    {'name': 'الْكَرِيمُ', 'arabic': 'الْكَرِيمُ', 'english': 'Al-Karim', 'meaning': 'الكريم', 'description': 'الذي له الكرم المطلق', 'color': Colors.purple},
    {'name': 'الرَّقِيبُ', 'arabic': 'الرَّقِيبُ', 'english': 'Ar-Raqib', 'meaning': 'الرقيب', 'description': 'الذي يراقب أحوال عباده', 'color': Colors.blueGrey},
    {'name': 'الْمُجِيبُ', 'arabic': 'الْمُجِيبُ', 'english': 'Al-Mujib', 'meaning': 'المجيب', 'description': 'الذي يجيب دعاء عباده', 'color': Colors.lightGreenAccent},
    {'name': 'الْوَاسِعُ', 'arabic': 'الْوَاسِعُ', 'english': 'Al-Wasi', 'meaning': 'الواسع', 'description': 'الذي وسع رزقه كل شيء', 'color': Colors.cyanAccent},
    {'name': 'الْحَكِيمُ', 'arabic': 'الْحَكِيمُ', 'english': 'Al-Hakim', 'meaning': 'الحكيم', 'description': 'الذي له الحكمة في خلقه وأمره', 'color': Colors.deepPurple},
    {'name': 'الْوَدُودُ', 'arabic': 'الْوَدُودُ', 'english': 'Al-Wadud', 'meaning': 'الودود', 'description': 'الذي يحب عباده وعباده يحبونه', 'color': Colors.pinkAccent},
    {'name': 'الْمَجِيدُ', 'arabic': 'الْمَجِيدُ', 'english': 'Al-Majid', 'meaning': 'المجيد', 'description': 'الذي له المجد والسؤدد', 'color': Colors.orangeAccent},
    {'name': 'الْبَاعِثُ', 'arabic': 'الْبَاعِثُ', 'english': 'Al-Ba\'ith', 'meaning': 'الباعث', 'description': 'الذي يبعث الخلق يوم القيامة', 'color': Colors.lime},
    {'name': 'الشَّهِيدُ', 'arabic': 'الشَّهِيدُ', 'english': 'Ash-Shahid', 'meaning': 'الشهيد', 'description': 'الذي يشهد على كل شيء', 'color': Colors.redAccent},
    {'name': 'الْحَقُّ', 'arabic': 'الْحَقُّ', 'english': 'Al-Haqq', 'meaning': 'الحق', 'description': 'الذي هو الحق في ذاته وأفعاله', 'color': Colors.green},
    {'name': 'الْوَكِيلُ', 'arabic': 'الْوَكِيلُ', 'english': 'Al-Wakil', 'meaning': 'الوكيل', 'description': 'الذي يتولى أمور عباده', 'color': Colors.blue},
    {'name': 'الْقَوِيُّ', 'arabic': 'الْقَوِيُّ', 'english': 'Al-Qawi', 'meaning': 'القوي', 'description': 'الذي له القوة المطلقة', 'color': Colors.amber},
    {'name': 'الْمَتِينُ', 'arabic': 'الْمَتِينُ', 'english': 'Al-Matin', 'meaning': 'المتين', 'description': 'الذي لا يغلبه شيء', 'color': Colors.indigo},
    {'name': 'الْوَلِيُّ', 'arabic': 'الْوَلِيُّ', 'english': 'Al-Wali', 'meaning': 'الولي', 'description': 'الذي يتولى عباده المؤمنين', 'color': Colors.teal},
    {'name': 'الْحَمِيدُ', 'arabic': 'الْحَمِيدُ', 'english': 'Al-Hamid', 'meaning': 'الحميد', 'description': 'الذي يحمد في السراء والضراء', 'color': Colors.purple},
    {'name': 'الْمُحْصِي', 'arabic': 'الْمُحْصِي', 'english': 'Al-Muhsi', 'meaning': 'المحصي', 'description': 'الذي يحصي أعمال عباده', 'color': Colors.blueGrey},
    {'name': 'الْمُبْدِئُ', 'arabic': 'الْمُبْدِئُ', 'english': 'Al-Mubdi', 'meaning': 'المبدئ', 'description': 'الذي يبدئ الخلق', 'color': Colors.lightGreen},
    {'name': 'الْمُعِيدُ', 'arabic': 'الْمُعِيدُ', 'english': 'Al-Mu\'id', 'meaning': 'المعيد', 'description': 'الذي يعيد الخلق بعد الموت', 'color': Colors.cyan},
    {'name': 'الْمُحْيِي', 'arabic': 'الْمُحْيِي', 'english': 'Al-Muhyi', 'meaning': 'المحيي', 'description': 'الذي يحيي الموتى', 'color': Colors.deepOrange},
    {'name': 'الْمُمِيتُ', 'arabic': 'الْمُمِيتُ', 'english': 'Al-Mumit', 'meaning': 'المميت', 'description': 'الذي يميت الأحياء', 'color': Colors.pink},
    {'name': 'الْحَيُّ', 'arabic': 'الْحَيُّ', 'english': 'Al-Hayy', 'meaning': 'الحي', 'description': 'الذي له الحياة المطلقة', 'color': Colors.limeAccent},
    {'name': 'الْقَيُّومُ', 'arabic': 'الْقَيُّومُ', 'english': 'Al-Qayyum', 'meaning': 'القيوم', 'description': 'الذي يقوم بنفسه ويقوم غيره', 'color': Colors.blueAccent},
    {'name': 'الْوَاجِدُ', 'arabic': 'الْوَاجِدُ', 'english': 'Al-Wajid', 'meaning': 'الواجد', 'description': 'الذي لا يعوزه شيء', 'color': Colors.redAccent},
    {'name': 'الْمَاجِدُ', 'arabic': 'الْمَاجِدُ', 'english': 'Al-Majid', 'meaning': 'الماجد', 'description': 'الذي له المجد والكمال', 'color': Colors.greenAccent},
    {'name': 'الْوَاحِدُ', 'arabic': 'الْوَاحِدُ', 'english': 'Al-Wahid', 'meaning': 'الواحد', 'description': 'الذي لا شريك له', 'color': Colors.amberAccent},
    {'name': 'الْأَحَدُ', 'arabic': 'الْأَحَدُ', 'english': 'Al-Ahad', 'meaning': 'الأحد', 'description': 'الذي لا يشاركه أحد في ألوهيته', 'color': Colors.indigoAccent},
    {'name': 'الصَّمَدُ', 'arabic': 'الصَّمَدُ', 'english': 'As-Samad', 'meaning': 'الصمد', 'description': 'الذي تصمد إليه الخلائق في حوائجها', 'color': Colors.tealAccent},
    {'name': 'الْقَادِرُ', 'arabic': 'الْقَادِرُ', 'english': 'Al-Qadir', 'meaning': 'القادر', 'description': 'الذي يقدر على كل شيء', 'color': Colors.purpleAccent},
    {'name': 'الْمُقْتَدِرُ', 'arabic': 'الْمُقْتَدِرُ', 'english': 'Al-Muqtadir', 'meaning': 'المقتدر', 'description': 'الذي له القدرة المطلقة', 'color': Colors.blueGrey},
    {'name': 'الْمُقَدِّمُ', 'arabic': 'الْمُقَدِّمُ', 'english': 'Al-Muqaddim', 'meaning': 'المقدم', 'description': 'الذي يقدم من يشاء', 'color': Colors.lightGreenAccent},
    {'name': 'الْمُؤَخِّرُ', 'arabic': 'الْمُؤَخِّرُ', 'english': 'Al-Mu\'akhkhir', 'meaning': 'المؤخر', 'description': 'الذي يؤخر من يشاء', 'color': Colors.cyanAccent},
    {'name': 'الْأَوَّلُ', 'arabic': 'الْأَوَّلُ', 'english': 'Al-Awwal', 'meaning': 'الأول', 'description': 'الذي ليس له بداية', 'color': Colors.deepPurple},
    {'name': 'الْآخِرُ', 'arabic': 'الْآخِرُ', 'english': 'Al-Akhir', 'meaning': 'الآخر', 'description': 'الذي ليس له نهاية', 'color': Colors.pinkAccent},
    {'name': 'الظَّاهِرُ', 'arabic': 'الظَّاهِرُ', 'english': 'Az-Zahir', 'meaning': 'الظاهر', 'description': 'الذي ظهر فوق كل شيء', 'color': Colors.orangeAccent},
    {'name': 'الْبَاطِنُ', 'arabic': 'الْبَاطِنُ', 'english': 'Al-Batin', 'meaning': 'الباطن', 'description': 'الذي احتجب عن خلقه', 'color': Colors.lime},
    {'name': 'الْوَالِي', 'arabic': 'الْوَالِي', 'english': 'Al-Wali', 'meaning': 'الوالي', 'description': 'الذي يتولى أمور الخلق', 'color': Colors.redAccent},
    {'name': 'الْمُتَعَالِي', 'arabic': 'الْمُتَعَالِي', 'english': 'Al-Muta\'ali', 'meaning': 'المتعالي', 'description': 'الذي تعالي عن صفات الخلق', 'color': Colors.green},
    {'name': 'الْبَرُّ', 'arabic': 'الْبَرُّ', 'english': 'Al-Barr', 'meaning': 'البر', 'description': 'الذي يبر عباده', 'color': Colors.blue},
    {'name': 'التَّوَّابُ', 'arabic': 'التَّوَّابُ', 'english': 'At-Tawwab', 'meaning': 'التواب', 'description': 'الذي يقبل توبة عباده', 'color': Colors.amber},
    {'name': 'الْمُنْتَقِمُ', 'arabic': 'الْمُنْتَقِمُ', 'english': 'Al-Muntaqim', 'meaning': 'المنتقم', 'description': 'الذي ينتقم من أعدائه', 'color': Colors.indigo},
    {'name': 'الْعَفُوُّ', 'arabic': 'الْعَفُوُّ', 'english': 'Al-Afu', 'meaning': 'العفو', 'description': 'الذي يعفو عن الذنوب', 'color': Colors.teal},
    {'name': 'الرَّءُوفُ', 'arabic': 'الرَّءُوفُ', 'english': 'Ar-Ra\'uf', 'meaning': 'الرؤوف', 'description': 'الذي له الرأفة بالعباد', 'color': Colors.purple},
    {'name': 'مَالِكُ الْمُلْكِ', 'arabic': 'مَالِكُ الْمُلْكِ', 'english': 'Malik-ul-Mulk', 'meaning': 'مالك الملك', 'description': 'الذي يملك الملك كله', 'color': Colors.blueGrey},
    {'name': 'ذُو الْجَلَالِ وَالْإِكْرَامِ', 'arabic': 'ذُو الْجَلَالِ وَالْإِكْرَامِ', 'english': 'Dhul-Jalali wal-Ikram', 'meaning': 'ذو الجلال والإكرام', 'description': 'الذي له الجلال والإكرام', 'color': Colors.lightGreen},
    {'name': 'الْمُقْسِطُ', 'arabic': 'الْمُقْسِطُ', 'english': 'Al-Muqsit', 'meaning': 'المقسط', 'description': 'الذي يحكم بالعدل', 'color': Colors.cyan},
    {'name': 'الْجَامِعُ', 'arabic': 'الْجَامِعُ', 'english': 'Al-Jami', 'meaning': 'الجامع', 'description': 'الذي يجمع الخلق يوم القيامة', 'color': Colors.deepOrange},
    {'name': 'الْغَنِيُّ', 'arabic': 'الْغَنِيُّ', 'english': 'Al-Ghani', 'meaning': 'الغني', 'description': 'الذي لا يحتاج إلى شيء', 'color': Colors.pink},
    {'name': 'الْمُغْنِي', 'arabic': 'الْمُغْنِي', 'english': 'Al-Mughni', 'meaning': 'المغني', 'description': 'الذي يغني عباده', 'color': Colors.limeAccent},
    {'name': 'الْمَانِعُ', 'arabic': 'الْمَانِعُ', 'english': 'Al-Mani', 'meaning': 'المانع', 'description': 'الذي يمنع ما أراد منعه', 'color': Colors.blueAccent},
    {'name': 'الضَّارُّ', 'arabic': 'الضَّارُّ', 'english': 'Ad-Darr', 'meaning': 'الضار', 'description': 'الذي يضر من يشاء', 'color': Colors.redAccent},
    {'name': 'النَّافِعُ', 'arabic': 'النَّافِعُ', 'english': 'An-Nafi', 'meaning': 'النافع', 'description': 'الذي ينفع من يشاء', 'color': Colors.greenAccent},
    {'name': 'النُّورُ', 'arabic': 'النُّورُ', 'english': 'An-Nur', 'meaning': 'النور', 'description': 'الذي نور السماوات والأرض', 'color': Colors.amberAccent},
    {'name': 'الْهَادِي', 'arabic': 'الْهَادِي', 'english': 'Al-Hadi', 'meaning': 'الهادي', 'description': 'الذي يهدي من يشاء', 'color': Colors.indigoAccent},
    {'name': 'الْبَدِيعُ', 'arabic': 'الْبَدِيعُ', 'english': 'Al-Badi', 'meaning': 'البديع', 'description': 'الذي خلق الخلق بديعاً', 'color': Colors.tealAccent},
    {'name': 'الْبَاقِي', 'arabic': 'الْبَاقِي', 'english': 'Al-Baqi', 'meaning': 'الباقي', 'description': 'الذي يبقى بعد فناء الخلق', 'color': Colors.purpleAccent},
    {'name': 'الْوَارِثُ', 'arabic': 'الْوَارِثُ', 'english': 'Al-Warith', 'meaning': 'الوارث', 'description': 'الذي يرث كل شيء', 'color': Colors.blueGrey},
    {'name': 'الرَّشِيدُ', 'arabic': 'الرَّشِيدُ', 'english': 'Ar-Rashid', 'meaning': 'الرشيد', 'description': 'الذي يرشد عباده', 'color': Colors.lightGreenAccent},
    {'name': 'الصَّبُورُ', 'arabic': 'الصَّبُورُ', 'english': 'As-Sabur', 'meaning': 'الصبور', 'description': 'الذي يصبر على أذى عباده', 'color': Colors.cyanAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أسماء الله الحسنى'),
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
        child: Column(
          children: [
            // معلومات عامة
            Container(
              margin: const EdgeInsets.all(16),
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
                  const Text(
                    'أسماء الله الحسنى',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'عدد الأسماء: ${asmaUlHusna.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // قائمة الأسماء
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: asmaUlHusna.length,
                itemBuilder: (context, index) {
                  final name = asmaUlHusna[index];
                  final isSelected = selectedNameIndex == index;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedNameIndex = isSelected ? -1 : index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? name['color'] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: isSelected ? name['color'] : Colors.grey[300]!,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name['arabic'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : name['color'],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name['english'],
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white70 : Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name['meaning'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
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
      ),
    );
  }
}
 