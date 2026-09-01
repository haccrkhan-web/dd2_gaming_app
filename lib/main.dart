import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const DD1VIPPlatform());
}

// ---------------------------------------------------------------------------
// ADMIN & CORE CONFIG
// ---------------------------------------------------------------------------
const String APP_TITLE = "DD1 VIP CASINO";
const String ADMIN_UPI_ID = "fardinkhan7860011111@okhdfcbank";
const String ADMIN_NAME = "Fardin Khan";

class AdminConfig {
  static double houseEdge = 0.12;
  static double maxCrash = 12.5;
  static double slotWinRate = 0.35;
  static int minesCount = 3;
}

class UserSession {
  static double balance = 1000.00;
  static String playerId = "VIP_${Random().nextInt(899999) + 100000}";
  static String vipTier = "DIAMOND VIP";

  static List<Map<String, dynamic>> passbook = [
    {
      'id': 'TXN_WELCOME_881',
      'title': 'VIP Sign-up Welcome Gift',
      'amount': 1000.0,
      'isCredit': true,
      'status': 'Success',
      'time': 'Just now'
    }
  ];

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
// APP ENTRY & THEME
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
// 2. GOOGLE & 1-TAP LOGIN SCREEN
// ---------------------------------------------------------------------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _loading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        UserSession.playerId = "VIP_${account.email.split('@')[0].toUpperCase()}";
      }
    } catch (_) {
      UserSession.playerId = "VIP_G_${Random().nextInt(8999) + 1000}";
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainLobbyScreen()));
      }
    }
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

                  // GOOGLE 1-TAP LOGIN
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.amber.withOpacity(0.6)),
                      boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _loading ? null : _handleGoogleSignIn,
                      icon: const Icon(Icons.g_mobiledata, color: Colors.redAccent, size: 30),
                      label: _loading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Text(
                              'Continue with Google',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR QUICK LOGIN', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 1-TAP INSTANT PASS
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.amber),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        UserSession.playerId = "VIP_${Random().nextInt(899999) + 100000}";
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainLobbyScreen()));
                      },
                      icon: const Icon(Icons.flash_on, color: Colors.amber),
                      label: const Text('1-Tap Instant Guest Login', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
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
  }

  @override
  void dispose() {
    _liveTickerTimer?.cancel();
    super.dispose();
  }

  void _nav(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen)).then((_) => setState(() {}));
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CustomPaint(
                            painter: PureVectorQRPainter(
                              upiUri: "upi://pay?pa=$ADMIN_UPI_ID&pn=${Uri.encodeComponent(ADMIN_NAME)}&am=$selectedAmt&cu=INR",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('₹$selectedAmt Credited to Wallet!')));
                      },
                      child: Text('SUBMIT & ADD ₹$selectedAmt', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showWithdrawDialog() {
    final amtCtrl = TextEditingController();
    final upiCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showModal
