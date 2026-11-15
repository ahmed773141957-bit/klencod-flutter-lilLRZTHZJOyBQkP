import 'package:flutter/material.dart';

void main() => runApp(const HrmsApp());

const navy = Color(0xFF0B1F3A);
const blue = Color(0xFF1A73E8);

class HrmsApp extends StatelessWidget {
  const HrmsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'نظام الموارد البشرية',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: blue), useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFF4F7FB), fontFamily: 'Roboto'),
        home: const Directionality(textDirection: TextDirection.rtl, child: LoginPage()),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;
  String? error;
  final demos = const [
    ('super_admin', 'إدارة عليا'),
    ('admin', 'مدير'),
    ('employee', 'مدخل بيانات'),
  ];
  void login() {
    final name = username.text.trim();
    final pass = password.text.trim();
    if (pass == '123456' && demos.any((d) => d.$1 == name)) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Directionality(textDirection: TextDirection.rtl, child: HomePage(user: name, role: demos.firstWhere((d) => d.$1 == name).$2))));
    } else {
      setState(() => error = 'اسم المستخدم أو كلمة المرور غير صحيحة');
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [navy, Color(0xFF123C68), Color(0xFF0B1F3A)])),
          child: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: Column(children: [
            const Icon(Icons.apartment_rounded, size: 56, color: Colors.white), const SizedBox(height: 12),
            const Text('تسجيل الدخول', style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6), const Text('نظام إدارة الموارد البشرية', style: TextStyle(color: Colors.white70)), const SizedBox(height: 32),
            TextField(controller: username, textDirection: TextDirection.ltr, decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline), hintText: 'اسم المستخدم', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18))))),
            const SizedBox(height: 14), TextField(controller: password, obscureText: obscure, textDirection: TextDirection.ltr, onSubmitted: (_) => login(), decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline), hintText: 'كلمة المرور', filled: true, fillColor: Colors.white, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18))), suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility : Icons.visibility_off)))),
            if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.orangeAccent))),
            const SizedBox(height: 18), SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: login, style: FilledButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: navy), child: const Text('دخول', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 28), const Text('الحسابات التجريبية — كلمة المرور: 123456', style: TextStyle(color: Colors.white70)), const SizedBox(height: 10),
            ...demos.map((d) => Card(color: Colors.white.withValues(alpha: .10), child: ListTile(leading: const Icon(Icons.account_circle_outlined, color: Colors.white), title: Text(d.$2, style: const TextStyle(color: Colors.white)), subtitle: Text(d.$1, textDirection: TextDirection.ltr, style: const TextStyle(color: Colors.white70)), onTap: () { username.text = d.$1; password.text = '123456'; }))),
            const SizedBox(height: 8), const Text('نسخة تطبيق أولية — يلزم ربطها بخادم HRMS للإنتاج', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ]))))),
        ),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user, required this.role});
  final String user, role;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final pages = const ['الرئيسية', 'الموظفون', 'الحضور', 'الإجازات', 'الرواتب', 'المزيد'];
  final icons = const [Icons.dashboard_outlined, Icons.groups_outlined, Icons.access_time, Icons.beach_access_outlined, Icons.payments_outlined, Icons.menu];
  @override
  Widget build(BuildContext context) {
    final page = index == 0 ? DashboardPage(user: widget.user, role: widget.role, onOpen: (i) => setState(() => index = i)) : index == 5 ? MorePage(onSelect: (i) => setState(() => index = i)) : ModulePage(title: pages[index], icon: icons[index], admin: widget.user != 'employee');
    return Scaffold(
      appBar: AppBar(title: Text(pages[index]), backgroundColor: Colors.white, actions: [IconButton(tooltip: 'تسجيل الخروج', onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Directionality(textDirection: TextDirection.rtl, child: LoginPage())), (_) => false), icon: const Icon(Icons.logout))]),
      body: page,
      bottomNavigationBar: NavigationBar(selectedIndex: index > 4 ? 5 : index, onDestinationSelected: (i) => setState(() => index = i), destinations: const [NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'الرئيسية'), NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'الموظفون'), NavigationDestination(icon: Icon(Icons.access_time), label: 'الحضور'), NavigationDestination(icon: Icon(Icons.beach_access_outlined), label: 'الإجازات'), NavigationDestination(icon: Icon(Icons.payments_outlined), label: 'الرواتب'), NavigationDestination(icon: Icon(Icons.menu), label: 'المزيد')]),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.user, required this.role, required this.onOpen});
  final String user, role;
  final ValueChanged<int> onOpen;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [navy, blue])), child: Row(children: [const CircleAvatar(radius: 27, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('مرحباً، $user', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)), Text(role, style: const TextStyle(color: Colors.white70))]))])),
    const SizedBox(height: 18), const Text('ملخص النظام', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
    Wrap(spacing: 10, runSpacing: 10, children: const [StatCard(title: 'الموظفون', value: '24', icon: Icons.groups, color: blue), StatCard(title: 'حضور اليوم', value: '18', icon: Icons.how_to_reg, color: Colors.green), StatCard(title: 'طلبات معلقة', value: '3', icon: Icons.pending_actions, color: Colors.orange), StatCard(title: 'الأقسام', value: '6', icon: Icons.account_tree, color: Colors.purple)]),
    const SizedBox(height: 20), const Text('الوصول السريع', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)), const SizedBox(height: 8),
    ...[(1, 'إدارة الموظفين', Icons.groups_outlined), (2, 'الحضور والانصراف', Icons.access_time), (3, 'طلبات الإجازات', Icons.beach_access_outlined), (4, 'الرواتب الشهرية', Icons.payments_outlined)].map((e) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: blue.withValues(alpha: .1), child: Icon(e.$3, color: blue)), title: Text(e.$2), trailing: const Icon(Icons.chevron_left), onTap: () => onOpen(e.$1)))),
    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('بيانات العرض تجريبية. اربط التطبيق بواجهة API قبل الاستخدام الفعلي.', style: TextStyle(color: Colors.black54, fontSize: 12))),
  ]);
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.title, required this.value, required this.icon, required this.color});
  final String title, value; final IconData icon; final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(width: (MediaQuery.sizeOf(context).width - 46) / 2, child: Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text(title, style: const TextStyle(color: Colors.black54))]))));
}

class ModulePage extends StatelessWidget {
  const ModulePage({super.key, required this.title, required this.icon, required this.admin});
  final String title; final IconData icon; final bool admin;
  @override
  Widget build(BuildContext context) {
    final records = switch (title) {
      'الموظفون' => const [('EMP-001', 'أحمد محمد', 'الموارد البشرية'), ('EMP-002', 'سارة علي', 'المحاسبة'), ('EMP-003', 'خالد حسن', 'تقنية المعلومات')],
      'الحضور' => const [('اليوم', 'حاضرون: 18', 'متأخرون: 2'), ('أمس', 'حاضرون: 21', 'غياب: 1')],
      'الإجازات' => const [('طلب إجازة سنوية', 'محمد أحمد', 'قيد المراجعة'), ('إجازة مرضية', 'سارة علي', 'موافق عليه')],
      'الرواتب' => const [('2026-11', 'إجمالي الرواتب', 'قيد الدفع'), ('2026-10', 'تم الصرف', 'مدفوع')],
      _ => const [('لا توجد سجلات', 'ابدأ بإضافة سجل جديد', '')],
    };
    return ListView(padding: const EdgeInsets.all(16), children: [if (admin) Align(alignment: Alignment.centerLeft, child: FilledButton.icon(onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(title: Text('إضافة — $title'), content: const Text('نموذج الإدخال يحتاج إلى ربط قاعدة البيانات.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))])), icon: const Icon(Icons.add), label: const Text('إضافة'))), const SizedBox(height: 8), ...records.map((r) => Card(child: ListTile(leading: CircleAvatar(child: Icon(icon)), title: Text(r.$1), subtitle: Text('${r.$2}${r.$3.isNotEmpty ? ' • ${r.$3}' : ''}'), trailing: const Icon(Icons.chevron_left), onTap: () => showDialog(context: context, builder: (_) => AlertDialog(title: Text(r.$1), content: Text('${r.$2}\n${r.$3}'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))])))))]);
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key, required this.onSelect});
  final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [for (final item in const [(3, 'السلف والقروض', Icons.request_quote), (3, 'المكافآت والخصومات', Icons.card_giftcard), (0, 'التقارير', Icons.analytics_outlined), (0, 'الأقسام', Icons.account_tree_outlined), (0, 'الإعدادات', Icons.settings_outlined), (0, 'سجل العمليات', Icons.history)]) Card(child: ListTile(leading: Icon(item.$3, color: blue), title: Text(item.$2), trailing: const Icon(Icons.chevron_left), onTap: () { if (item.$2 == 'السلف والقروض') Navigator.push(context, MaterialPageRoute(builder: (_) => const Directionality(textDirection: TextDirection.rtl, child: ModulePage(title: 'السلف والقروض', icon: Icons.request_quote, admin: true)))); else if (item.$2 == 'المكافآت والخصومات') Navigator.push(context, MaterialPageRoute(builder: (_) => const Directionality(textDirection: TextDirection.rtl, child: ModulePage(title: 'المكافآت والخصومات', icon: Icons.card_giftcard, admin: true)))); else onSelect(item.$1); }))]);
}