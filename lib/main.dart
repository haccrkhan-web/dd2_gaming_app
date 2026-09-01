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
  runApp(const DD1CasinoProApp());
}

// ---------------------------------------------------------------------------
// ADMIN CONFIG & LIVE ENGINE DATA
// ---------------------------------------------------------------------------
const String ADMIN_UPI_ID = "fardinkhan7860011111@okhdfcbank";
const String ADMIN_NAME = "Fardin Khan";

class AdminConfig {
  static double houseEdge = 0.15; // 15% Platform Edge
  static double maxCrash = 10.0;
  static double slotWinRate = 0.28;
}

class WalletState {
  static double balance = 500.00;
  static String playerId = "VIP_${Random().nextInt(899999) + 100000}";
  static List<Map<String, dynamic>> transactions = [
    {
      'id': 'TXN8912',
      'title': 'Sign-up Bonus',
      'amount': 500.0,
      'isCredit': true,
      'status': 'Completed',
      'time': DateTime.now().subtract(const Duration(minutes: 45))
    }
  ];

  static void addTxn(String title, double amount, bool isCredit, String status) {
    transactions.insert(0, {
      'id': 'TXN${Random().nextInt(89999) + 10000}',
      'title': title,
      'amount': amount,
      'isCredit': isCredit,
      'status': status,
      'time': DateTime.now(),
    });
  }
}

// ---------------------------------------------------------------------------
// ROOT APP THEME (VIP DARK GOLD / CRIMSON CASINO)
// ---------------------------------------------------------------------------
class DD1CasinoProApp extends StatelessWidget {
  const DD1CasinoProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DD1 VIP CASINO',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0505),
        primaryColor: const Color(0xFFFFD700),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFFE50914),
          surface: Color(0xFF160B0A),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

// ---------------------------------------------------------------------------
// LOGIN / ONBOARDING SCREEN
// ---------------------------------------------------------------------------
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _otpSent = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return const CasinoDashboard();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [Color(0xFF380708), Color(0xFF0A0505)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  child: const Icon(Icons.casino, color: Colors.amber, size: 50),
                ),
                const SizedBox(height: 14),
                const Text(
                  'DD1.COM',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: Colors.amber,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Text(
                  'OFFICIAL VIP GAMING PLATFORM',
                  style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF180A09),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.4)),
                    boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 15)],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          prefixText: '+91  ',
                          prefixStyle: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                          labelText: 'Mobile Number',
                          labelStyle: const TextStyle(color: Colors.white60),
                          filled: true,
                          fillColor: const Color(0xFF26100E),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      if (_otpSent) ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: _otpCtrl,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 6),
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: 'Enter OTP (Demo: Any 4-6 Digits)',
                            labelStyle: const TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: const Color(0xFF26100E),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            if (!_otpSent) {
                              if (_phoneCtrl.text.length < 10) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Enter valid 10-digit mobile number!')));
                                return;
                              }
                              setState(() => _otpSent = true);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('OTP sent to your number!')));
                            } else {
                              if (_otpCtrl.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Enter OTP to continue!')));
                                return;
                              }
                              setState(() => _isLoggedIn = true);
                            }
                          },
                          child: Text(
                            _otpSent ? 'VERIFY & ENTER VIP LOBBY' : 'GET OTP LOGIN',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.greenAccent, size: 16),
                    SizedBox(width: 6),
                    Text('256-Bit SSL Encrypted & Provably Fair', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CASINO DASHBOARD LOBBY
// ---------------------------------------------------------------------------
class CasinoDashboard extends StatefulWidget {
  const CasinoDashboard({super.key});

  @override
  State<CasinoDashboard> createState() => _CasinoDashboardState();
}

class _CasinoDashboardState extends State<CasinoDashboard> {
  int _navIndex = 0;
  Timer? _liveTickerTimer;
  String _liveWinner = "User *******912 won ₹4,500 in Aviator 🚀";

  final List<String> _dummyWinners = [
    "User *******912 won ₹4,500 in Aviator 🚀",
    "User *******431 won ₹12,000 in Fortune Slots 💎",
    "User *******108 won ₹1,800 in 7 Up 7 Down 🎲",
    "User *******872 withdrew ₹10,000 instantly ⚡",
    "User *******622 won ₹8,400 in Aviator (42.0x) 🔥"
  ];

  @override
  void initState() {
    super.initState();
    _liveTickerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _liveWinner = _dummyWinners[Random().nextInt(_dummyWinners.length)];
        });
      }
    });
  }

  @override
  void dispose() {
    _liveTickerTimer?.cancel();
    super.dispose();
  }

  void _openScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen)).then((_) => setState(() {}));
  }

  void _showDepositModal() {
    int selectedAmt = 500;
    final amounts = [100, 300, 500, 1000, 2000, 5000];
    final utrCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF140807),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setM) {
          final qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=upi://pay?pa=$ADMIN_UPI_ID%26pn=${Uri.encodeComponent(ADMIN_NAME)}%26am=$selectedAmt%26cu=INR";

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('INSTANT UPI RECHARGE', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Step 1: Select Recharge Amount', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Column(
                      children: [
                        Image.network(qrUrl, height: 160, width: 160, fit: BoxFit.cover),
                        const SizedBox(height: 6),
                        Text('Scan & Pay ₹$selectedAmt to $ADMIN_NAME', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFF26100E), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(ADMIN_UPI_ID, style: const TextStyle(fontSize: 12, color: Colors.white70), overflow: TextOverflow.ellipsis)),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.amber, size: 20),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: ADMIN_UPI_ID));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('UPI ID Copied!')));
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
                      labelText: 'Step 2: Enter 12-Digit UTR / Ref Number',
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
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Please enter valid UTR Reference Number!')));
                          return;
                        }
                        setState(() {
                          WalletState.balance += selectedAmt;
                          WalletState.addTxn("UPI Recharge", selectedAmt.toDouble(), true, "Approved");
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('₹$selectedAmt Added to Wallet Successfully!')));
                      },
                      child: Text('SUBMIT UTR & ADD ₹$selectedAmt', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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

  void _showWithdrawModal() {
    final amtCtrl = TextEditingController();
    final upiCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF140807),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('INSTANT CASHOUT / WITHDRAW', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            Text('Withdrawable Balance: ₹ ${WalletState.balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 14),
            TextField(
              controller: amtCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Amount to Withdraw (Min ₹100)',
                prefixText: '₹ ',
                prefixStyle: const TextStyle(color: Colors.amber),
                filled: true,
                fillColor: const Color(0xFF26100E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: upiCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Your Receiving UPI ID (e.g. name@paytm)',
                filled: true,
                fillColor: const Color(0xFF26100E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Account Holder Name',
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
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  final val = double.tryParse(amtCtrl.text);
                  if (val == null || val < 100) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Minimum withdrawal is ₹100!')));
                    return;
                  }
                  if (val > WalletState.balance) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Insufficient balance!')));
                    return;
                  }
                  if (!upiCtrl.text.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Enter valid UPI ID!')));
                    return;
                  }
                  setState(() {
                    WalletState.balance -= val;
                    WalletState.addTxn("Withdrawal to ${upiCtrl.text.trim()}", val, false, "Processing (15-30m)");
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Payout request of ₹$val queued successfully!')));
                },
                child: const Text('SUBMIT WITHDRAWAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  void _showAdminPanel() {
    final marginCtrl = TextEditingController(text: (AdminConfig.houseEdge * 100).toStringAsFixed(0));
    final crashCtrl = TextEditingController(text: AdminConfig.maxCrash.toStringAsFixed(1));
    final slotCtrl = TextEditingController(text: (AdminConfig.slotWinRate * 100).toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C0B0A),
        title: const Text('⚙️ ADMIN PLATFORM CONTROL', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: marginCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'House Edge Margin (%)', filled: true, fillColor: Color(0xFF2B100E))),
            const SizedBox(height: 10),
            TextField(controller: crashCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Aviator Max Crash Limit (x)', filled: true, fillColor: Color(0xFF2B100E))),
            const SizedBox(height: 10),
            TextField(controller: slotCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Slot Win Rate (%)', filled: true, fillColor: Color(0xFF2B100E))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              setState(() {
                AdminConfig.houseEdge = (double.tryParse(marginCtrl.text) ?? 15.0) / 100;
                AdminConfig.maxCrash = double.tryParse(crashCtrl.text) ?? 10.0;
                AdminConfig.slotWinRate = (double.tryParse(slotCtrl.text) ?? 28.0) / 100;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Admin Controls updated!')));
            },
            child: const Text('Save Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF160807),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(6)),
              child: const Text('DD1', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16)),
            ),
            const SizedBox(width: 8),
            const Text('VIP CLUB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)),
          ],
        ),
        actions: [
          IconButton(onPressed: _showAdminPanel, icon: const Icon(Icons.admin_panel_settings, color: Colors.redAccent)),
          IconButton(onPressed: _showDepositModal, icon: const Icon(Icons.account_balance_wallet, color: Colors.amber)),
        ],
      ),
      body: ListView(
        children: [
          // Live Winning Announcement Ticker
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF2B0809),
            child: Row(
              children: [
                const Icon(Icons.volume_up, color: Colors.amber, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_liveWinner, style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),

          // User VIP Wallet Header
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2B100E), Color(0xFF140807)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.stars, color: Colors.black, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(WalletState.playerId, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('₹ ${WalletState.balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.amber)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: _showDepositModal,
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text('Deposit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: _showWithdrawModal,
                  icon: const Icon(Icons.arrow_upward, size: 16, color: Colors.white),
                  label: const Text('Withdraw', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Featured Big Banner
          GestureDetector(
            onTap: () => _openScreen(const ProAviatorScreen()),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B0000), Color(0xFF2B0000)],
                ),
                border: Border.all(color: Colors.amber, width: 1.5),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: () => _openScreen(const ProAviatorScreen()),
                      child: const Text('PLAY NOW', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HOT MULTIPLIER CRASH', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(height: 4),
                        Text('AVIATOR 100X', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
                        Text('Realtime live curve & Instant Cashouts', style: TextStyle(fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('POPULAR LIVE GAMES', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(height: 8),

          // Game Cards Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                _buildLobbyGameCard(
                  title: 'Aviator Crash',
                  tag: 'HOT 🚀',
                  desc: 'Cashout before flight escape',
                  color: const Color(0xFF6B0E0E),
                  onTap: () => _openScreen(const ProAviatorScreen()),
                ),
                _buildLobbyGameCard(
                  title: '7 Up 7 Down Dice',
                  tag: 'LIVE 🎲',
                  desc: 'Roll 2 Dice • Win 2X / 5X',
                  color: const Color(0xFF1E2D4A),
                  onTap: () => _openScreen(const ProSevenUpScreen()),
                ),
                _buildLobbyGameCard(
                  title: 'Fortune 777 Slots',
                  tag: 'JACKPOT 💎',
                  desc: 'Triple Diamond Mega Multiplier',
                  color: const Color(0xFF5C4308),
                  onTap: () => _openScreen(const ProSlotScreen()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (idx) {
          setState(() => _navIndex = idx);
          if (idx == 1) _showDepositModal();
          if (idx == 2) _showWithdrawModal();
          if (idx == 3) _showAdminPanel();
        },
        backgroundColor: const Color(0xFF160807),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'LOBBY'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'DEPOSIT'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'CASHOUT'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'ADMIN'),
        ],
      ),
    );
  }

  Widget _buildLobbyGameCard({required String title, required String tag, required String desc, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.amber.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                    child: Text(tag, style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(desc, style: const TextStyle(fontSize: 11, color: Colors.white60)),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill, color: Colors.amber, size: 36),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. PRO AVIATOR CRASH GAME (CANVAS CURVE + MULTIPLIER ENGINE)
// ---------------------------------------------------------------------------
class ProAviatorScreen extends StatefulWidget {
  const ProAviatorScreen({super.key});

  @override
  State<ProAviatorScreen> createState() => _ProAviatorScreenState();
}

enum AviatorState { countdown, flying, crashed }

class _ProAviatorScreenState extends State<ProAviatorScreen> {
  AviatorState _state = AviatorState.countdown;
  double _multiplier = 1.00;
  double _crashLimit = 2.50;
  int _countdown = 5;
  double _betAmount = 50.0;
  bool _betPlaced = false;
  bool _hasCashedOut = false;
  Timer? _flightTimer;
  final List<double> _history = [1.60, 2.80, 1.15, 6.40, 2.10];

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _flightTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _state = AviatorState.countdown;
      _countdown = 5;
      _multiplier = 1.00;
      _hasCashedOut = false;
    });

    _flightTimer?.cancel();
    _flightTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        t.cancel();
        _takeoff();
      }
    });
  }

  void _takeoff() {
    final rand = Random();
    bool houseCrash = rand.nextDouble() < AdminConfig.houseEdge;
    _crashLimit = houseCrash ? (1.05 + rand.nextDouble() * 0.35) : (1.20 + rand.nextDouble() * AdminConfig.maxCrash);

    setState(() {
      _state = AviatorState.flying;
      _multiplier = 1.00;
    });

    _flightTimer?.cancel();
    _flightTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      setState(() {
        _multiplier += 0.015 + (_multiplier * 0.012);
        if (_multiplier >= _crashLimit) {
          _multiplier = _crashLimit;
          _triggerCrash();
        }
      });
    });
  }

  void _triggerCrash() {
    _flightTimer?.cancel();
    setState(() {
      _state = AviatorState.crashed;
      _history.insert(0, double.parse(_multiplier.toStringAsFixed(2)));
      if (_history.length > 8) _history.removeLast();
      _betPlaced = false;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _startCountdown();
    });
  }

  void _placeBet() {
    if (WalletState.balance < _betAmount) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Insufficient balance!')));
      return;
    }
    setState(() {
      WalletState.balance -= _betAmount;
      _betPlaced = true;
      WalletState.addTxn("Aviator Bet", _betAmount, false, "Active");
    });
  }

  void _cashOut() {
    if (_betPlaced && !_hasCashedOut && _state == AviatorState.flying) {
      final win = _betAmount * _multiplier;
      setState(() {
        _hasCashedOut = true;
        _betPlaced = false;
        WalletState.balance += win;
        WalletState.addTxn("Aviator Win (${_multiplier.toStringAsFixed(2)}x)", win, true, "Won");
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('🎉 CASHED OUT ₹${win.toStringAsFixed(2)}!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080404),
      appBar: AppBar(
        backgroundColor: const Color(0xFF160807),
        title: const Text('AVIATOR', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.redAccent)),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('₹ ${WalletState.balance.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 16)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // History Line
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: const Color(0xFF100505),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _history.length,
              itemBuilder: (ctx, i) {
                final h = _history[i];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: h >= 2.0 ? Colors.purple.withOpacity(0.4) : Colors.blueGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: h >= 2.0 ? Colors.purpleAccent : Colors.white24),
                  ),
                  child: Center(
                    child: Text('${h.toStringAsFixed(2)}x', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: h >= 2.0 ? Colors.purpleAccent : Colors.white70)),
                  ),
                );
              },
            ),
          ),

          // Flight Canvas
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF120707),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: AviatorGraphPainter(
                      multiplier: _multiplier,
                      isCrashed: _state == AviatorState.crashed,
                    ),
                  ),
                  Center(
                    child: _state == AviatorState.countdown
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(color: Colors.amber),
                              const SizedBox(height: 12),
                              Text('STARTING IN $_countdown s', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber)),
                            ],
                          )
                        : _state == AviatorState.flying
                            ? Text(
                                '${_multiplier.toStringAsFixed(2)}x',
                                style: const TextStyle(fontSize: 58, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.redAccent, blurRadius: 20)]),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('FLEW AWAY!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                                  Text('${_multiplier.toStringAsFixed(2)}x', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.redAccent)),
                                ],
                              ),
                  ),
                ],
              ),
            ),
          ),

          // Bet Actions Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF160807),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [50, 100, 200, 500].map((amt) {
                    final isSel = _betAmount == amt.toDouble();
                    return GestureDetector(
                      onTap: _betPlaced ? null : () => setState(() => _betAmount = amt.toDouble()),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSel ? Colors.amber : const Color(0xFF26100E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('₹$amt', style: TextStyle(color: isSel ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: _betPlaced && _state == AviatorState.flying
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: _cashOut,
                          child: Text('CASH OUT ₹${(_betAmount * _multiplier).toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _betPlaced ? Colors.grey : const Color(0xFF2E7D32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _betPlaced || _state == AviatorState.flying ? null : _placeBet,
                          child: Text(_betPlaced ? 'WAITING FOR NEXT ROUND' : 'BET ₹${_betAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AviatorGraphPainter extends CustomPainter {
  final double multiplier;
  final bool isCrashed;

  AviatorGraphPainter({required this.multiplier, required this.isCrashed});

  @override
  void paint(Canvas canvas, Size size) {
    if (multiplier <= 1.0 && !isCrashed) return;

    final paintLine = Paint()
      ..color = isCrashed ? Colors.redAccent.withOpacity(0.4) : Colors.redAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height);

    double progress = ((multiplier - 1.0) / 8.0).clamp(0.0, 1.0);
    double endX = size.width * (0.2 + (progress * 0.75));
    double endY = size.height - (size.height * (0.15 + (progress * 0.75)));

    path.quadraticBezierTo(endX * 0.5, size.height, endX, endY);
    canvas.drawPath(path, paintLine);

    if (!isCrashed && multiplier > 1.0) {
      final rocketPaint = Paint()..color = Colors.amber;
      canvas.drawCircle(Offset(endX, endY), 8, rocketPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AviatorGraphPainter oldDelegate) => true;
}

// ---------------------------------------------------------------------------
// 2. 7 UP 7 DOWN SCREEN
// ---------------------------------------------------------------------------
class ProSevenUpScreen extends StatefulWidget {
  const ProSevenUpScreen({super.key});

  @override
  State<ProSevenUpScreen> createState() => _ProSevenUpScreenState();
}

class _ProSevenUpScreenState extends State<ProSevenUpScreen> {
  int _d1 = 3;
  int _d2 = 4;
  bool _isRolling = false;
  String? _selected;
  double _bet = 50.0;

  void _roll() {
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Select 7 Down, Lucky 7, or 7 Up!')));
      return;
    }
    if (WalletState.balance < _bet) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Insufficient balance!')));
      return;
    }

    setState(() {
      WalletState.balance -= _bet;
      _isRolling = true;
      WalletState.addTxn("7Up 7Down Bet", _bet, false, "Active");
    });

    Timer(const Duration(milliseconds: 1200), () {
      final r = Random();
      final r1 = r.nextInt(6) + 1;
      final r2 = r.nextInt(6) + 1;
      final sum = r1 + r2;

      double payout = 0;
      if (sum < 7 && _selected == 'down') payout = _bet * 2;
      if (sum == 7 && _selected == 'seven') payout = _bet * 5;
      if (sum > 7 && _selected == 'up') payout = _bet * 2;

      setState(() {
        _d1 = r1;
        _d2 = r2;
        _isRolling = false;
        if (payout > 0) {
          WalletState.balance += payout;
          WalletState.addTxn("7Up Win (Sum $sum)", payout, true, "Won");
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: payout > 0 ? Colors.green : Colors.red,
          content: Text(payout > 0 ? '🎉 Sum is $sum! Won ₹$payout' : '❌ Sum is $sum! Better luck next roll.'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080404),
      appBar: AppBar(title: const Text('7 UP 7 DOWN'), backgroundColor: const Color(0xFF160807)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E0A09),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDiceBox(_d1),
                const SizedBox(width: 16),
                _buildDiceBox(_d2),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildChoiceChip('2 - 6', '7 DOWN (2X)', 'down'),
              _buildChoiceChip('7', 'LUCKY 7 (5X)', 'seven'),
              _buildChoiceChip('8 - 12', '7 UP (2X)', 'up'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: _isRolling ? null : _roll,
                child: Text(_isRolling ? 'ROLLING...' : 'ROLL DICE (₹${_bet.toStringAsFixed(0)})', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceBox(int val) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text('$val', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black))),
    );
  }

  Widget _buildChoiceChip(String sub, String title, String key) {
    final isSel = _selected == key;
    return GestureDetector(
      onTap: () => setState(() => _selected = key),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSel ? Colors.amber : const Color(0xFF1C0B0A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSel ? Colors.white : Colors.amber.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(sub, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSel ? Colors.black : Colors.amber)),
            Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSel ? Colors.black87 : Colors.white70)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. FORTUNE SLOTS SCREEN
// ---------------------------------------------------------------------------
class ProSlotScreen extends StatefulWidget {
  const ProSlotScreen({super.key});

  @override
  State<ProSlotScreen> createState() => _ProSlotScreenState();
}

class _ProSlotScreenState extends State<ProSlotScreen> {
  final List<String> _items = ['💎', '7️⃣', '🔔', '🍒', '⭐'];
  String _s1 = '💎', _s2 = '7️⃣', _s3 = '💎';
  bool _spinning = false;
  double _bet = 20.0;

  void _spin() {
    if (WalletState.balance < _bet) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Insufficient balance!')));
      return;
    }

    setState(() {
      WalletState.balance -= _bet;
      _spinning = true;
      WalletState.addTxn("Slot Spin", _bet, false, "Active");
    });

    Timer(const Duration(milliseconds: 1000), () {
      final r = Random();
      bool forceWin = r.nextDouble() < AdminConfig.slotWinRate;

      String s1 = _items[r.nextInt(_items.length)];
      String s2 = forceWin ? s1 : _items[r.nextInt(_items.length)];
      String s3 = forceWin ? s1 : _items[r.nextInt(_items.length)];

      double win = 0;
      if (s1 == s2 && s2 == s3) win = _bet * 10;
      else if (s1 == s2 || s2 == s3 || s1 == s3) win = _bet * 2;

      setState(() {
        _s1 = s1;
        _s2 = s2;
        _s3 = s3;
        _spinning = false;
        if (win > 0) {
          WalletState.balance += win;
          WalletState.addTxn("Slot Jackpot Win", win, true, "Won");
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: win > 0 ? Colors.green : Colors.grey[800],
          content: Text(win > 0 ? '🎰 JACKPOT! Won ₹$win' : 'Better luck next spin!'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080404),
      appBar: AppBar(title: const Text('FORTUNE SLOTS'), backgroundColor: const Color(0xFF160807)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E0A09),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 2),
                boxShadow: const [BoxShadow(color: Colors.amberAccent, blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(_s1, style: const TextStyle(fontSize: 48)),
                  Text(_s2, style: const TextStyle(fontSize: 48)),
                  Text(_s3, style: const TextStyle(fontSize: 48)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _spinning ? null : _spin,
                  child: Text(_spinning ? 'SPINNING...' : 'SPIN FOR ₹${_bet.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
