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
              _gridBtn(Icons.mic, Colors.cyanAccent, 'Host Center', () => _go(HostCenterPage(onUpd: widget.onUpd))),
              _gridBtn(Icons.business_center, Colors.teal, 'Agency', () => _go(AgencyWebPortalPage())),
              _gridBtn(Icons.verified_user, Colors.amberAccent, 'Coin Seller', () => _go(OfficialAgentsDirectoryPage())),
              _gridBtn(Icons.headset_mic, Colors.blueAccent, 'Support', () => _go(const SupportChatPage())),
              _gridBtn(Icons.info_outline, Colors.green, 'About', () => _go(const AboutAppPage())),
              _gridBtn(Icons.settings, Colors.grey, 'Setting', () => _go(SettingsPage(onUpd: widget.onUpd))),
            ],
          ),
      ),
    );
  }
}

class _WalletSheet extends StatefulWidget {
  final VoidCallback onUpd;
  const _WalletSheet({required this.onUpd});
  @override
  State<_WalletSheet> createState() => _WalletSheetState();
}

class _WalletSheetState extends State<_WalletSheet> {
  final _hashCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick USDT (TRC20) Recharge', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Wallet: ${TronVerifyHelper.wallet}', style: const TextStyle(fontSize: 11.5, color: Colors.tealAccent)),
          const SizedBox(height: 10),
          TextField(
            controller: _hashCtrl,
            decoration: const InputDecoration(labelText: 'TronScan TxID / Hash'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 46),
            ),
            onPressed: _loading
                ? null
                : () async {
                    setState(() => _loading = true);
                    final usdt = await TronVerifyHelper.fetchUsdtReceived(_hashCtrl.text);
                    if (mounted) setState(() => _loading = false);
                    if (usdt != null && usdt > 0) {
                      final coins = (usdt * 10000).round();
                      setState(() => AppState.coins += coins);
                      widget.onUpd();
                      if (mounted) Navigator.pop(context);
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(backgroundColor: Colors.red, content: Text('Invalid or unconfirmed USDT hash.')),
                      );
                    }
                  },
            child: Text(_loading ? 'Checking...' : 'Verify USDT Recharge'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => CoinSellerPage(onUpd: widget.onUpd)));
            },
            child: const Text('Open CBE & Official Coin Seller ->', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }
}
class CoinSellerPage extends StatefulWidget {
  final VoidCallback onUpd;
  const CoinSellerPage({super.key, required this.onUpd});
  @override
  State<CoinSellerPage> createState() => _CoinSellerPageState();
}

class _CoinSellerPageState extends State<CoinSellerPage> {
  String _salesType = 'User';
  final _toIdCtrl = TextEditingController();
  bool _toChecked = false, _verifyingUsdt = false;
  final _trAmtCtrl = TextEditingController(text: '10');

  String _payMethod = 'USDT (TRC20)';
  final _customCoinsCtrl = TextEditingController(text: '100000');
  final _sellerHashCtrl = TextEditingController();
  int _selectedTier = 0;
  final _exCustomCtrl = TextEditingController(text: '1000000');

  final Map<String, String> _localBanks = {
    'USDT (TRC20)': TronVerifyHelper.wallet,
    'Binance Pay': TronVerifyHelper.wallet,
    'CBE': '1000273060937',
  };

  final _usdTiers = List<Map<String, dynamic>>.of([
    {'coins': 100000, 'usd': 10.0, 'tag': 'MIN'},
    {'coins': 990000, 'usd': 100.0, 'tag': ''},
    {'coins': 1980000, 'usd': 200.0, 'tag': ''},
    {'coins': 9900000, 'usd': 1000.0, 'tag': ''},
    {'coins': 14850000, 'usd': 1500.0, 'tag': ''},
    {'coins': 30000000, 'usd': 3000.0, 'tag': 'Senior Seller'},
  ]);

  final _etbTiers = List<Map<String, dynamic>>.of([
    {'coins': 10000, 'etb': 180, 'tag': 'MIN'},
    {'coins': 100000, 'etb': 1800, 'tag': ''},
    {'coins': 1000000, 'etb': 18000, 'tag': ''},
    {'coins': 5000000, 'etb': 90000, 'tag': ''},
    {'coins': 15000000, 'etb': 270000, 'tag': ''},
    {'coins': 30000000, 'etb': 540000, 'tag': 'Senior Seller'},
  ]);

  String get _sellerLevel {
    if (AppState.coins >= 30000000) return 'Senior Seller';
    if (AppState.coins >= 2000000) return 'Standard Seller';
    return 'Beginner';
  }

  double get _exchangeRate {
    if (_sellerLevel == 'Senior Seller') return 1.0;
    if (_sellerLevel == 'Standard Seller') return 0.98;
    return 0.96;
  }

  @override
  Widget build(BuildContext context) {
    final isCrypto = _payMethod == 'USDT (TRC20)' || _payMethod == 'Binance Pay';
    final tiers = isCrypto ? _usdTiers : _etbTiers;
    final customCoins = int.tryParse(_customCoinsCtrl.text) ?? (isCrypto ? 100000 : 10000);
    final usdNeeded = customCoins / 10000.0;
    final customPrice = isCrypto
        ? '${usdNeeded.toStringAsFixed(1)} USDT'
        : '${((customCoins / 10000) * 180).toStringAsFixed(0)} ETB';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('Coin Seller')),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF78350F), Color(0xFFB45309)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Balance', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      Text(
                        '🪙 ${AppState.coins}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      Text(
                        'Current level: $_sellerLevel',
                        style: const TextStyle(fontSize: 11, color: Colors.amber),
                      ),
                    ],
                  ),
                  const Text('🪙', style: TextStyle(fontSize: 42)),
                ],
              ),
            ),
            const TabBar(
              indicatorColor: Colors.tealAccent,
              labelColor: Colors.tealAccent,
              tabs: [Tab(text: 'Transfer'), Tab(text: 'Recharge'), Tab(text: 'Exchange')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(14),
                    children: [
                      Row(
                        children: [
                          const Text('Sales Method: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          ChoiceChip(
                            label: const Text('User'),
                            selected: _salesType == 'User',
                            selectedColor: Colors.tealAccent,
                            onSelected: (_) => setState(() => _salesType = 'User'),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Coinseller'),
                            selected: _salesType == 'Coinseller',
                            selectedColor: Colors.tealAccent,
                            onSelected: (_) => setState(() => _salesType = 'Coinseller'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _toIdCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Receiving ID (To)'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_toIdCtrl.text.trim().length >= 5) {
                                setState(() => _toChecked = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Recipient ID verified!'),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              _toChecked ? 'Verified ✓' : 'Check',
                              style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _trAmtCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Transfer Amount (Units of 1,000)'),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Coins to Send: ${(int.tryParse(_trAmtCtrl.text) ?? 0) * 1000}',
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () {
                          final sendCoins = (int.tryParse(_trAmtCtrl.text) ?? 0) * 1000;
                          if (!_toChecked || sendCoins < 1000 || AppState.coins < sendCoins) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Verify ID and check coin balance.'),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            AppState.coins -= sendCoins;
                            AppState.isCoinSeller = true;
                          });
                          widget.onUpd();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Transferred $sendCoins Coins to ID ${_toIdCtrl.text.trim()}!'),
                            ),
                          );
                        },
                        child: const Text('Transfer', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(14),
                    children: [
                      DropdownButtonFormField<String>(
                        value: _payMethod,
                        decoration: const InputDecoration(labelText: 'Auto-Verify Payment Method (USDT / CBE)'),
                        items: _localBanks.keys
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (v) => setState(() {
                          _payMethod = v ?? 'USDT (TRC20)';
                          _customCoinsCtrl.text =
                              (_payMethod == 'USDT (TRC20)' || _payMethod == 'Binance Pay')
                                  ? '100000'
                                  : '10000';
                        }),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tiers.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 2.3,
                        ),
                        itemBuilder: (_, i) {
                          final t = tiers.elementAt(i);
                          final sel = _selectedTier == i;
                          final priceLabel = isCrypto ? '\$${t['usd']} USD' : '${t['etb']} ETB';
                          return InkWell(
                            onTap: () => setState(() {
                              _selectedTier = i;
                              _customCoinsCtrl.text = '${t['coins']}';
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: sel ? Colors.amber.withOpacity(0.22) : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: sel ? Colors.amber : Colors.white12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if ((t['tag'] as String).isNotEmpty)
                                    Text(
                                      t['tag'] as String,
                                      style: const TextStyle(fontSize: 9, color: Colors.amber),
                                    ),
                                  Text(
                                    '🪙 ${t['coins']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    priceLabel,
                                    style: const TextStyle(
                                      color: Colors.tealAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _customCoinsCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: isCrypto
                              ? 'Custom Coins (Min 100,000 = \$10)'
                              : 'Custom Coins (Min 10,000 = 180 ETB)',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: const Color(0xFF1E293B),
                        child: ListTile(
                          title: Text(
                            '$_payMethod • Pay: $customPrice',
                            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            _localBanks[_payMethod] ?? '',
                            style: const TextStyle(fontSize: 11.5),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy, color: Colors.tealAccent),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _localBanks[_payMethod] ?? ''));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Account / Wallet address copied!'),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _sellerHashCtrl,
                        decoration: InputDecoration(
                          labelText: isCrypto
                              ? 'TronScan 64-char TxID / Hash'
                              : 'CBE Transaction ID / Ref (e.g. FT26...)',
                          prefixIcon: const Icon(Icons.receipt_long, color: Colors.tealAccent),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: _verifyingUsdt
                            ? null
                            : () async {
                                final tx = _sellerHashCtrl.text.trim();
                                if (tx.length < 5) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Please enter a valid CBE Transaction ID or USDT TxID.'),
                                    ),
                                  );
                                  return;
                                }
                                setState(() => _verifyingUsdt = true);
                                try {
                                  final res = await http
                                      .post(
                            Uri.parse('https://onrender.com'),
                                        headers: {'Content-Type': 'application/json'},
                                        body: jsonEncode({
                                          'userId': AppState.userId,
                                          'method': _payMethod,
                                          'transactionId': tx,
                                          'expectedEtb': ((customCoins / 10000) * 180).round(),
                                          'expectedUsdt': usdNeeded,
                                          'requestedCoins': customCoins,
                                        }),
                                      )
                                      .timeout(const Duration(seconds: 45));
                                  final data = jsonDecode(res.body);
                                  if (mounted) setState(() => _verifyingUsdt = false);
                                  if (res.statusCode == 200 && data['success'] == true) {
                                    final int added = (data['coinsAdded'] as num?)?.toInt() ?? customCoins;
                                    setState(() {
                                      AppState.coins += added;
                                      AppState.isCoinSeller = true;
                                      _sellerHashCtrl.clear();
                                    });
                                    widget.onUpd();
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(data['message'] ?? 'Payment verified! +$added Coins'),
                                        ),
                                      );
                                    }
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              data['message'] ?? 'Verification failed. Check your Transaction ID.'),
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    setState(() => _verifyingUsdt = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.orange,
                                        content: Text(
                                            'Network slow. Please wait 10 seconds and tap Auto-Verify again.'),
                                      ),
                                    );
                                  }
                                }
                              },
                        child: Text(
                          _verifyingUsdt
                              ? 'Verifying Payment...'
                              : 'Auto-Verify & Get $customCoins Coins',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(14),
                    children: [
                      Text(
                        'My Points: 💎 ${AppState.points.toStringAsFixed(3)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _exCustomCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Custom Coins to Exchange (Min 1,000,000)'),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Exchange Rate ($_sellerLevel): ${(_exchangeRate * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.amber),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () {
                          final exCoins = int.tryParse(_exCustomCtrl.text) ?? 0;
                          final reqPts = exCoins / 10000.0;
                          if (exCoins < 1000000 || AppState.points < reqPts) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Minimum 1,000,000 coins & sufficient points required.'),
                              ),
                            );
                            return;
                          }
                          final finalCoins = (exCoins * _exchangeRate).round();
                          setState(() {
                            AppState.points -= reqPts;
                            AppState.coins += finalCoins;
                          });
                          widget.onUpd();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Exchanged for $finalCoins Coins!'),
                            ),
                          );
                        },
                        child: const Text('Exchange Now', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class StorePage extends StatefulWidget {
  final VoidCallback onUpd;
  const StorePage({super.key, required this.onUpd});
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final Set<String> _owned = {};
  String _equipped = '';
  final _items = const [
    {'id': 'f_gold', 'name': 'Golden Crown Frame', 'cat': 'Frame', 'price': 5000, 'icon': '👑'},
    {'id': 'f_fire', 'name': 'Phoenix Fire Frame', 'cat': 'Frame', 'price': 12000, 'icon': '🔥'},
    {'id': 'f_neon', 'name': 'Cyber Neon Frame', 'cat': 'Frame', 'price': 8000, 'icon': '💠'},
    {'id': 'v_lambo', 'name': 'Sports Car Entry', 'cat': 'Vehicle', 'price': 25000, 'icon': '🏎️'},
    {'id': 'v_jet', 'name': 'Private Jet Entry', 'cat': 'Vehicle', 'price': 60000, 'icon': '✈️'},
    {'id': 'v_lion', 'name': 'Golden Lion Entry', 'cat': 'Vehicle', 'price': 45000, 'icon': '🦁'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store & Backpack')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            color: const Color(0xFF1E293B),
            child: Text(
              'My Coins: 🪙 ${AppState.coins}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final it = _items[i];
                final id = it['id'] as String;
                final owned = _owned.contains(id);
                final equipped = _equipped == id;
                return Card(
                  color: const Color(0xFF1E293B),
                  child: ListTile(
                    leading: Text(it['icon'] as String, style: const TextStyle(fontSize: 30)),
                    title: Text(it['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${it['cat']} • 🪙 ${it['price']} Coins'),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: equipped ? Colors.green : (owned ? Colors.amber : Colors.tealAccent),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        if (!owned) {
                          final price = it['price'] as int;
                          if (AppState.coins < price) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(backgroundColor: Colors.red, content: Text('Not enough coins!')),
                            );
                            return;
                          }
                          setState(() {
                            AppState.coins -= price;
                            _owned.add(id);
                          });
                        }
                        setState(() => _equipped = id);
                        widget.onUpd();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(backgroundColor: Colors.green, content: Text('${it['name']} equipped!')),
                        );
                      },
                      child: Text(equipped ? 'Equipped' : (owned ? 'Equip' : 'Buy')),
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
}
class PointsCashOutPage extends StatefulWidget {
  final VoidCallback onUpd;
  const PointsCashOutPage({super.key, required this.onUpd});
  @override
  State<PointsCashOutPage> createState() => _PointsCashOutPageState();
}

class _PointsCashOutPageState extends State<PointsCashOutPage> {
  final _amtCtrl = TextEditingController(text: '100');
  final _accCtrl = TextEditingController();
  String _method = 'Telebirr';

  @override
  Widget build(BuildContext context) {
    final pts = double.tryParse(_amtCtrl.text) ?? 0;
    final etb = (pts * 10).toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(title: const Text('Points Cash Out')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Available Diamonds / Points', style: TextStyle(color: Colors.white70)),
                Text(
                  '💎 ${AppState.points.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
                ),
                const Text('Rate: 100 Points = 1,000 ETB', style: TextStyle(fontSize: 12, color: Colors.amber)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: _method,
            decoration: const InputDecoration(labelText: 'Withdrawal Method'),
            items: const ['Telebirr', 'CBE', 'USDT (TRC20)']
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => setState(() => _method = v ?? 'Telebirr'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _accCtrl,
            decoration: const InputDecoration(labelText: 'Account Number / Wallet Address'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amtCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Points to Withdraw (Min 100)'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
    Text(
       _method == 'USDT (TRC20)'
           ? 'Estimated Payout: \$${(pts * 0.0555).toStringAsFixed(2)} USDT'
           : 'Estimated Payout: $etb ETB',
       style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
     ),

          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 48),
            ),
                        onPressed: () async {
              if (pts < 100 || AppState.points < pts || _accCtrl.text.trim().length < 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Colors.red, content: Text('Check minimum 100 points & account details.')),
                );
                return;
              }
              try {
                await http.post(
                  Uri.parse('https://Jimma-voice-app.onrender.comonrender.com'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'userId': AppState.userId,
                    'userName': AppState.userName,
                    'method': _method,
                    'account': _accCtrl.text.trim(),
                    'points': pts,
                    'etbAmount': pts * 10,
                  }),
                ).timeout(const Duration(seconds: 15));
              } catch (_) {}
              setState(() => AppState.points -= pts);
              widget.onUpd();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Colors.green, content: Text('Withdrawal request saved to server!')),
                );
              }
            },

                  
            child: const Text('Request Cash Out', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class VipClubPage extends StatefulWidget {
  final VoidCallback onUpd;
  const VipClubPage({super.key, required this.onUpd});
  @override
  State<VipClubPage> createState() => _VipClubPageState();
}

class _VipClubPageState extends State<VipClubPage> {
  final _levels = const [
    {'lvl': 1, 'name': 'VIP 1 Bronze', 'cost': 10000, 'perk': 'Bronze Badge + Chat Color'},
    {'lvl': 2, 'name': 'VIP 2 Silver', 'cost': 30000, 'perk': 'Silver Badge + Entry Banner'},
    {'lvl': 3, 'name': 'VIP 3 Gold', 'cost': 80000, 'perk': 'Gold Crown + Room Priority'},
    {'lvl': 4, 'name': 'VIP 4 Diamond', 'cost': 200000, 'perk': 'Diamond Aura + Kick Protection'},
    {'lvl': 5, 'name': 'VIP 5 Emperor', 'cost': 500000, 'perk': 'Emperor Title + All Vehicles'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VIP Club & Badges')),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _levels.length,
        itemBuilder: (_, i) {
          final v = _levels[i];
          final lvl = v['lvl'] as int;
          final active = AppState.vipLevel >= lvl;
          return Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Text('V$lvl', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              title: Text(v['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${v['perk']} • 🪙 ${v['cost']} Coins'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: active ? Colors.green : Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: active
                    ? null
                    : () {
                        final cost = v['cost'] as int;
                        if (AppState.coins < cost) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(backgroundColor: Colors.red, content: Text('Not enough coins for VIP!')),
                          );
                          return;
                        }
                        setState(() {
                          AppState.coins -= cost;
                          AppState.vipLevel = lvl;
                        });
                        widget.onUpd();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(backgroundColor: Colors.green, content: Text('Activated ${v['name']}!')),
                        );
                      },
                child: Text(active ? 'Active' : 'Activate'),
              ),
            ),
          );
        },
      ),
    );
  }
}
class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key});
  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final _msgCtrl = TextEditingController();
  String _category = 'Coins Not Credited';
  String? _screenshotBase64;
  bool _sending = false;
  List<dynamic> _tickets = [];

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      final res = await http
          .get(Uri.parse('https://onrender.com{AppState.userId}'))
          .timeout(const Duration(seconds: 12));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (mounted) setState(() => _tickets = (data['tickets'] as List?) ?? []);
      }
    } catch (_) {}
  }

  Future<void> _pickScreenshot() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 55, maxWidth: 900);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() => _screenshotBase64 = base64Encode(bytes));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text('Screenshot attached! Ready to send.')),
        );
      }
    }
  }

  Future<void> _sendTicket() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty && _screenshotBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text('Write a message or attach payment screenshot.')),
      );
      return;
    }
    setState(() => _sending = true);
    try {
      await http
          .post(
            Uri.parse('https://onrender.com'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userId': AppState.userId,
              'userName': AppState.userName,
              'category': _category,
              'message': text.isEmpty ? 'Payment receipt screenshot attached' : text,
              'screenshotBase64': _screenshotBase64,
            }),
          )
          .timeout(const Duration(seconds: 20));
      _msgCtrl.clear();
      setState(() => _screenshotBase64 = null);
      await _loadTickets();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text('Sent to Admin Support! We will reply shortly.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.orange, content: Text('Network slow. Please tap Send again.')),
        );
      }
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D9488),
        title: const Text('Voice Chat ET Support'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTickets),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF1E293B),
            child: const Text(
              '🔔 Customer Service Hours: 24/7 • Attach payment screenshot if coins were delayed.',
              style: TextStyle(fontSize: 11.5, color: Colors.tealAccent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Issue Category', isDense: true),
              items: const ['Coins Not Credited', 'Cash Out Issue', 'Account / VIP', 'Report Abuse']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v ?? 'Coins Not Credited'),
            ),
          ),
          Expanded(
            child: _tickets.isEmpty
                ? const Center(
                    child: Text(
                      'How can we help?\nSend a message or payment screenshot below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _tickets.length,
                    itemBuilder: (_, i) {
                      final t = _tickets[i];
                      final reply = t['admin_reply'] as String?;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('[${t['category'] ?? 'Support'}]', style: const TextStyle(fontSize: 10, color: Colors.amber)),
                                  Text(t['message'] ?? '', style: const TextStyle(color: Colors.white)),
                                  if (t['screenshot_base64'] != null)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: Text('📎 Screenshot Attached ✓', style: TextStyle(fontSize: 11, color: Colors.tealAccent)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (reply != null && reply.isNotEmpty)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.tealAccent.withOpacity(0.4)),
                                ),
                                child: Text('Admin: $reply', style: const TextStyle(color: Colors.tealAccent)),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),
          if (_screenshotBase64 != null)
            Container(
              color: Colors.teal.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.image, color: Colors.tealAccent, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Payment screenshot attached', style: TextStyle(fontSize: 12))),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => setState(() => _screenshotBase64 = null),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF0F172A),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate, color: Colors.tealAccent, size: 28),
                  onPressed: _pickScreenshot,
                ),
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Type a message or attach receipt...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: Icon(_sending ? Icons.hourglass_top : Icons.send, color: Colors.tealAccent),
                  onPressed: _sending ? null : _sendTicket,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLang = 'English';
  String _cacheSize = '14.20MB';

  Widget _tile(String title, {String? trailingText, VoidCallback? onTap, Color? color}) {
    return ListTile(
      title: Text(title, style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }

  void _openLanguageSheet() {
    final langs = [
      'Follow System',
      'English',
      'Afaan Oromoo',
      'አማርኛ',
      'العربية',
      'Français',
      'Español',
      'Türkçe',
      'Tiếng Việt',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      builder: (_) => ListView.builder(
        itemCount: langs.length,
        itemBuilder: (ctx, i) {
          final l = langs[i];
          return ListTile(
            title: Text(l),
            trailing: _selectedLang == l ? const Icon(Icons.check_circle, color: Colors.tealAccent) : null,
            onTap: () {
              setState(() => _selectedLang = l);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(backgroundColor: Colors.green, content: Text('Language set to $l')),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    AppState.isLoggedIn = false;
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const EthioVoiceApp()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                _tile('Account Manager', trailingText: AppState.userId, onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account ID: ${AppState.userId} • Verified')),
                  );
                }),
                const Divider(height: 1, color: Colors.white10),
                _tile('Message Settings', onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Room & Direct Message notifications enabled')),
                  );
                }),
                const Divider(height: 1, color: Colors.white10),
                _tile('Language Setting', trailingText: _selectedLang, onTap: _openLanguageSheet),
                const Divider(height: 1, color: Colors.white10),
                _tile('Network Line', trailingText: 'Auto (Fast)', onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(backgroundColor: Colors.green, content: Text('Connected to optimal voice server')),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                _tile('Privilege Settings', onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Microphone & Storage permissions active')),
                  );
                }),
                const Divider(height: 1, color: Colors.white10),
                _tile('Blocked Users', trailingText: '0', onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No blocked users')),
                  );
                }),
                const Divider(height: 1, color: Colors.white10),
                _tile('Report Abuse / Safety', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportChatPage()));
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                _tile('Clear Cache', trailingText: _cacheSize, onTap: () {
                  setState(() => _cacheSize = '0.00MB');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(backgroundColor: Colors.green, content: Text('Cache cleared!')),
                  );
                }),
                const Divider(height: 1, color: Colors.white10),
                _tile('About Us', trailingText: 'v3.0.5', onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Voice Chat ET',
                    applicationVersion: 'v3.0.5 (Build 8)',
                    children: const [Text('Official Ethiopian & Global Voice Chat & Live Party Platform.')],
                  );
                }),
                const Divider(height: 1, color: Colors.white10),
                _tile('Delete Account', color: Colors.orangeAccent, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportChatPage()));
                }),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              foregroundColor: Colors.redAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _signOut,
            child: const Text('Sign Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
      ),
  );
}
 }
class OfficialAgentsDirectoryPage extends StatefulWidget {
  const OfficialAgentsDirectoryPage({super.key);
  @override
  State<OfficialAgentsDirectoryPage> createState() => _OfficialAgentsDirectoryPageState();
}

class _OfficialAgentsDirectoryPageState extends State<OfficialAgentsDirectoryPage> {
static const String baseApi = 'https://jimma-server.onrender.com';
  List<dynamic> _agents = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    try {
      final res = await http.get(Uri.parse('$baseApi/api/agency/overview')).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 && mounted) {
        setState(() {
          _agents = jsonDecode(res.body)['agencies'] ?? [];
          _loading = false;
        });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  void _copy(String label, String val) {
    Clipboard.setData(ClipboardData(text: val));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('✅ $label copied: $val')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Official Coin Sellers & Agents')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Card(
                  color: const Color(0xFF1E293B),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('👑 Official Headquarters (Founder Direct)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                        const SizedBox(height: 8),
                        const Text('• CBE: 1000273060937 (MOHAMMEDSABIT)\n• Telebirr / WhatsApp: +251919108311\n• Telegram: @Mosabit11\n• USDT (TRC20): TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE', style: TextStyle(height: 1.5)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: ElevatedButton(onPressed: () => _copy('Telegram', '@Mosabit11'), child: const Text('Copy Telegram'))),
                            const SizedBox(width: 8),
                            Expanded(child: ElevatedButton(onPressed: () => _copy('WhatsApp/Telebirr', '+251919108311'), child: const Text('Copy WhatsApp'))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Verified Regional & International Agents', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                const SizedBox(height: 8),
                ..._agents.map((ag) => Card(
                      color: const Color(0xFF1E293B),
                      child: ListTile(
                        title: Text('${ag['agency_name']} (${ag['agency_code']})', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Agent: ${ag['owner_name']} | UID: ${ag['owner_uid']}\nBanks/Telebirr/TG/WA: ${ag['phone'] ?? ''}'),
                        trailing: Text('${ag['coin_stock']} Coins', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        onTap: () => _copy('Agent Contact', '${ag['phone'] ?? ''}'),
                      ),
                    )),
              ],
            ),
    );
            ],
        ),
    );
  }
}

class AgencyWebPortalPage extends StatefulWidget {
  @override
  State<AgencyWebPortalPage> createState() => _AgencyWebPortalPageState();
}

class _AgencyWebPortalPageState extends State<AgencyWebPortalPage> {
  static const String baseApi = 'https://jimma-server.onrender.com';
  final _pass = TextEditingController(), _ac = TextEditingController(), _an = TextEditingController(), _ou = TextEditingController(), _on = TextEditingController(), _pay = TextEditingController(), _stk = TextEditingController();
  final _sac = TextEditingController(), _sto = TextEditingController(), _samt = TextEditingController(), _setb = TextEditingController();
  final _pac = TextEditingController(), _phu = TextEditingController(), _phn = TextEditingController(), _pdi = TextEditingController();
  bool _unlocked = false, _busy = false;
  List<dynamic> _agencies = [], _members = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final res = await http.get(Uri.parse('$baseApi/api/agency/overview')).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 && mounted) {
        final d = jsonDecode(res.body);
        setState(() {
          _agencies = d['agencies'] ?? [];
          _members = d['members'] ?? [];
        });
      }
    } catch (_) {}
  }

  void _msg(String t, {bool ok = true}) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: ok ? Colors.green : Colors.red, content: Text(t)));
  }

  Future<void> _post(String path, Map<String, dynamic> body, String okMsg) async {
    setState(() => _busy = true);
    try {
      final res = await http.post(Uri.parse('$baseApi$path'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
      final d = jsonDecode(res.body);
      if (d['ok'] == true) {
        _msg(okMsg);
        await _refresh();
      } else {
        _msg(d['msg'] ?? 'Failed', ok: false);
      }
    } catch (_) {
      _msg('Network error', ok: false);
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agency, Coin Seller & Payroll')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Hire / Create Agency (Founder Only)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                  if (!_unlocked) ...[
                    TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Founder Password')),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                      onPressed: () => _pass.text.trim() == '142730' ? setState(() => _unlocked = true) : _msg('Wrong Password', ok: false),
                      child: const Text('Unlock Agency Creator'),
                    ),
                  ] else ...[
                    TextField(controller: _ac, decoration: const InputDecoration(labelText: 'Agency Code (e.g. AG102)')),
                    TextField(controller: _an, decoration: const InputDecoration(labelText: 'Agency Name')),
                    TextField(controller: _ou, decoration: const InputDecoration(labelText: 'Agent UID')),
                    TextField(controller: _on, decoration: const InputDecoration(labelText: 'Agent Full Name')),
                    TextField(controller: _pay, decoration: const InputDecoration(labelText: 'Telebirr, Banks, Telegram & WhatsApp')),
                    TextField(controller: _stk, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Initial Coin Stock')),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                      onPressed: _busy ? null : () => _post('/api/agency/create', {'agency_code': _ac.text.trim(), 'agency_name': _an.text.trim(), 'owner_uid': _ou.text.trim(), 'owner_name': _on.text.trim(), 'phone': _pay.text.trim(), 'coin_stock': int.tryParse(_stk.text.trim()) ?? 0}, '✅ Agency Created!'),
                      child: const Text('Create Agency'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('2. Agent Coin Sale (Reseller -> User UID)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                  TextField(controller: _sac, decoration: const InputDecoration(labelText: 'Agency Code')),
                  TextField(controller: _sto, decoration: const InputDecoration(labelText: 'Buyer User UID')),
                  TextField(controller: _samt, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Coins Amount')),
                  TextField(controller: _setb, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (ETB/USDT)')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),                   
                     onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('✅ Agent Coin Sale Processed!')));
                      },
                      child: const Text('Send Coins to User', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

         class TaskCenterFullPage extends StatefulWidget {
  final VoidCallback onUpd;
  const TaskCenterFullPage({super.key, required this.onUpd});
  @override
  State<TaskCenterFullPage> createState() => _TaskCenterFullPageState();
}

class _TaskCenterFullPageState extends State<TaskCenterFullPage> {
  final Set<String> _claimed = {};
  void _claim(String id, int coins) {
    if (_claimed.contains(id)) return;
    setState(() {
      _claimed.add(id);
      AppState.coins += coins;
    });
    widget.onUpd();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('🎉 Claimed +$coins Coins!')));
  }

  Widget _taskTile(String id, String title, String sub, int reward) {
    final done = _claimed.contains(id);
    return Card(
      color: const Color(0xFF1E293B),
      child: ListTile(
        leading: const Icon(Icons.monetization_on, color: Colors.amber),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$sub • +$reward Coins', style: const TextStyle(color: Colors.amberAccent)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: done ? Colors.grey : Colors.tealAccent, foregroundColor: Colors.black),
          onPressed: done ? null : () => _claim(id, reward),
          child: Text(done ? 'Done' : 'Claim'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Center'),
          bottom: const TabBar(tabs: [Tab(text: 'Tasks'), Tab(text: 'Host Tasks'), Tab(text: 'Events')]),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _taskTile('t1', 'Stay in a Room for 5 Minutes', 'Daily Activity (5/5)', 500),
                _taskTile('t2', 'Follow 5 Hosts', 'Social Bonus (5/5)', 300),
                _taskTile('t3', 'Play Ludo 3D Once', 'Game Bonus (1/1)', 200),
                _taskTile('t4', 'Play 8 Ball Pool Once', 'Game Bonus (1/1)', 200),
                _taskTile('t5', 'Spend 6,000 Coins', 'VIP Task (6K/6K)', 600),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Card(color: Color(0xFF1E293B), child: ListTile(title: Text('Hourly Host Tiers'), subtitle: Text('Upgrade: H 600/h • 1200/h • 3000/h • 5000/h'))),
                _taskTile('h1', 'On Mic for 2 Hours', 'Host Daily Target (120 mins)', 1200),
                _taskTile('h2', 'Join Party & Crowned for 1 Hour', 'Room Host Reward', 800),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _taskTile('e1', 'VIP Daily Rewards', 'Exclusive VIP Event Bonus', 5000),
                _taskTile('e2', 'Weekly Top Gifter & Host Event', 'Weekend Super Bonus', 2500),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WealthCharmLevelPage extends StatelessWidget {
  const WealthCharmLevelPage({super.key});
  @override
  Widget build(BuildContext context) {
    final wLv = (AppState.coins ~/ 10000) + 1;
    final cLv = (AppState.points.toInt() ~/ 500) + 1;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Level & Privileges'), bottom: const TabBar(tabs: [Tab(text: 'Wealth'), Tab(text: 'Charm')])),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Card(color: const Color(0xFF1E293B), child: ListTile(title: Text('Wealth Lv.$wLv', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)), subtitle: Text('Current Balance: ${AppState.coins} Coins'))),
                const Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.redeem, color: Colors.redAccent), title: Text('Lv.5 — Room Red Packet'), subtitle: Text('Send lucky red packets in audio rooms'))),
                const Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.visibility, color: Colors.tealAccent), title: Text('Lv.10 — Audio Room Entry Banner'), subtitle: Text('Special entrance badge when joining rooms'))),
                const Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.workspace_premium, color: Colors.amber), title: Text('Lv.20 — Royal Aura & Frame'), subtitle: Text('Exclusive golden seat frame in all rooms'))),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Card(color: const Color(0xFF1E293B), child: ListTile(title: Text('Charm Lv.$cLv', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pinkAccent)), subtitle: Text('Diamonds Balance: ${AppState.points.toStringAsFixed(2)}'))),
                const Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.favorite, color: Colors.pinkAccent), title: Text('Charm Star Privileges'), subtitle: Text('Higher diamond-to-ETB/USDT cashout priority'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HostCenterPage extends StatelessWidget {
  final VoidCallback onUpd;
  const HostCenterPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Host Center')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: 
    Card(color: const Color(0xFF1E293B), child: ListTile(title: const Text('My Diamonds Balance'), subtitle: Text('${AppState.points.toStringAsFixed(2)} Diamonds'), trailing: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointsCashOutPage(onUpd: onUpd))), child: const Text('Cash Out')))),

 Card(color: Color(0xFF1E293B), child: ListTile(title: Text('Host Revenue Split'), subtitle: Text('• 70% Direct Host Payout (CBE / Telebirr / USDT)\n• 15% Agency Management Bonus\n• Join an Official Agency to unlock weekly salary!'))),
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
      appBar: AppBar(title: const Text('About Voice Chat ET')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          color: Color(0xFF1E293B),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Voice Chat ET (v3.0.9)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                SizedBox(height: 8),
                Text('Ethiopia & International Live Audio Rooms, 3D Social Games, Official Agencies, and Real-Time Rewards Platform.\n\nSupport: @Mosabit11 | +251919108311'),
              ],
            ),
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
    final code = 'ET${AppState.userId}';
    return Scaffold(
      appBar: AppBar(title: const Text('Invitation Rewards')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: const Color(0xFF1E293B),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Invite Friends & Earn +1,000 Coins Each!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                const SizedBox(height: 10),
                SelectableText('Your Invite Code: $code', style: const TextStyle(fontSize: 18, color: Colors.tealAccent)),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () { Clipboard.setData(ClipboardData(text: 'Join Voice Chat ET with my code $code!')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Invite Link Copied!'))); }, child: const Text('Copy Invite Link')),
              ],
            ),
          ),
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
      appBar: AppBar(title: const Text('My Backpack')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: const [
          Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.directions_car, color: Colors.amber), title: Text('Golden Lion Entry Car'), subtitle: Text('Active • 7 Days Remaining'))),
          Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.stars, color: Colors.cyanAccent), title: Text('VIP Royal Mic Frame'), subtitle: Text('Equipped'))),
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
      appBar: AppBar(title: const Text('Lucky Island Spin')),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
          onPressed: () {
            if (AppState.coins < 100) return;
            AppState.coins += 200;
            onUpd();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('🎉 Lucky Island Won +200 Coins!')));
          },
          child: const Text('Spin Lucky Island (100 Coins)', style: TextStyle(fontWeight: FontWeight.bold)),
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
      appBar: AppBar(title: const Text('My Badges')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: const [
          Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.verified, color: Colors.amber), title: Text('Pioneer Member Badge'), subtitle: Text('Unlocked on registration'))),
          Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.local_fire_department, color: Colors.redAccent), title: Text('Top Gifter Badge'), subtitle: Text('Send 10,000+ Coins in rooms'))),
        ],
      ),
    );
  }
}
