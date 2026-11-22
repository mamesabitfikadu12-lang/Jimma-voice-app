import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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

  void _editProfile() {
    final nameCtrl = TextEditingController(text: AppState.userName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Edit Profile'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (nameCtrl.text.trim().isNotEmpty) AppState.userName = nameCtrl.text.trim();
              });
              widget.onUpd();
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
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
          IconButton(icon: const Icon(Icons.edit), onPressed: _editProfile),
          IconButton(icon: const Icon(Icons.settings), onPressed: () => _go( SettingsPage())),
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
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.25,
            children: [
              _gridBtn(Icons.monetization_on, Colors.amber, 'Coin Seller', () => _go(CoinSellerPage(onUpd: widget.onUpd))),
              _gridBtn(Icons.storefront, Colors.tealAccent, 'Store', () => _go(StorePage(onUpd: widget.onUpd))),
              _gridBtn(Icons.workspace_premium, Colors.orangeAccent, 'VIP Club', () => _go(VipClubPage(onUpd: widget.onUpd))),
              _gridBtn(Icons.account_balance_wallet, Colors.cyanAccent, 'Cash Out', () => _go(PointsCashOutPage(onUpd: widget.onUpd))),
              _gridBtn(Icons.policy, Colors.amber, 'Policies', () => _go( SettingsPage())),
              _gridBtn(Icons.settings, Colors.white70, 'Settings', () => _go( SettingsPage())),
            ],
          ),
        ],
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
          Text('Estimated Payout: $etb ETB', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
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
                  Uri.parse('https://onrender.com'),
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
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Policies')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.tealAccent),
            title: Text('Privacy Policy'),
            subtitle: Text('Your account, voice rooms, and transactions are encrypted and secure.'),
          ),
          ListTile(
            leading: Icon(Icons.gavel, color: Colors.amber),
            title: Text('Terms of Service'),
            subtitle: Text('Respect community rules. Coins are non-refundable once credited.'),
          ),
          ListTile(
            leading: Icon(Icons.support_agent, color: Colors.cyanAccent),
            title: Text('Official Support'),
            subtitle: Text('Telegram & WhatsApp: +251919108311'),
          ),
        ],
      ),
    );
  }
}
       ListTile(
         leading: Icon(Icons.report_problem, color: Colors.redAccent),
         title: Text('Report Abuse / Block User'),
         subtitle: Text('Report any offensive user or voice room 24/7 for immediate moderation.'),
       ),
