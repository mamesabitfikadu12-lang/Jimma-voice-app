8import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'games_moments.dart';
import 'task_settings_admin.dart';

class TronVerifyHelper {
  static const String wallet = 'TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE';
  static const String usdtContract = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';

  static Future<double?> fetchUsdtReceived(String txHash) async {
    final clean = txHash.trim();
    if (clean.length < 20) return null;
    try {
      final url = Uri.parse('https://tronscanapi.com');
      final res = await http.get(url).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body);
      if (data['confirmed'] != true && data['contractRet'] != 'SUCCESS') return null;
      final list = data['trc20TransferInfo'] as List?;
      if (list == null) return null;
      for (final item in list) {
        if (item['to_address'] == wallet && item['contract_address'] == usdtContract) {
          final raw = double.tryParse('${item['amount_str']}') ?? 0;
          return raw / 1000000.0;
        }
      }
    } catch (_) {}
    return null;
  }
}

class MeTab extends StatefulWidget {
  final VoidCallback onUpd;
  const MeTab({super.key, required this.onUpd});
  @override
  State<MeTab> createState() => _MeTabState();
}

class _MeTabState extends State<MeTab> {
  void _go(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) {
      if (mounted) {
        setState(() {});
        widget.onUpd();
      }
    });
  }

  void _openWallet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _WalletSheet(onUpd: () {
        setState(() {});
        widget.onUpd();
      }),
    );
  }

    Future<void> _claimDailyBonus() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (prefs.getString('last_daily_bonus') == today) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.orange, content: Text('Daily Bonus already claimed today! Come back tomorrow.')),
      );
      return;
    }
    setState(() {
      AppState.coins += 1000;
    });
    await prefs.setString('last_daily_bonus', today);
    await prefs.setInt('coins', AppState.coins);
    widget.onUpd();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Colors.green, content: Text('🎁 Daily Bonus Claimed: +1,000 Free Coins!')),
    );
  }

  void _editProfile() {
    final nameCtrl = TextEditingController(text: AppState.userName);
    final phoneCtrl = TextEditingController(text: AppState.userPhone);
    final passCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Create / Save My Account', style: TextStyle(color: Colors.amber)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Username / Display Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone Number or Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Create Password (Optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            onPressed: () async {
              setState(() {
                if (nameCtrl.text.trim().isNotEmpty) AppState.userName = nameCtrl.text.trim();
                if (phoneCtrl.text.trim().isNotEmpty) AppState.userPhone = phoneCtrl.text.trim();
              });
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('logged_in', true);
              await prefs.setString('user_name', AppState.userName);
              await prefs.setString('user_id', AppState.userId);
              await prefs.setString('user_phone', AppState.userPhone);
              await prefs.setInt('coins', AppState.coins);
              if (passCtrl.text.trim().isNotEmpty) {
                await prefs.setString('user_pass', passCtrl.text.trim());
              }
              widget.onUpd();
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Colors.green, content: Text('✅ Account & Coins Saved Permanently!')),
                );
              }
            },
            child: const Text('Save Account', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }


  Widget _gridBtn(IconData icon, Color color, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initial = AppState.userName.isNotEmpty ? AppState.userName.toUpperCase() : 'U';
    return Scaffold(
            appBar: AppBar(
        title: const Text('Me'),
        actions: [
          IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amber), tooltip: 'Daily Bonus', onPressed: _claimDailyBonus),
          IconButton(icon: const Icon(Icons.person_add_alt_1, color: Colors.tealAccent), tooltip: 'Save Account', onPressed: _editProfile),
          IconButton(icon: const Icon(Icons.settings), onPressed: () => _go(SettingsPage())),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.35)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.tealAccent,
                  child: Text(
                    initial,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              AppState.userName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (AppState.vipLevel > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'VIP ${AppState.vipLevel}',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: AppState.userId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User ID copied!')),
                          );
                        },
                        child: Text(
                          'ID: ${AppState.userId} 📋',
                          style: const TextStyle(fontSize: 12, color: Colors.tealAccent),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Welcome to Voice Chat ET!',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _openWallet,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('My Coins', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text(
                          '🪙 ${AppState.coins}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => _go(PointsCashOutPage(onUpd: widget.onUpd)),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('My Diamonds', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text(
                          '💎 ${AppState.points.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
                    const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.92,
            children: [
              _gridBtn(Icons.account_balance_wallet, Colors.amber, 'Recharge', () => _go(CoinSellerPage(onUpd: widget.onUpd))),
              _gridBtn(Icons.storefront, Colors.pinkAccent, 'Store', () => _go(StorePage(onUpd: widget.onUpd))),
              _gridBtn(Icons.card_giftcard, Colors.redAccent, 'Invitation', () => _go(InvitationBonusPage(onUpd: widget.onUpd))),
              _gridBtn(Icons.backpack, Colors.lightBlueAccent, 'Backpack', () => _go(BackpackPage(onUpd: widget.onUpd))),
              _gridBtn(Icons.casino, Colors.greenAccent, 'Lucky Island', () => _go(LuckyIslandPage(onUpd: widget.onUpd))),
              _gridBtn(Icons.stars, Colors.purpleAccent, 'Level', () => _go(WealthCharmLevelPage())),
              _gridBtn(Icons.task_alt, Colors.tealAccent, 'Task', () => _go(TaskCenterFullPage(onUpd: widget.onUpd))),
              _gridBtn(Icons.military_tech, Colors.orangeAccent, 'Badge', () => _go(BadgeCollectionPage())),
class HostCenterPage extends StatelessWidget {
  final VoidCallback onUpd;
  const HostCenterPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Host Center")),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              title: const Text("My Diamonds Balance"),
              subtitle: Text("${AppState.points.toStringAsFixed(2)} Diamonds"),
              trailing: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointsCashOutPage(onUpd: onUpd))),
                child: const Text("Cash Out"),
              ),
            ),
          ),
          const Card(
            color: Color(0xFF1E293B),
            child: ListTile(
              title: Text("Host Revenue Split"),
              subtitle: Text("70% Direct Host Payout (CBE / Telebirr / USDT) • 15% Agency Bonus"),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Voice Chat ET")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          color: Color(0xFF1E293B),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text("Voice Chat ET (v3.0.9)\nLive Audio Rooms, 3D Social Games & Official Agencies.\nSupport: @Mosabit11 | +251919108311"),
          ),
        ),
      ),
    );
  }
}

class InvitationBonusPage extends StatelessWidget {
  final VoidCallback onUpd;
  const InvitationBonusPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    final code = "ET${AppState.userId}";
    return Scaffold(
      appBar: AppBar(title: const Text("Invitation Rewards")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: "Join Voice Chat ET with code $code!"));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Invite Link Copied!")));
          },
          child: Text("Copy Invite Code: $code"),
        ),
      ),
    );
  }
}

class BackpackPage extends StatelessWidget {
  final VoidCallback onUpd;
  const BackpackPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Backpack")),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: const [
          Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.directions_car, color: Colors.amber), title: Text("Golden Lion Entry Car"), subtitle: Text("Active • 7 Days"))),
          Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.stars, color: Colors.cyanAccent), title: Text("VIP Royal Mic Frame"), subtitle: Text("Equipped"))),
        ],
      ),
    );
  }
}

class LuckyIslandPage extends StatelessWidget {
  final VoidCallback onUpd;
  const LuckyIslandPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lucky Island Spin")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (AppState.coins < 100) return;
            AppState.coins += 200;
            onUpd();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text("🎉 Lucky Island Won +200 Coins!")));
          },
          child: const Text("Spin Lucky Island (100 Coins)"),
        ),
      ),
    );
  }
}

class BadgeCollectionPage extends StatelessWidget {
  const BadgeCollectionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Badges")),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: const [
          Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.verified, color: Colors.amber), title: Text("Pioneer Member Badge"), subtitle: Text("Unlocked on registration"))),
          Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.local_fire_department, color: Colors.redAccent), title: Text("Top Gifter Badge"), subtitle: Text("Send 10,000+ Coins in rooms"))),
        ],
      ),
    );
  }
}
