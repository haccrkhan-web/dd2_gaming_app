// AuthScreen ke andar Google Sign-In Handler
class _AuthScreenState extends State<AuthScreen> {
  bool _loading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        // User session update with Google Details
        UserSession.playerId = "VIP_${account.email.split('@')[0].toUpperCase()}";
        UserSession.mobileNumber = account.email;
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainLobbyScreen()),
          );
        }
      }
    } catch (error) {
      // Fallback Demo Login agar Google Services phone me offline ho
      UserSession.playerId = "VIP_GOOGLE_${Random().nextInt(8999) + 1000}";
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLobbyScreen()),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
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
                    'DD1 VIP CASINO',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.amber, letterSpacing: 2),
                  ),
                  const Text(
                    'SIGN IN TO ACCESS VIP GAMES & WALLET',
                    style: TextStyle(color: Colors.white60, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 36),

                  // GOOGLE 1-TAP SIGN IN BUTTON
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
                      icon: Image.network(
                        'https://fonts.gstatic.com/s/i/productlogos/googleg/v6/24px.svg',
                        height: 22,
                        width: 22,
                        errorBuilder: (ctx, _, __) => const Icon(Icons.account_circle, color: Colors.redAccent, size: 22),
                      ),
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
                        child: Text('OR QUICK GUEST LOGIN', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // DIRECT INSTANT GUEST PASS
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

