
import 'package:flutter/material.dart';
import 'main.dart';

class UsdtCashoutRequest {
  final String userName;
  final String userId;
  final String method;
  final String walletOrAgency;
  final int points;
  final double usdtAmount;
  final DateTime time;

  UsdtCashoutRequest({
    required this.userName,
    required this.userId,
    required this.method,
    required this.walletOrAgency,
    required this.points,
    required this.usdtAmount,
    required this.time,
  });
}

class GlobalUsdtLedger {
  static final List<UsdtCashoutRequest> requests = <UsdtCashoutRequest>[];
}

class UsdtGlobalCashoutPage extends StatefulWidget {
  final VoidCallback onUpdated;
  const UsdtGlobalCashoutPage({super.key, required this.onUpdated});

  @override
  State<UsdtGlobalCashoutPage> createState() => _UsdtGlobalCashoutPageState();
}

class _UsdtGlobalCashoutPageState extends State<UsdtGlobalCashoutPage> {
  String _network = 'USDT (TRC20)';
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _pointsCtrl = TextEditingController(text: '10000');

  @override
  void dispose() {
    _addressCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  void _submitRequest() {
    final pts = int.tryParse(_pointsCtrl.text.trim()) ?? 0;
    final addr = _addressCtrl.text.trim();
    if (pts < 5000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Minimum cashout is 5,000 Creator Points.')));
      return;
    }
    if (addr.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid USDT Wallet Address or Agency ID.')));
      return;
    }
    if (AppState.points < pts) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient Creator Points balance.')));
      return;
    }

    final usdtValue = pts / 1000.0;
    setState(() {
      AppState.points -= pts;
      GlobalUsdtLedger.requests.insert(
        0,
        UsdtCashoutRequest(
          userName: AppState.userName,
          userId: AppState.userId,
          method: _network,
          walletOrAgency: addr,
          points: pts,
          usdtAmount: usdtValue,
          time: DateTime.now(),
        ),
      );
    });
    widget.onUpdated();
    _addressCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Submitted \$${usdtValue.toStringAsFixed(2)} USDT request to Admin Panel!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ptsPreview = int.tryParse(_pointsCtrl.text.trim()) ?? 0;
    final usdtPreview = (ptsPreview / 1000.0).toStringAsFixed(2);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101826),
        title: const Text('🌐 Global USDT & Agency Reward'),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: <Widget>[
        Card(
          color: const Color(0xFF14213D),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text('Available Creator Points: ${AppState.points} pts', style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Rate: 1,000 Creator Points = 1.00 USDT (Min: 5,000 pts)', style: TextStyle(fontSize: 12, color: Colors.white70)),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _network,
          dropdownColor: const Color(0xFF14213D),
          decoration: const InputDecoration(labelText: 'Payout Method', border: OutlineInputBorder()),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'USDT (TRC20)', child: Text('USDT (TRC20 - Tron Network)')),
            DropdownMenuItem<String>(value: 'USDT (BEP20)', child: Text('USDT (BEP20 - BSC Network)')),
            DropdownMenuItem<String>(value: 'Coin Seller Agency', child: Text('Coin Seller Agency Transfer (P2P)')),
          ],
          onChanged: (v) => setState(() => _network = v ?? 'USDT (TRC20)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _pointsCtrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'Points to Redeem (Est: \$$usdtPreview USDT)',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _addressCtrl,
          decoration: InputDecoration(
            labelText: _network == 'Coin Seller Agency' ? 'Agency Code / Seller ID' : 'Your $_network Wallet Address',
            hintText: _network == 'Coin Seller Agency' ? 'e.g. ETH-AG-77' : 'e.g. TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 14)),
            icon: const Icon(Icons.currency_exchange, color: Colors.black),
            label: Text('Request \$$usdtPreview USDT Payout', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            onPressed: _submitRequest,
          ),
        ),
        const Divider(height: 32, color: Colors.white12),
        const Text('📋 Recent Global Payout Requests (Admin View)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
        const SizedBox(height: 8),
        if (GlobalUsdtLedger.requests.isEmpty)
          const Text('No USDT payout requests yet.', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ...GlobalUsdtLedger.requests.map((r) => Card(
          color: Colors.white10,
          child: ListTile(
            title: Text('${r.userName} (ID:${r.userId}) • \$${r.usdtAmount.toStringAsFixed(2)} USDT', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('${r.method}: ${r.walletOrAgency}\nPoints: ${r.points} pts', style: const TextStyle(fontSize: 11)),
            trailing: const Chip(backgroundColor: Colors.amber, label: Text('Pending', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold))),
          ),
        )),
      ]),
    );
  }
}
