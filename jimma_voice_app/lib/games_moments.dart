import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';

class GamesTab extends StatefulWidget {
  final VoidCallback onUpd;
  const GamesTab({super.key, required this.onUpd});
  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  String _cat = 'Hot';
  final _cats = List<String>.of({'Latest', 'Hot', 'Slot', 'Fishing', 'Multi Player'});

  final _games = List<Map<String, dynamic>>.of({
    {'name': 'Ocean Hunt', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF023E8A, 'c2': 0xFF0077B6, 'ic': '🐙🎰', 'syms': List<String>.of({'🐙', '🦈', '🐡', '💎', '👑'})},
    {'name': 'Jungle Hunt', 'cat': 'Hot', 'tag': 'HOT', 'c1': 0xFF1B4332, 'c2': 0xFF40916C, 'ic': '🦁🌴', 'syms': List<String>.of({'🦁', '🐯', '🌴', '💎', '🪙'})},
    {'name': 'Royal Battle', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF590D22, 'c2': 0xFFA4133C, 'ic': '👑⚔️', 'syms': List<String>.of({'👑', '⚔️', '🛡️', '💎', '🔥'})},
    {'name': 'Garo Gems III', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFF3C096C, 'c2': 0xFF7B2CBF, 'ic': '🏺💎', 'syms': List<String>.of({'💎', '🏺', '🔮', '👑', '⭐'})},
    {'name': 'Fruit Party', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF004B23, 'c2': 0xFF38B000, 'ic': '🍓🍊', 'syms': List<String>.of({'🍓', '🍊', '🍉', '🍇', '7️⃣'})},
    {'name': 'Fishing Tycoon', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF03045E, 'c2': 0xFF0096C7, 'ic': '🦈⚓', 'syms': List<String>.of({'🦈', '🐋', '⚓', '💰', '💎'})},
    {'name': 'Money Coming', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF7F5539, 'c2': 0xFFB08968, 'ic': '💵🎡', 'syms': List<String>.of({'💵', '🪙', '💰', '🎡', '👑'})},
    {'name': 'The Monkey King', 'cat': 'Hot', 'tag': 'HOT', 'c1': 0xFF6A040F, 'c2': 0xFFD00000, 'ic': '🐒🔥', 'syms': List<String>.of({'🐒', '🔥', '🍑', '👑', '💎'})},
    {'name': 'Blaze Of Fortune', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFF9D0208, 'c2': 0xFFE85D04, 'ic': '🔥💎', 'syms': List<String>.of({'🔥', '💎', '⚡', '👑', '🪙'})},
    {'name': 'Lucky Piggy', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF7209B7, 'c2': 0xFFF72585, 'ic': '🐷💰', 'syms': List<String>.of({'🐷', '💰', '🪙', '🍀', '💎'})},
    {'name': 'Fortune Rabbit', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF800F2F, 'c2': 0xFFFF4D6D, 'ic': '🐰🧧', 'syms': List<String>.of({'🐰', '🧧', '🪙', '🌸', '👑'})},
    {'name': 'Gates Of Olympus', 'cat': 'Hot', 'tag': 'HOT', 'c1': 0xFF1D3557, 'c2': 0xFF457B9D, 'ic': '⚡🏛️', 'syms': List<String>.of({'⚡', '🏛️', '👑', '💎', '🔥'})},
    {'name': 'Lucky 77 Pro', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF370617, 'c2': 0xFF9D0208, 'ic': '7️⃣🔔', 'syms': List<String>.of({'7️⃣', '🔔', '🍒', '💎', '🪙'})},
    {'name': 'Fortune Tiger', 'cat': 'Hot', 'tag': 'HOT', 'c1': 0xFF7F4F24, 'c2': 0xFFCA6702, 'ic': '🐯🪙', 'syms': List<String>.of({'🐯', '🪙', '🧧', '💎', '👑'})},
    {'name': 'Roulette Royal', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF003049, 'c2': 0xFFD62828, 'ic': '🎡♠️', 'syms': List<String>.of({'🎡', '♠️', '♥️', '♦️', '👑'})},
    {'name': 'Deep Sea', 'cat': 'Fishing', 'tag': 'NEW', 'c1': 0xFF001219, 'c2': 0xFF0A9396, 'ic': '🐋🧜‍♀️', 'syms': List<String>.of({'🐋', '🐙', '🐚', '💎', '🪙'})},
    {'name': 'Color Game', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF240046, 'c2': 0xFF5A189A, 'ic': '🎲🎨', 'syms': List<String>.of({'🔴', '🟢', '🟡', '🔵', '👑'})},
    {'name': 'World Goal 2026', 'cat': 'Multi Player', 'tag': 'NEW', 'c1': 0xFF081C15, 'c2': 0xFF2D6A4F, 'ic': '⚽🏆', 'syms': List<String>.of({'⚽', '🏆', '🥇', '🔥', '👑'})},
    {'name': 'Sweet Bonanza', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF590D22, 'c2': 0xFFFF758F, 'ic': '🍭🍬', 'syms': List<String>.of({'🍭', '🍬', '🍇', '🍉', '💎'})},
    {'name': 'Dragon Ball', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFF540B0E, 'c2': 0xFFE09F3E, 'ic': '🐉🔮', 'syms': List<String>.of({'🐉', '🔮', '🔥', '⭐', '👑'})},
    {'name': 'Super Ace', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF10002B, 'c2': 0xFF7B2CBF, 'ic': '🃏👑', 'syms': List<String>.of({'🃏', '👑', '♠️', '💎', '🪙'})},
    {'name': 'Chicken Road', 'cat': 'Latest', 'tag': 'HOT', 'c1': 0xFF335C67, 'c2': 0xFFE09F3E, 'ic': '🐔🛣️', 'syms': List<String>.of({'🐔', '🥚', '🔥', '💰', '👑'})},
    {'name': 'Teen Patti', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF1B4332, 'c2': 0xFF52B788, 'ic': '🎴💎', 'syms': List<String>.of({'🎴', '♠️', '♥️', '💎', '👑'})},
    {'name': 'Ludo King Party', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF003566, 'c2': 0xFFFFC300, 'ic': '🎲👑', 'syms': List<String>.of({'🎲', '👑', '🔴', '🟢', '🟡'})},
  });

  void _openFullGame(Map<String, dynamic> g) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenGameArena(game: g, onUpd: () { setState(() {}); widget.onUpd(); })));
  }

  void _convertCoins() {
    if (AppState.coins < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 10,000 Coins required to convert!')));
      return;
    }
    setState(() { AppState.coins -= 10000; AppState.points += 9000; });
    widget.onUpd();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Converted 10,000 Coins ➔ 9,000 Points!')));
  }

  @override
  Widget build(BuildContext context) {
    final list = _games.where((g) => g['cat'] == _cat || (_cat == 'Hot' && g['tag'] == 'HOT')).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Games • 🪙 ${AppState.coins}'),
        actions: List<Widget>.of({
          TextButton.icon(onPressed: _convertCoins, icon: const Icon(Icons.swap_horiz, color: Colors.tealAccent), label: const Text('Coins➔Pts', style: TextStyle(color: Colors.tealAccent))),
        }),
      ),
      body: Column(children: List<Widget>.of({
        SizedBox(
          height: 46,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: _cats.length,
            itemBuilder: (_, i) {
              final c = _cats.elementAt(i);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(label: Text(c), selected: _cat == c, selectedColor: Colors.teal.shade700, onSelected: (_) => setState(() => _cat = c)),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final g = list.elementAt(i);
              return InkWell(
                onTap: () => _openFullGame(g),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Color(g['c1'] as int), Color(g['c2'] as int)]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.withOpacity(0.55), width: 1.4),
                  ),
                  child: Stack(children: List<Widget>.of({
                    Positioned(top: 6, right: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: g['tag'] == 'HOT' ? Colors.redAccent : Colors.green, borderRadius: BorderRadius.circular(8)), child: Text(g['tag'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)))),
                    Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
                      Text(g['ic'] as String, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(g['name'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    }))),
                  })),
                ),
              );
            },
          ),
        ),
      })),
    );
  }
}

class FullScreenGameArena extends StatefulWidget {
  final Map<String, dynamic> game;
  final VoidCallback onUpd;
  const FullScreenGameArena({super.key, required this.game, required this.onUpd});
  @override
  State<FullScreenGameArena> createState() => _FullScreenGameArenaState();
}

class _FullScreenGameArenaState extends State<FullScreenGameArena> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final _bets = List<int>.of({100, 500, 1000, 5000, 10000});
  int _bet = 100;
  bool _spinning = false;
  String _status = 'Select Bet & Tap SPIN to Win 3X!';
  List<String> _reels = List<String>.of({'💎', '👑', '🪙'});

  @override
  void initState() {
    super.initState();
    final syms = widget.game['syms'] as List<String>;
    _reels = List<String>.of({syms.elementAt(0), syms.elementAt(1), syms.elementAt(2)});
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..addListener(() {
      if (_spinning) {
        final r = Random();
        setState(() {
          _reels = List<String>.of({syms.elementAt(r.nextInt(syms.length)), syms.elementAt(r.nextInt(syms.length)), syms.elementAt(r.nextInt(syms.length))});
        });
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _spin() async {
    if (_spinning) return;
    if (AppState.coins < _bet) {
      setState(() => _status = '⚠️ Not enough Coins! Recharge first.');
      return;
    }
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    setState(() { _spinning = true; AppState.coins -= _bet; _status = '🎰 Spinning... Good Luck!'; });
    widget.onUpd();
    _ctrl.repeat();
    await Future.delayed(const Duration(milliseconds: 1300));
    _ctrl.stop();
    final r = Random();
    final syms = widget.game['syms'] as List<String>;
    final win = r.nextInt(100) < 35;
    setState(() {
      _spinning = false;
      if (win) {
        final s = syms.elementAt(r.nextInt(syms.length));
        _reels = List<String>.of({s, s, s});
        final prize = _bet * 3;
        AppState.coins += prize;
        _status = '🎉 JACKPOT WIN! +$prize Coins!';
        HapticFeedback.heavyImpact();
      } else {
        _reels = List<String>.of({syms.elementAt(0), syms.elementAt(1), syms.elementAt(2)});
        _status = 'Try Again! Next spin could be 3X!';
      }
    });
    widget.onUpd();
  }

  @override
  Widget build(BuildContext context) {
    final c1 = Color(widget.game['c1'] as int);
    final c2 = Color(widget.game['c2'] as int);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: RadialGradient(center: Alignment.topCenter, radius: 1.3, colors: <Color>[c2, c1, const Color(0xFF090D16)])),
        child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Navigator.pop(context)),
                Text('${widget.game['ic']} ${widget.game['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber)), child: Text('🪙 ${AppState.coins}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber))),
              })),
            ),
            Column(children: List<Widget>.of({
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.55), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.amber, width: 2.5)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: _reels.map((sym) => AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 82, height: 96,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFF1E293B), Color(0xFF0F172A)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: _spinning ? Colors.tealAccent : Colors.amber, width: 2)),
                  child: Text(sym, style: const TextStyle(fontSize: 44)),
                )).toList()),
              ),
              const SizedBox(height: 16),
              Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)), child: Text(_status, style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 14))),
            })),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFF111827), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              child: Column(children: List<Widget>.of({
                Wrap(spacing: 8, children: _bets.map((b) => ChoiceChip(label: Text('🪙 $b'), selected: _bet == b, selectedColor: Colors.amber, labelStyle: TextStyle(color: _bet == b ? Colors.black : Colors.white, fontWeight: FontWeight.bold), onSelected: (_) => setState(() => _bet = b))).toList()),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: _spinning ? null : _spin,
                  child: Text(_spinning ? 'SPINNING...' : '🎰 SPIN & WIN ($_bet Coins)', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              })),
            ),
          })),
        ),
      ),
    );
  }
}
class MomentsTab extends StatefulWidget {
  final VoidCallback onUpd;
  const MomentsTab({super.key, required this.onUpd});
  @override
  State<MomentsTab> createState() => _MomentsTabState();
}

class _MomentsTabState extends State<MomentsTab> {
  final _picker = ImagePicker();
  String _filter = 'All';

  void _newPost() {
    final c = TextEditingController();
    String tag = '#EthioVoice';
    String? imgPath;
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) => StatefulBuilder(builder: (ctx, setB) => Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
        const Text('Share a Moment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextField(controller: c, maxLines: 3, decoration: const InputDecoration(hintText: 'Write something positive...')),
        Row(children: List<Widget>.of({
          TextButton.icon(onPressed: () async { final XFile? f = await _picker.pickImage(source: ImageSource.gallery); if (f != null) setB(() => imgPath = f.path); }, icon: const Icon(Icons.photo, color: Colors.amber), label: Text(imgPath == null ? 'Add Photo' : 'Photo Added')),
          const Spacer(),
          DropdownButton<String>(value: tag, items: List<String>.of({'#EthioVoice', '#OromoCulture', '#VoiceParty'}).map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setB(() => tag = v ?? '#EthioVoice')),
        })),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 44)), onPressed: () {
          if (AppState.hasProfanity(c.text)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('⚠️ Abusive words are strictly prohibited!')));
            return;
          }
          if (c.text.trim().isNotEmpty || imgPath != null) {
            AppState.moments.insert(0, {'user': AppState.userName, 'tag': tag, 'text': c.text.trim(), 'likes': '1', 'img': imgPath ?? ''});
            setState(() {});
            Navigator.pop(ctx);
          }
        }, child: const Text('Post Moment')),
      })),
    )));
  }

  @override
  Widget build(BuildContext context) {
    final list = _filter == 'All' ? AppState.moments : AppState.moments.where((m) => m['tag'] == _filter).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Moments'), actions: List<Widget>.of({IconButton(icon: const Icon(Icons.add_a_photo, color: Colors.amber), onPressed: _newPost)})),
      body: Column(children: List<Widget>.of({
        Wrap(spacing: 8, children: List<String>.of({'All', '#EthioVoice', '#OromoCulture', '#VoiceParty'}).map((t) => ChoiceChip(label: Text(t), selected: _filter == t, onSelected: (_) => setState(() => _filter = t))).toList()),
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: list.length, itemBuilder: (_, i) {
          final m = list.elementAt(i);
          final img = m['img'] ?? '';
          return Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
            Row(children: List<Widget>.of({const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person, color: Colors.black)), const SizedBox(width: 10), Text(m['user'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(), Chip(label: Text(m['tag'] ?? '', style: const TextStyle(fontSize: 11)))})),
            if ((m['text'] ?? '').isNotEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(m['text'] ?? '')),
            if (img.isNotEmpty && !kIsWeb) ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(img), height: 180, width: double.infinity, fit: BoxFit.cover)),
            Row(children: List<Widget>.of({
              IconButton(icon: const Icon(Icons.favorite, color: Colors.redAccent), onPressed: () => setState(() => m['likes'] = '${(int.tryParse(m['likes'] ?? '0') ?? 0) + 1}')),
              Text('${m['likes']} Likes'),
            })),
          }))));
        })),
      })),
    );
  }
}

class MessagesTab extends StatefulWidget {
  final VoidCallback onUpd;
  const MessagesTab({super.key, required this.onUpd});
  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  final _msgCtrl = TextEditingController();
  final _picker = ImagePicker();

  void _sendText() {
    final t = _msgCtrl.text.trim();
    if (t.isEmpty) return;
    if (AppState.hasProfanity(t)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('⚠️ Abusive language is not allowed!')));
      return;
    }
    setState(() { AppState.chatMessages.add({'sender': AppState.userName, 'type': 'text', 'content': t, 'time': 'Now'}); _msgCtrl.clear(); });
  }

  Future<void> _sendPhoto() async {
    final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => AppState.chatMessages.add({'sender': AppState.userName, 'type': 'image', 'content': f.path, 'time': 'Now'}));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(title: const Text('Messages (100% Free)'), bottom: TabBar(tabs: List<Widget>.of({const Tab(text: 'Free Chat'), const Tab(text: 'Notifications')}))),
      body: TabBarView(children: List<Widget>.of({
        Column(children: List<Widget>.of({
          Expanded(child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: AppState.chatMessages.length, itemBuilder: (_, i) {
            final m = AppState.chatMessages.elementAt(i);
            final isMe = m['sender'] == AppState.userName;
            return Align(alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isMe ? Colors.teal.shade800 : const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
              Text(m['sender'] ?? '', style: const TextStyle(fontSize: 10, color: Colors.amber)),
              if (m['type'] == 'image' && !kIsWeb) ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(m['content'] ?? ''), width: 170, height: 130, fit: BoxFit.cover)) else Text(m['content'] ?? ''),
            }))));
          })),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: const Color(0xFF111827),
              child: Row(children: List<Widget>.of({
                IconButton(icon: const Icon(Icons.photo, color: Colors.amber), onPressed: _sendPhoto),
                Expanded(child: TextField(controller: _msgCtrl, decoration: const InputDecoration(hintText: 'Free message or User ID...', border: InputBorder.none))),
                IconButton(icon: const Icon(Icons.send, color: Colors.tealAccent), onPressed: _sendText),
              })),
            ),
          ),
        })),
        ListView.builder(padding: const EdgeInsets.all(12), itemCount: AppState.notifications.length, itemBuilder: (_, i) {
          final n = AppState.notifications.elementAt(i);
          return Card(child: ListTile(leading: const Icon(Icons.notifications_active, color: Colors.amber), title: Text(n['title'] ?? ''), subtitle: Text(n['body'] ?? '')));
        }),
      })),
    ));
  }
}
