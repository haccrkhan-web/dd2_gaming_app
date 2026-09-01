import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const DD1App());
}

// Global Configurations
const String ADMIN_UPI = "fardinkhan7860011111@okhdfcbank";
const String ADMIN_NAME = "Fardin Khan";

class AppConfig {
  static double profitMargin = 0.15;
  static double maxMultiplierCap = 8.0;
  static double slotWinRate = 0.25;
}

class WalletManager {
  static double balance = 500.0;
  static String playerId = "DD_${Random().nextInt(899999) + 100000}";
  static List<Map<String, dynamic>> logs = [];

  static void addLog(String title, double amount, bool isCredit) {
    logs.insert(0, {
      'title': title,
      'amount': amount,
      'isCredit': isCredit,
      'time': DateTime.now(),
    });
  }
}

class DD1App extends StatelessWidget {
  const DD1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DD1 GAME',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0807),
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  int _navIndex = 0;

  void _nav(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen))
        .then((_) => setState(() {}));
  }

  void _showDepositModal() {
    int selectedAmount = 500;
    final utrController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1210),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setM) {
          final qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=upi://pay?pa=$ADMIN_UPI%26pn=${Uri.encodeComponent(ADMIN_NAME)}%26am=$selectedAmount%26cu=INR";

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('UPI DEPOSIT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [100, 300, 500, 1000, 2000].map((amt) {
                      return ChoiceChip(
                        label: Text('₹$amt', style: TextStyle(color: selectedAmount == amt ? Colors.black : Colors.white)),
                        selected: selectedAmount == amt,
                        selectedColor: Colors.amber,
                        backgroundColor: const Color(0xFF2C1614),
                        onSelected: (_) => setM(() => selectedAmount = amt),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Image.network(qrUrl, height: 140, width: 140),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: utrController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Enter 12-Digit UTR Number', filled: true, fillColor: Color(0xFF2C1614)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        if (utrController.text.length < 4) return;
                        setState(() {
                          WalletManager.balance += selectedAmount;
                          WalletManager.addLog("UPI Deposit", selectedAmount.toDouble(), true);
                        });
                        Navigator.pop(ctx);
                      },
                      child: Text('SUBMIT & ADD ₹$selectedAmount', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B0E0D),
        title: const Text('DD1.COM', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.amber)),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: Colors.amber),
            onPressed: _showDepositModal,
          ),
        ],
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => _nav(const AviatorScreen()),
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(colors: [Color(0xFF8B0000), Color(0xFF2E0909)]),
                border: Border.all(color: Colors.amber),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HOT LIVE GAME', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
                      Text('AVIATOR 100X', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    ],
                  ),
                  Icon(Icons.rocket_launch, color: Colors.amber, size: 36),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1E1210), borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('User: ${WalletManager.playerId}', style: const TextStyle(color: Colors.white70)),
                Text('₹ ${WalletManager.balance.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildCard('Aviator Crash', Icons.rocket_launch, Colors.red, () => _nav(const AviatorScreen())),
                _buildCard('7 Up 7 Down', Icons.casino, Colors.blueGrey, () => _nav(const SevenUpScreen())),
                _buildCard('Fortune Slots', Icons.star, Colors.amber, () => _nav(const SlotScreen())),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 1) _showDepositModal();
        },
        backgroundColor: const Color(0xFF1B0E0D),
        selectedItemColor: Colors.amber,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Deposit'),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color.withOpacity(0.25), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber.withOpacity(0.5))),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber, size: 28),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
            const Icon(Icons.play_arrow, color: Colors.amber),
          ],
        ),
      ),
    );
  }
}

class AviatorScreen extends StatefulWidget {
  const AviatorScreen({super.key});

  @override
  State<AviatorScreen> createState() => _AviatorScreenState();
}

class _AviatorScreenState extends State<AviatorScreen> {
  double _mult = 1.0;
  double _crashAt = 2.0;
  bool _running = false;
  bool _betActive = false;
  Timer? _timer;

  void _startRound() {
    if (WalletManager.balance < 50) return;
    final rand = Random();
    _crashAt = 1.1 + rand.nextDouble() * AppConfig.maxMultiplierCap;

    setState(() {
      WalletManager.balance -= 50;
      _running = true;
      _betActive = true;
      _mult = 1.0;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
      setState(() {
        _mult += 0.02 + (_mult * 0.01);
        if (_mult >= _crashAt) {
          _mult = _crashAt;
          _running = false;
          _betActive = false;
          _timer?.cancel();
        }
      });
    });
  }

  void _cashOut() {
    if (_betActive && _running) {
      final win = 50 * _mult;
      setState(() {
        _betActive = false;
        WalletManager.balance += win;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AVIATOR'), backgroundColor: const Color(0xFF1B0E0D)),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                '${_mult.toStringAsFixed(2)}x',
                style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: _running ? Colors.white : Colors.redAccent),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: _betActive
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      onPressed: _cashOut,
                      child: Text('CASH OUT ₹${(50 * _mult).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _running ? null : _startRound,
                      child: const Text('BET ₹50 & FLY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class SevenUpScreen extends StatefulWidget {
  const SevenUpScreen({super.key});

  @override
  State<SevenUpScreen> createState() => _SevenUpScreenState();
}

class _SevenUpScreenState extends State<SevenUpScreen> {
  int d1 = 3, d2 = 4;
  String? pick;

  void _roll() {
    if (pick == null || WalletManager.balance < 50) return;
    setState(() => WalletManager.balance -= 50);

    final r = Random();
    final r1 = r.nextInt(6) + 1;
    final r2 = r.nextInt(6) + 1;
    final sum = r1 + r2;

    double win = 0;
    if (sum < 7 && pick == 'down') win = 100;
    if (sum == 7 && pick == '7') win = 250;
    if (sum > 7 && pick == 'up') win = 100;

    setState(() {
      d1 = r1;
      d2 = r2;
      WalletManager.balance += win;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7 UP 7 DOWN'), backgroundColor: const Color(0xFF1B0E0D)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('$d1 + $d2 = ${d1 + d2}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amber)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(label: const Text('Down (2x)'), selected: pick == 'down', onSelected: (_) => setState(() => pick = 'down')),
              ChoiceChip(label: const Text('7 (5x)'), selected: pick == '7', onSelected: (_) => setState(() => pick = '7')),
              ChoiceChip(label: const Text('Up (2x)'), selected: pick == 'up', onSelected: (_) => setState(() => pick = 'up')),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: _roll,
            child: const Text('ROLL (₹50)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class SlotScreen extends StatefulWidget {
  const SlotScreen({super.key});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  final List<String> _items = ['💎', '7️⃣', '🔔', '🍒'];
  String s1 = '💎', s2 = '7️⃣', s3 = '💎';

  void _spin() {
    if (WalletManager.balance < 20) return;
    setState(() => WalletManager.balance -= 20);

    final r = Random();
    final p1 = _items[r.nextInt(_items.length)];
    final p2 = _items[r.nextInt(_items.length)];
    final p3 = _items[r.nextInt(_items.length)];

    double win = 0;
    if (p1 == p2 && p2 == p3) win = 200;

    setState(() {
      s1 = p1;
      s2 = p2;
      s3 = p3;
      WalletManager.balance += win;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FORTUNE SLOTS'), backgroundColor: const Color(0xFF1B0E0D)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(s1, style: const TextStyle(fontSize: 48)), const SizedBox(width: 12), Text(s2, style: const TextStyle(fontSize: 48)), const SizedBox(width: 12), Text(s3, style: const TextStyle(fontSize: 48))],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: _spin,
              child: const Text('SPIN (₹20)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

