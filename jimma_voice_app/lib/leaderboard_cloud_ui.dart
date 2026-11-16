
import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';
import 'voice_cloud_service.dart';

class TopLeaderboardPage extends StatefulWidget {
  const TopLeaderboardPage({super.key});
  @override
  State<TopLeaderboardPage> createState() => _TopLeaderboardPageState();
}

class _TopLeaderboardPageState extends State<TopLeaderboardPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _gifters = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _hosts = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await CloudSyncService.fetchLeaderboard();
    final g = (data['topGifters'] as List<dynamic>? ?? <dynamic>[]).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    final h = (data['topHosts'] as List<dynamic>? ?? <dynamic>[]).map((e) => Map<String, dynamic>.from(e as Map)).toList();
    if (mounted) {
      setState(() {
        _gifters = g;
        _hosts = h;
        _loading = false;
      });
    }
  }

  Widget _buildList(List<Map<String, dynamic>> items, String valueKey, String unitLabel, Color accent) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: Colors.amber));
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          final rank = i + 1;
          final medal = rank == 1 ? '🥇' : (rank == 2 ? '🥈' : (rank == 3 ? '🥉' : '#$rank'));
          return Card(
            color: rank <= 3 ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: rank == 1 ? Colors.amber : accent.withOpacity(0.3)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: rank == 1 ? Colors.amber : accent.withOpacity(0.2),
                child: Text(medal, style: TextStyle(fontWeight: FontWeight.bold, color: rank == 1 ? Colors.black : Colors.white)),
              ),
              title: Text('${item['name']} (VIP ${item['vipLevel'] ?? 0})', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Text('ID: ${item['uid']}', style: const TextStyle(fontSize: 11, color: Colors.white60)),
              trailing: Text('$unitLabel ${item[valueKey] ?? 0}', style: TextStyle(fontWeight: FontWeight.w900, color: accent, fontSize: 14)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🏆 Daily & Weekly Leaderboard'),
          actions: <Widget>[IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            tabs: <Tab>[
              Tab(text: '👑 Top Gifters (Wealth)'),
              Tab(text: '🎙️ Top Hosts (Charisma)'),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[
          _buildList(_gifters, 'gifted', '🪙', Colors.amber),
          _buildList(_hosts, 'received', '💎', Colors.tealAccent),
        ]),
      ),
    );
  }
}

class CloudReceiptsAdminTab extends StatefulWidget {
  final VoidCallback onUpd;
  const CloudReceiptsAdminTab({super.key, required this.onUpd});
  @override
  State<CloudReceiptsAdminTab> createState() => _CloudReceiptsAdminTabState();
}

class _CloudReceiptsAdminTabState extends State<CloudReceiptsAdminTab> {
  bool _loading = true;
  List<Map<String, dynamic>> _list = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final res = await CloudSyncService.fetchPendingRecharges();
    if (mounted) {
      setState(() {
        _list = res;
        _loading = false;
      });
    }
  }

  void _viewImage(String b64) {
    if (b64.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No screenshot attached!')));
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Screenshot'),
        content: Image.memory(base64Decode(b64), fit: BoxFit.contain),
        actions: <Widget>[TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: Colors.amber));
    if (_list.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Text('No Cloud ETB Screenshots yet.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 8),
          ElevatedButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: const Text('Refresh')),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _list.length,
      itemBuilder: (_, i) {
        final item = _list[i];
        final isPending = item['status'] == 'Pending';
        return Card(
          color: const Color(0xFF1E293B),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text('${item['name']} (ID: ${item['uid']})', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
              Text('Method: ${item['method']} • ${item['etb']} ETB ➔ 🪙 ${item['coins']} Coins', style: const TextStyle(fontSize: 12)),
              Text('Status: ${item['status']}', style: TextStyle(fontSize: 12, color: isPending ? Colors.orangeAccent : Colors.greenAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: <Widget>[
                OutlinedButton.icon(
                  onPressed: () => _viewImage((item['screenshotBase64'] ?? '').toString()),
                  icon: const Icon(Icons.image, size: 16),
                  label: const Text('View Receipt'),
                ),
                const SizedBox(width: 8),
                if (isPending)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    onPressed: () async {
                      final ok = await CloudSyncService.approveRecharge((item['id'] ?? '').toString());
                      if (ok) {
                        if ((item['uid'] ?? '').toString() == AppState.userId) {
                          AppState.coins += (item['coins'] as num?)?.toInt() ?? 0;
                        }
                        widget.onUpd();
                        _load();
                      }
                    },
                    child: const Text('Confirm & Release'),
                  ),
              ]),
            ]),
          ),
        );
      },
    );
  }
}
